 //
//  LoginViewController.h
//  Ribbit
//
//  Created by Sebastian Bastidas on 6/8/14.
//  Copyright (c) 2014 Adtq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
- (IBAction)Login:(id)sender;

@end
