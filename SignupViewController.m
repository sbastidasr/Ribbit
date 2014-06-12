//
//  SignupViewController.m
//  Ribbit
//
//  Created by Sebastian Bastidas on 6/8/14.
//  Copyright (c) 2014 Adtq. All rights reserved.
//

#import "SignupViewController.h"
#import <Parse/Parse.h>

@interface SignupViewController ()

@end

@implementation SignupViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (IBAction)signUp:(id)sender {
    NSString *username = [self.usernameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *password = [self.passwordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *email = [self.emailField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if (username.length ==0 || password.length == 0 || email.length ==0 )
    {
        UIAlertView *alertVew=[[UIAlertView alloc]initWithTitle:@"Oops" message:@"Make Sure you enter a username, password and email." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alertVew show];
    }
    else
    {
        PFUser *newUser = [PFUser user];
        newUser.username=username;
        newUser.email=email;
        newUser.password=password;
        
        [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (error)
            {
                //Handle error
                UIAlertView *alertView =[[UIAlertView alloc]initWithTitle:@"Sorry!" message:[error.userInfo objectForKey:@"error"] delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil, nil];
                [alertView show];
            }
            else
            {
                [self.navigationController popToRootViewControllerAnimated:YES];
            }
        }];
        
        
        
       
    }
}
@end
