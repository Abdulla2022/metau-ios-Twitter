//
//  TimelineViewController.m
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "TimelineViewController.h"
#import "APIManager.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "TweetCell.h"
#import "User.h"
#import "Tweet.h"
#import "ComposeViewController.h"
#import "DetailsViewController.h"
@interface TimelineViewController ()< ComposeViewControllerDelegate,UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) NSMutableArray *myMutableArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation TimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.delegate = self;
    self.tableView.dataSource= self;
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
    [self.tableView insertSubview:refreshControl atIndex:0];
    [self getTimeline];
}
- (void) getTimeline {
    [[APIManager shared] getHomeTimelineWithCompletion:^(NSArray<Tweet *> *tweets, NSError *error) {
        if (tweets) {
            NSLog(@"😎😎😎 Successfully loaded home timeline");
            for (Tweet *tweet in tweets) {
                NSString *text = tweet.text;
                NSLog(@"%@", text);
                self.myMutableArray = (NSMutableArray *)tweets;
                [self.tableView reloadData];
            }
        } else {
            NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
        }
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.myMutableArray.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    Tweet *tweet = self.myMutableArray[indexPath.row];
    
    cell.tweet = tweet;
    cell.userName.text = tweet.user.name;
    cell.profileName.text = tweet.user.screenName;
    cell.userTweet.text = tweet.text;
    cell.retweetLabel.text = [NSString stringWithFormat:@"%d", tweet.retweetCount];
    cell.favorLabel.text = [NSString stringWithFormat:@"%d", tweet.favoriteCount];
    NSString *URLString = tweet.user.profilePicture;
    NSURL *url = [NSURL URLWithString:URLString];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    cell.userImage.image=[UIImage imageWithData:urlData];
    cell.dateLabel.text = tweet.createdAtString;
    return cell;
    
    
//    NSString *URLString =
//    NSURL *url = [NSURL URLWithString:URLString];
//    NSData *urlData = [NSData dataWithContentsOfURL:url];
}

- (IBAction)didTouchLogout:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    appDelegate.window.rootViewController = loginViewController;
    [[APIManager shared] logout];
}

- (void)beginRefresh:(UIRefreshControl *)refreshControl {
    [self getTimeline];
    [self.tableView reloadData];
   // Tell the refreshControl to stop spinning
    [refreshControl endRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
}

- (void)didTapTweet:(Tweet *)tweet{
    [self.myMutableArray addObject:tweet];
    [self.tableView reloadData];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
// TimelineViewController.m
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"composeSegue"]){
        
        UINavigationController *navigationController = [segue destinationViewController];
        ComposeViewController *composeController = (ComposeViewController*)navigationController.topViewController;
        composeController.delegate = self;
    }else if([segue.identifier isEqualToString:@"detailsSegue"]){
        NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
        Tweet *dataToPass = self.myMutableArray[indexPath.row];
        DetailsViewController *detailsVC = [segue destinationViewController];
        detailsVC.tweet = dataToPass;
    }
}

//Ω

@end
