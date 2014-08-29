//
//  PCAViewController.m
//  PCA-Thesis
//
//  Created by David Ganey on 4/13/14.
//  Copyright (c) 2014 dhganey. All rights reserved.
//

#import "PCALoginViewController.h"
#import "PCAAppDelegate.h"

#import "Catalyze.h"

#import "PCADefinitions.h"

@interface PCALoginViewController ()

@end

@implementation PCALoginViewController

PCAAppDelegate* appDel;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([CatalyzeUser currentUser]) //if someone is logged in
    {
        [self performSegueWithIdentifier:@"doneLoggingSegue" sender:self];
    }
    
    appDel = [[UIApplication sharedApplication] delegate];
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
        [CatalyzeUser logInWithUsernameInBackground:self.usernameField.text password:self.passwordField.text success:^(CatalyzeUser *result)
        {
            NSLog(@"Logged in successfully");
            
            [self completeLoginSegue];
        }
        failure:^(NSDictionary *result, int status, NSError *error) //callback if login fails
        {
            [appDel.defObj showAlert:LOGIN_ERROR];
        }];
    }
    else //if user input is invalid
    {
        [appDel.defObj showAlert:INVALID_INPUT];
    }
}

-(void) completeLoginSegue
{
    if ([[CatalyzeUser currentUser].type isEqualToString:@"patient"])
    {
        [self performSegueWithIdentifier:@"doneLoggingInPatientSegue" sender:self];
    }
    else if ([[CatalyzeUser currentUser].type isEqualToString:@"doctor"])
    {
        [self performSegueWithIdentifier:@"doneLoggingInDoctorSegue" sender:self];
    }
    else
    {
        NSLog(@"current user type not set");
        //TODO: adjust this, currently just segueing as a patient by default
        [self performSegueWithIdentifier:@"doneLoggingInPatientSegue" sender:self];
    }
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
