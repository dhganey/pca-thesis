//
//  PCAChangePasswordViewController.h
//  PCA-Thesis
//
//  Created by David Ganey on 3/16/15.
//  Copyright (c) 2015 dhganey. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Catalyze.h"
#import "PCADefinitions.h"

@interface PCAChangePasswordViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) IBOutlet UITextField *currentPasswordField;
@property (weak, nonatomic) IBOutlet UITextField *passwordField1;
@property (weak, nonatomic) IBOutlet UITextField *passwordField2;

- (IBAction)changePressed:(id)sender;
- (IBAction)cancelPressed:(id)sender;

@end
