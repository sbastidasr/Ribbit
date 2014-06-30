//
//  InboxViewController.h
//  Ribbit
//
//  Created by Sebastian Bastidas on 6/7/14.
//  Copyright (c) 2014 Adtq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <MediaPlayer/MediaPlayer.h>

@interface InboxViewController : UITableViewController
@property (nonatomic,strong)NSArray *messages;
@property (nonatomic,strong)PFObject *selectedMessage;
@property (nonatomic,strong)MPMoviePlayerController *moviePlayer;
- (IBAction)logout:(id)sender;


@end
