//
//  PCAViewController.h
//  PCA-Thesis
//
//  Created by David Ganey on 4/13/14.
//  Copyright (c) 2014 dhganey. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Catalyze.h"
#import "PCADefinitions.h"
#import "PCAPatientTableViewController.h"

@interface PCALoginViewController : UIViewController

/**
 UITextfield for username
 */
@property (weak, nonatomic) IBOutlet UITextField *usernameField;

/**
 UITextfield for password
 */
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

- (IBAction)loginPressed:(id)sender;
- (IBAction)signupPressed:(id)sender;
- (IBAction)forgotPasswordPressed:(id)sender;
@end
