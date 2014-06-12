//
//  LoginViewController.m
//  Ribbit
//
//  Created by Sebastian Bastidas on 6/8/14.
//  Copyright (c) 2014 Adtq. All rights reserved.
//

#import "LoginViewController.h"
#import <Parse/Parse.h>
@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.hidesBackButton=YES; //hides the back button in the nav

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

- (IBAction)Login:(id)sender {
        NSString *username = [self.usernameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSString *password = [self.passwordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
  
        
        if (username.length ==0 || password.length == 0 )
        {
            UIAlertView *alertVew=[[UIAlertView alloc]initWithTitle:@"Oops" message:@"Make Sure you enter a usernameand password" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alertVew show];
        }
        else
        {
            [PFUser logInWithUsernameInBackground:username password:password
                                            block:^(PFUser *user, NSError *error) {
                                                if (error)
                                                {
                                                    //Handle error
                                                    UIAlertView *alertView =[[UIAlertView alloc]initWithTitle:@"Sorry!" message:[error.userInfo objectForKey:@"error"] delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
                                                    [alertView show];
                                                }
                                                else
                                                {
                                                    [ self.navigationController popToRootViewControllerAnimated:YES];
                                                }
                                            }];
        }

}
@end
