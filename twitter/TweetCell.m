//
//  TweetCell.m
//  twitter
//
//  Created by Abdullahi Ahmed on 6/22/22.
//  Copyright © 2022 Emerson Malca. All rights reserved.
//

#import "TweetCell.h"
#import "APIManager.h"
#import "DateTools.h"
@implementation TweetCell

- (void)awakeFromNib {
    [super awakeFromNib];

    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)messageButton:(id)sender {
    
}

- (IBAction)favoButton:(id)sender {
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

- (IBAction)retweetButton:(id)sender {
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



- (IBAction)replyButton:(id)sender {
}
- (void) refreshFavoData{
    if(self.tweet.favorited == YES){
        self.favorLabel.text = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount];
        [self.favoButton setImage:[UIImage imageNamed:@"favor-icon-red"] forState:(UIControlStateNormal)];
    }
    if(self.tweet.favorited == NO){
        self.favorLabel.text = [NSString stringWithFormat:@"%d", self.tweet.favoriteCount];
        [self.favoButton setImage:[UIImage imageNamed:@"favor-icon"] forState:(UIControlStateNormal)];
    }
}
- (void) refreshretweetData{
    if(self.tweet.retweeted == YES){
        self.retweetLabel.text = [NSString stringWithFormat:@"%d", self.tweet.retweetCount];
        [self.retweetButton setImage:[UIImage imageNamed:@"retweet-icon-green"] forState:(UIControlStateNormal)];
    }
    if(self.tweet.retweeted == NO){
        self.retweetLabel.text = [NSString stringWithFormat:@"%d", self.tweet.retweetCount];
        [self.retweetButton setImage:[UIImage imageNamed:@"retweet-icon"] forState:(UIControlStateNormal)];
    }
}

@end
