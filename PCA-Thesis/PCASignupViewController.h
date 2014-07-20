//
//  PCASignupViewController.h
//  PCA-Thesis
//
//  Created by David Ganey on 7/20/14.
//  Copyright (c) 2014 dhganey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PCASignupViewController : UIViewController


@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UITextField *firstNameField;
@property (weak, nonatomic) IBOutlet UITextField *lastNameField;
@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField2;
@property (weak, nonatomic) IBOutlet UITextField *emailField;
@property (weak, nonatomic) IBOutlet UITextField *phoneField;

@property (weak, nonatomic) IBOutlet UISegmentedControl *genderControl;

- (IBAction)cancelPressed:(id)sender;
- (IBAction)signupPressed:(id)sender;
@end
