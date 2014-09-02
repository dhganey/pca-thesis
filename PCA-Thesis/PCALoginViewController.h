//
//  PCAViewController.h
//  PCA-Thesis
//
//  Created by David Ganey on 4/13/14.
//  Copyright (c) 2014 dhganey. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PCAAppDelegate.h"

@interface PCALoginViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

@property PCAAppDelegate* appDel;


- (IBAction)loginPressed:(id)sender;
- (IBAction)signupPressed:(id)sender;
@end
