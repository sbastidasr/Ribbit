//
//  SignupViewController.h
//  Ribbit
//
//  Created by Sebastian Bastidas on 6/8/14.
//  Copyright (c) 2014 Adtq. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignupViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *emailField;

- (IBAction)signUp:(id)sender;

@end
