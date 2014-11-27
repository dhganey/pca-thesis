//
//  PCASignupViewController.h
//  PCA-Thesis
//
//  Created by David Ganey on 7/20/14.
//  Copyright (c) 2014 dhganey. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PCAAppDelegate.h"
#import "TPKeyboardAvoidingScrollView.h"

@interface PCASignupViewController : UIViewController

/**
 UITextField for the user's first name
 */
@property (weak, nonatomic) IBOutlet UITextField *firstNameField;

/**
 UITextField for the user's last name
 */
@property (weak, nonatomic) IBOutlet UITextField *lastNameField;

/**
 UITextField for the username
 */
@property (weak, nonatomic) IBOutlet UITextField *usernameField;

/**
 UITextField for the user's password
 */
@property (weak, nonatomic) IBOutlet UITextField *passwordField;

/**
 UITextField to confirm the user's password
 */
@property (weak, nonatomic) IBOutlet UITextField *passwordField2;

/**
 UITextField for the user's email address
 */
@property (weak, nonatomic) IBOutlet UITextField *emailField;

/**
 UITextField for the user's phone number
 */
@property (weak, nonatomic) IBOutlet UITextField *phoneField;

/**
 UITextField for the user's patient ID
 */
@property (weak, nonatomic) IBOutlet UITextField *idField;

/**
 UITextField for the user's zip code
 */
@property (weak, nonatomic) IBOutlet UITextField *zipField;

/**
 AppDelegate reference to use defObj
 */
@property PCAAppDelegate* appDel;

/**
 UISegmentedControl for the user's gender
 */
@property (weak, nonatomic) IBOutlet UISegmentedControl *genderControl;

- (IBAction)cancelPressed:(id)sender;
- (IBAction)signupPressed:(id)sender;
@end
