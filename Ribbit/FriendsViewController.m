//
//  FriendsViewController.m
//  Ribbit
//
//  Created by Sebastian Bastidas on 6/10/14.
//  Copyright (c) 2014 Adtq. All rights reserved.
//

#import "FriendsViewController.h"
#import "EditFriendsViewController.h"

@interface FriendsViewController ()

@end

@implementation FriendsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.friendsRelation =[[PFUser currentUser] objectForKey:@"friendsRelation"];
   
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    PFQuery *query=[self.friendsRelation query];
    [query orderByAscending:@"username"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error)
        {
            NSLog(@"Error %@ %@", error, error.userInfo);
        }
        else
        {
            self.friends = objects;
            [self.tableView reloadData];
        }
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
 return self.friends.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    PFUser *user = [self.friends objectAtIndex:indexPath.row];
    cell.textLabel.text=user.username;
    
    return cell;
}






#pragma mark - Navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showEditFriends"])
    {
        EditFriendsViewController *viewController= (EditFriendsViewController *)segue.destinationViewController;
        viewController.friends=[NSMutableArray arrayWithArray:self.friends];
    }
}


@end
