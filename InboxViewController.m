//
//  InboxViewController.m
//  Ribbit
//
//  Created by Sebastian Bastidas on 6/7/14.
//  Copyright (c) 2014 Adtq. All rights reserved.
//

#import "InboxViewController.h"
#import "ImageViewController.h"


@interface InboxViewController ()

@end

@implementation InboxViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.moviePlayer= [[MPMoviePlayerController alloc]init];
    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
    } else {
    [self performSegueWithIdentifier:@"showLogin" sender:self];
      
    }
    
   
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    PFQuery *query =[PFQuery queryWithClassName:@"Messages"];
    [query whereKey:@"recipientsIds" equalTo:[[PFUser currentUser]objectId]];
    [query orderByDescending:@"createdAt"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error)
        {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
        else
        {
            //we found mesasages
            self.messages = objects;
            [self.tableView reloadData];
       //     NSLog(@"Retrived %d",self.messages.count);
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
    return self.messages.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    PFObject *message = [self.messages objectAtIndex:indexPath.row];
    NSString *fileType =[message objectForKey:@"fileType"];
    cell.textLabel.text= [message objectForKey:@"senderName"];
    
    if([fileType isEqualToString:@"image"]){
        cell.imageView.image=[UIImage imageNamed:@"icon_image"];
    }
    else
    {
        cell.imageView.image=[UIImage imageNamed:@"icon_video"];
    }
    return cell;
}

#pragma mark - Navigation

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.selectedMessage =[self.messages objectAtIndex:indexPath.row];
    NSString *fileType =[self.selectedMessage objectForKey:@"fileType"];
    
    if([fileType isEqualToString:@"image"]){
        [self performSegueWithIdentifier:@"showImage" sender:self];
    }
    else
    {
        //
        PFFile *videoFile = [self.selectedMessage objectForKey:@"file"];
        NSURL *fileUrl = [NSURL URLWithString:videoFile.url];
        self.moviePlayer.contentURL=fileUrl;
        [self.moviePlayer prepareToPlay];
        
        //add to the view controller stack
        [self.view addSubview:self.moviePlayer.view];
        [self.moviePlayer setFullscreen:YES];
       // [self.moviePlayer thumbnailImageAtTime:0 timeOption:MPMovieTimeOptionNearestKeyFrame];
    }
    NSMutableArray *recipientIds = [NSMutableArray arrayWithArray:[self.selectedMessage objectForKey:@"recipientIds"]];
    NSLog(@"Recipients %@", recipientIds);
    
    if (recipientIds.count ==1)
    {
        // last recipietns delete
        [self.selectedMessage deleteInBackground];
    }
    else
    {
    //remove the recipient and sav it
        [recipientIds removeObject:[[PFUser currentUser] objectId]];
        [self.selectedMessage setObject:recipientIds forKey:@"recipientIds"];
        [self.selectedMessage saveInBackground];
        
    }
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"showLogin"])
    {
        [segue.destinationViewController setHidesBottomBarWhenPushed:YES];
    }
    else if ([segue.identifier isEqualToString:@"showImage"] )
    {
        [segue.destinationViewController setHidesBottomBarWhenPushed:YES];
        ImageViewController *imageViewController =(ImageViewController *)segue.destinationViewController;
        imageViewController.message = self.selectedMessage;
        

    }
}

- (IBAction)logout:(id)sender {
    [PFUser logOut];
    [self performSegueWithIdentifier:@"showLogin" sender:self];
}

@end
