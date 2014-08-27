//
//  PCASignupViewController.m
//  PCA-Thesis
//
//  Created by David Ganey on 7/20/14.
//  Copyright (c) 2014 dhganey. All rights reserved.
//

#import "PCASignupViewController.h"

#import "Catalyze.h"

#include "PCADefinitions.h"

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
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    tapGesture.cancelsTouchesInView = NO;
    [self.scrollView addGestureRecognizer:tapGesture];
}

-(void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//Responds when the user touches the screen. Used to hide keyboard
-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.usernameField resignFirstResponder];
    [self.firstNameField resignFirstResponder];
    [self.lastNameField resignFirstResponder];
    [self.passwordField resignFirstResponder];
    [self.passwordField2 resignFirstResponder];
    [self.phoneField resignFirstResponder];
    
    [self.view endEditing:YES];
}

//Hides the keyboard. Called by the gesture recognizer in viewDidLoad
-(void) dismissKeyboard
{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)signupPressed:(id)sender
{
    [self.view endEditing:YES];
    
    if ([self validateInput])
    {
        Email* userEmail = [[Email alloc] init];
        [userEmail setPrimary:self.emailField.text];
        
        Name* fullName = [[Name alloc] init];
        [fullName setFirstName:[self.firstNameField.text capitalizedString]];
        [fullName setLastName:[self.lastNameField.text capitalizedString]];
        
        [CatalyzeUser signUpWithUsernameInBackground:self.usernameField.text email:userEmail name:fullName password:self.passwordField.text success:^(CatalyzeUser *result)
        {
            //Signup successful!
            
            NSLog(@"signed up successfully");
            
            //finish adding data to the user
            
            PhoneNumber *phoneNum = [[PhoneNumber alloc] init];
            [phoneNum setPreferred:self.phoneField.text];
            [[CatalyzeUser currentUser] setPhoneNumber:phoneNum];

            [CatalyzeUser currentUser].gender =  [self.genderControl titleForSegmentAtIndex:[self.genderControl selectedSegmentIndex]];
            
             NSArray* userSymptoms = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:1], [NSNumber numberWithInt:1], [NSNumber numberWithInt:1], [NSNumber numberWithInt:1], [NSNumber numberWithInt:1], [NSNumber numberWithInt:1], [NSNumber numberWithInt:1], [NSNumber numberWithInt:1], [NSNumber numberWithInt:1], [NSNumber numberWithInt:1], [NSNumber numberWithInt:1], nil]; //by default, show all symptoms
             [[CatalyzeUser currentUser] setExtra:userSymptoms forKey:@"symptomArray"];
             
             [CatalyzeUser currentUser].type = @"patient";
             
            [[CatalyzeUser currentUser] saveInBackground];
            
            //TODO: perform some sort of segue

        }
        failure:^(NSDictionary *result, int status, NSError *error) //callback if signup fails
        {
            if (status==400)
            {
                [self showAlert:USERNAME_TAKEN];
            }
            else
            {
                [self showAlert:SIGNUP_ERROR];
            }
        }];

    }
    else //input not valid
    {
        [self showAlert:INVALID_INPUT];
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
    ok = ok && ([self.idField.text length] > 0);
    
    ok = ok && [self.passwordField.text isEqualToString:self.passwordField2.text]; //ensure passwords are the same
    
    return ok;
}

-(void) showAlert:(ERROR_TYPE) type
{
    NSString *errorMessage = @"There was a problem. Please try again";
    
    switch(type)
    {
        case INVALID_INPUT:
            errorMessage = @"Input invalid. Please try again";
            break;
        case SIGNUP_ERROR:
            errorMessage = @"There was a problem signing up. Please try again";
            break;
        case USERNAME_TAKEN:
            errorMessage = @"Sorry, that username is already taken. Please try another";
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
@end
