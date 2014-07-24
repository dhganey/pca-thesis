//
//  PCAViewController.m
//  PCA-Thesis
//
//  Created by David Ganey on 4/13/14.
//  Copyright (c) 2014 dhganey. All rights reserved.
//

#import "PCALoginViewController.h"

#import "Catalyze.h"

@interface PCALoginViewController ()

@end

@implementation PCALoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([CatalyzeUser currentUser]) //if someone is logged in
    {
        [self performSegueWithIdentifier:@"doneLoggingSegue" sender:self];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void) viewWillAppear:(BOOL)animated
{
    self.passwordField.text = @""; //empty the password field
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.usernameField resignFirstResponder];
    [self.passwordField resignFirstResponder];
    [self.view endEditing:YES];
}

- (IBAction)loginPressed:(id)sender
{
    [self.view endEditing:YES];
    
    if ([self validateInput]) //if the user has entered appropriate information
    {
        [CatalyzeUser logInWithUsernameInBackground:self.usernameField.text password:self.passwordField.text block:^(int status, NSString *response, NSError *error)
         {
             NSLog(@"%d %@", status, response); //log the response and status
             
             if (error)
             {
                 [self showAlert:1];
             }
             else
             {
                 //TODO: user logged in, perform some sort of segue
                 NSLog(@"Logged in successfully");
                 [self performSegueWithIdentifier:@"doneLoggingSegue" sender:self];
             }
         }];
    }
    else //if user input is invalid
    {
        [self showAlert:0];
    }
}

//Shows an alert with different text depending on passed error code
-(void) showAlert: (int) code
{
    NSString *errorMessage = @"There was a problem. Please try again";
    switch (code)
    {
        case 0: //invalid input
            errorMessage = @"Invalid input. Please try again";
            break;
        case 1: //login error
            errorMessage = @"Something went wrong while logging in. Please try again";
            break;
        default:
            break;
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops!"
                                                    message:errorMessage
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
}

//Ensures that the length of inputted username and password is at least 1
-(BOOL) validateInput
{
    BOOL ok = true;
    
    ok = ok && ([self.usernameField.text length] > 0);
    ok = ok && ([self.passwordField.text length] > 0);
    
    return ok;
}


- (IBAction)signupPressed:(id)sender
{
    [self performSegueWithIdentifier:@"signupSegue" sender:self];
}
@end
