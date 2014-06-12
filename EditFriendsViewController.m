//
//  EditFriendsViewController.m
//  Ribbit
//
//  Created by Sebastian Bastidas on 6/9/14.
//  Copyright (c) 2014 Adtq. All rights reserved.
//

#import "EditFriendsViewController.h"

@interface EditFriendsViewController ()

@end

@implementation EditFriendsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    PFQuery *query = [PFUser query];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error)
        {
            NSLog(@"Error %@ %@",error, [error userInfo]);
        }
        else
        {
            self.allUsers=objects;
            [self.tableView reloadData];
        }
    }];
    self.currentUser=[PFUser currentUser];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.allUsers.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier=@"Cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    PFUser *user = [self.allUsers objectAtIndex:indexPath.row];
    cell.textLabel.text = user.username;
    
    if ([self isFriend:user])
    {
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
    }
    else
    {
         cell.accessoryType=UITableViewCellAccessoryNone;
    
    }
    
    return cell;
    
}

#pragma mark - Table view delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath] ;
    
    PFUser *user = [self.allUsers objectAtIndex:indexPath.row];
    PFRelation *friendsRelation=[self.currentUser relationForKey:@"friendsRelation"];
    
    if([self isFriend:user])
    {
        //remove checkmark
        cell.accessoryType =UITableViewCellAccessoryNone;
        
        //remove from array of friends
        for (PFUser *friend in self.friends)
        {
            if ([friend.objectId isEqualToString:user.objectId])
            {
                [self.friends removeObject:friend];
                break;
            }
        }
        
        //remove from friends
        [friendsRelation removeObject:user];
        }
    
    else
    {
        cell.accessoryType=UITableViewCellAccessoryCheckmark;
        [friendsRelation addObject:user];
        [self.friends addObject:user];
    }
    
    [self.currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error)
        {
            NSLog(@"Error %@ %@", error, error.userInfo);
        }
    }];
}

#pragma mark - Navigation
/*
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
   
}*/


#pragma mark - Extra Methods

-(BOOL)isFriend:(PFUser *)user
{
    for (PFUser *friend in self.friends)
    {
        if ([friend.objectId isEqualToString:user.objectId])
        {
            return YES;
        }
    }
        return NO;
}

@end
