//
//  DetailsViewController.m
//  twitter
//
//  Created by Abdullahi Ahmed on 6/24/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import "DetailsViewController.h"
#import "TimelineViewController.h"
#import "APIManager.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "TweetCell.h"
#import "User.h"
#import "Tweet.h"
@interface DetailsViewController ()

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.userName.text = self.tweet.user.name;
    self.ProfilName.text = self.tweet.user.screenName;
    self.tweetText.text = self.tweet.text;
    self.reTweetCount.text = [NSString stringWithFormat:@"%d", self.tweet.retweetCount];
    self.likesCount.text = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount];
    NSString *URLString = self.tweet.user.profilePicture;
    NSURL *url = [NSURL URLWithString:URLString];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    self.profilImage.image =[UIImage imageWithData:urlData];
    self.dateLabel.text = self.tweet.createdAtString;
    
    // Do any additional setup after loading the view.
}
- (IBAction)didTapHome:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}
- (IBAction)didTapRetweet:(id)sender {
    if(self.tweet.retweeted == YES){
        self.tweet.retweeted = NO;
        self.tweet.retweetCount -=1;
        [[APIManager shared] reTweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                 NSLog(@"Error retweeted tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully retweeted the following Tweet: %@", tweet.text);
            }
        }];
    }else{
        self.tweet.retweeted = YES;
        self.tweet.retweetCount +=1;
        [[APIManager shared] unreTweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                 NSLog(@"Error unretweeted tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully unretweeted the following Tweet: %@", tweet.text);
            }
        }];
    }
    [self refreshretweetData];
}

- (IBAction)didTapLike:(id)sender {
    if(self.tweet.favorited == YES){
        self.tweet.favorited = NO;
        self.tweet.favoriteCount -= 1;
        [[APIManager shared] favorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
        if(error){
             NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
        }
        else{
            NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
        }
        }];
    }else{
        self.tweet.favorited = YES;
        self.tweet.favoriteCount += 1;
        [[APIManager shared] unfavorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"Error unfavoriting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully unfavorited the following Tweet: %@", tweet.text);
            }
        }];
    }
    [self refreshFavoData];
}

- (void) refreshFavoData{
    if(self.tweet.favorited == YES){
        [self.favoButton setImage:[UIImage imageNamed:@"favor-icon-red"] forState:(UIControlStateNormal)];
    }
    if(self.tweet.favorited == NO){
        [self.favoButton setImage:[UIImage imageNamed:@"favor-icon"] forState:(UIControlStateNormal)];
    }
}
- (void) refreshretweetData{
    if(self.tweet.retweeted == YES){
        [self.reTweetButton setImage:[UIImage imageNamed:@"retweet-icon-green"] forState:(UIControlStateNormal)];
    }
    if(self.tweet.retweeted == NO){
        [self.reTweetButton setImage:[UIImage imageNamed:@"retweet-icon"] forState:(UIControlStateNormal)];
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
