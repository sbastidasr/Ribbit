//
//  ImageViewController.h
//  Ribbit
//
//  Created by Sebastian Bastidas on 6/18/14.
//  Copyright (c) 2014 Adtq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface ImageViewController : UIViewController
@property(nonatomic,strong)PFObject *message;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
- (void)timeout;
@end
