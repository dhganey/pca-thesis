//
//  PCASignupViewController.m
//  PCA-Thesis
//
//  Created by David Ganey on 7/20/14.
//  Copyright (c) 2014 dhganey. All rights reserved.
//

#import "PCASignupViewController.h"

#import "Catalyze.h"

@interface PCASignupViewController ()

@end

@implementation PCASignupViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)signupPressed:(id)sender
{
    if ([self validateInput])
    {
        Email* userEmail = [[Email alloc] init];
        [userEmail setPrimary:self.emailField.text];
        
        Name* fullName = [[Name alloc] init];
        [fullName setFirstName:self.firstNameField.text];
        [fullName setLastName:self.lastNameField.text];
        
        [CatalyzeUser signUpWithUsernameInBackground:self.usernameField.text email:userEmail name:fullName password:self.passwordField.text block:^(int status, NSString *response, NSError *error)
        {
            if (error)
            {
                [self showAlert:1];
            }
            else
            {
                NSLog(@"signed up successfully");
                //TODO: perform some sort of segue
            }
        }];
    }
    else //input not valid
    {
        [self showAlert:0];
    }
}

//Ensures user input is valid
-(BOOL)validateInput
{
    BOOL ok = true;
    
    ok = ok && ([self.firstNameField.text length] > 0);
    ok = ok && ([self.lastNameField.text length] > 0);
    ok = ok && ([self.usernameField.text length] > 0);
    ok = ok && ([self.passwordField.text length] > 0);
    ok = ok && ([self.passwordField2.text length] > 0);
    ok = ok && ([self.phoneField.text length] > 0);
    ok = ok && ([self.emailField.text length] > 0);
    
    ok = ok && [self.passwordField.text isEqualToString:self.passwordField2.text]; //ensure passwords are the same
    
    return ok;
}

-(void) showAlert:(int) code
{
    NSString *errorMessage;
    
    switch(code)
    {
        case 0:
            errorMessage = @"Input invalid. Please try again";
            break;
        case 1:
            errorMessage = @"There was a problem signing up. Please try again";
            break;
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops!"
                                                    message:errorMessage
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}
@end
