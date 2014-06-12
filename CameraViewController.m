//
//  CameraViewController.m
//  Ribbit
//
//  Created by Sebastian Bastidas on 6/10/14.
//  Copyright (c) 2014 Adtq. All rights reserved.
//

#import "CameraViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>

@interface CameraViewController ()

@end

@implementation CameraViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.friendsRelation =[[PFUser currentUser] objectForKey:@"friendsRelation"];
    self.recipients = [[NSMutableArray alloc]init];
    
}
-(void)viewWillAppear:(BOOL)animated{
    
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

    if(self.image==nil &&[self.videoFilePath length]==0)
    {
        self.imagePicker =[[UIImagePickerController alloc]init];
        self.imagePicker.delegate = self;
        self.imagePicker.allowsEditing=NO;
        self.imagePicker.videoMaximumDuration = 10;
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {self.imagePicker.sourceType=UIImagePickerControllerSourceTypeCamera;}
        else
            {self.imagePicker.sourceType =UIImagePickerControllerSourceTypePhotoLibrary;}
    
        self.imagePicker.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:self.imagePicker.sourceType];
        [self presentViewController:self.imagePicker animated:NO completion:nil];
    }

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
    
    if ([self.recipients containsObject:user.objectId])
    {
        cell.accessoryType =UITableViewCellAccessoryCheckmark;
    }
    else
    {
        cell.accessoryType =UITableViewCellAccessoryNone;
    }

    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    PFUser *user =[self.friends objectAtIndex:indexPath.row];
    
    if(cell.accessoryType ==UITableViewCellAccessoryNone)
    {
        cell.accessoryType =UITableViewCellAccessoryCheckmark;
        [self.recipients addObject:user.objectId];
    }
    else
    {
        cell.accessoryType =UITableViewCellAccessoryNone;
        [self.recipients removeObject:user.objectId];
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - ImagePicker Controller delegate 
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self dismissViewControllerAnimated:NO completion:nil];
    [self.tabBarController setSelectedIndex:0];
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage]){
        //photo taken or selected
        self.image=[info objectForKey:UIImagePickerControllerOriginalImage];
        if(self.imagePicker.sourceType == UIImagePickerControllerSourceTypeCamera){
            //save the image
            UIImageWriteToSavedPhotosAlbum(self.image, nil, nil, nil);
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else{
    //video taken
        self.videoFilePath =(__bridge NSString *)([[info objectForKey:UIImagePickerControllerMediaURL] path]);
        if(self.imagePicker.sourceType == UIImagePickerControllerSourceTypeCamera){
            //save the vieo
            if(UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(self.videoFilePath))
            UISaveVideoAtPathToSavedPhotosAlbum(self.videoFilePath, nil, nil, nil);
        }
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }
}

#pragma mark - ibActions
- (void)reset {
    self.image=nil;
    self.videoFilePath=nil;
    [self.recipients removeAllObjects];
}

- (IBAction)cancel:(id)sender {
    [self reset];
    [self.tabBarController setSelectedIndex:0];
}

- (IBAction)send:(id)sender {
    if(self.image==nil && [self.videoFilePath length]==0)
    {
        UIAlertView *alertView =[[UIAlertView alloc] initWithTitle:@"Try Again!" message:@"please capture or select a video or photo" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
        [alertView show];
        [self presentViewController:self animated:NO completion:nil];
    }
    else
    {
        [self uploadMessage];
       
        [self.tabBarController setSelectedIndex:0];
    }
}

- (void)uploadMessage{
    NSData *fileData;
    NSString *fileName;
    NSString *fileType;
  
    if(self.image!=nil)
    {   //is an image
        UIImage *newImage= [self resizeImage:self.image toWidth:320.0f andHeight:480.f];
        fileData =UIImagePNGRepresentation(newImage);
        fileName=@"image.png";
        fileType=@"image";
        
    }
    else
    { //is a video
        fileData=[NSData dataWithContentsOfFile:self.videoFilePath];
        fileName=@"video.mov";
        fileType=@"video";
    }
    PFFile *file = [PFFile fileWithName:fileName data:fileData];
    [file saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if(error)
        { UIAlertView *alertView =[[UIAlertView alloc] initWithTitle:@"Error" message:@"please send message again" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
            [alertView show];}
        else
        {
            PFObject *message = [PFObject objectWithClassName:@"Messages"];
            [message setObject:file forKey:@"file"];
            [message setObject:fileType forKey:@"fileType"];
            [message setObject:self.recipients forKey:@"recipientsIds"];
            [message setObject:[[PFUser currentUser]objectId] forKey:@"senderID"];
            [message setObject:[[PFUser currentUser]username] forKey:@"senderName"];
            [message saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                
                if(error)
                { UIAlertView *alertView =[[UIAlertView alloc] initWithTitle:@"Error" message:@"please send message again" delegate:self cancelButtonTitle:@"ok" otherButtonTitles:nil];
                    [alertView show];}
                else
                {
                    //succcess
                     [self reset];
                }
            }];
        }
    }];
}

- (UIImage *)resizeImage:(UIImage *)image toWidth:(float)width andHeight:(float)height{
    CGSize newSize= CGSizeMake(width, height);   //declare size
    CGRect newRectangle= CGRectMake(0,0,width, height); //Makes rect
    UIGraphicsBeginImageContext(newSize);  //creates context from the size specified
    [self.image drawInRect:newRectangle];   //draws our image in a rectangle
    UIImage *resizedImage = UIGraphicsGetImageFromCurrentImageContext(); //gets the image from the context
    UIGraphicsEndImageContext(); //ends context
    return resizedImage;
}


@end
