//
//  PCAViewController.h
//  PCA-Thesis
//
//  Created by David Ganey on 4/13/14.
//  Copyright (c) 2014 dhganey. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <Parse/Parse.h>

@interface PCAViewController : UIViewController <PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>

- (IBAction)logOutPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *painField;
- (IBAction)submitPressed:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *previousValueLabel;

@end
