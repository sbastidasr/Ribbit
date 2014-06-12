//
//  FriendsViewController.h
//  Ribbit
//
//  Created by Sebastian Bastidas on 6/10/14.
//  Copyright (c) 2014 Adtq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
@interface FriendsViewController : UITableViewController
@property (nonatomic, strong)PFRelation *friendsRelation;
@property (nonatomic, strong)NSArray *friends;
@end
