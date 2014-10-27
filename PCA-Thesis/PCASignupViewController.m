//
//  PCASignupViewController.m
//  PCA-Thesis
//
//  Created by David Ganey on 7/20/14.
//  Copyright (c) 2014 dhganey. All rights reserved.
//

#import "PCASignupViewController.h"
#import "PCAAppDelegate.h"

#import "Catalyze.h"

#import "PCADefinitions.h"

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
    self.scrollView.userInteractionEnabled = YES;
    
    self.appDel = [[UIApplication sharedApplication] delegate]; //get the singleton app delegate
}

-(void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/**
 Called when the user touches the screen. Used to hide keyboard
 @param touches NSSet* of touches
 @param event Event triggered when touched
 @return void
 */
-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.usernameField resignFirstResponder];
    [self.firstNameField resignFirstResponder];
    [self.lastNameField resignFirstResponder];
    [self.passwordField resignFirstResponder];
    [self.passwordField2 resignFirstResponder];
    [self.phoneField resignFirstResponder];
    [self.idField resignFirstResponder];
    
    [self.view endEditing:YES];
}

/**
 Hides the keyboard. Called by the gesture recognizer in viewDidLoad
 @return void
 */
-(void) dismissKeyboard
{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 Called when user presses cancel. Dismisses the view controller.
 @param sender id of cancel button
 @return IBAction
 */
- (IBAction)cancelPressed:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

/**
 Called when user presses signup. Creates the user account
 @param sender id of signup button
 @return IBAction
 */
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
            
            [[CatalyzeUser currentUser] setExtra:self.zipField.text forKey:@"zipCode"];
            
            NSArray* userSymptoms = [[NSArray alloc] initWithObjects:[NSNumber numberWithInt:1], [NSNumber numberWithInt:1], [NSNumber numberWithInt:1], [NSNumber numberWithInt:1], [NSNumber numberWithInt:1], [NSNumber numberWithInt:1], [NSNumber numberWithInt:1], [NSNumber numberWithInt:1], [NSNumber numberWithInt:1], [NSNumber numberWithInt:1], [NSNumber numberWithInt:1], nil]; //by default, show all symptoms
            
            [[CatalyzeUser currentUser] setExtra:userSymptoms forKey:@"symptomArray"];
            
            if ([self.idField.text isEqualToString:@"greysAnatomy"]) //TODO change this later, secret string given to doctors
            {
                [CatalyzeUser currentUser].type = @"doctor";
                //TODO no patient ID?
            }
            else
            {
                [CatalyzeUser currentUser].type = @"patient";
                [[CatalyzeUser currentUser] setExtra:self.idField.text forKey:@"patientID"];
            }
            
            [[CatalyzeUser currentUser] saveInBackground];
            
            [self dismissViewControllerAnimated:YES completion:nil];
        }
        failure:^(NSDictionary *result, int status, NSError *error) //callback if signup fails
        {
            if (status==400)
            {
                [self.appDel.defObj showAlert:USERNAME_TAKEN];
            }
            else
            {
                [self.appDel.defObj showAlert:SIGNUP_ERROR];
            }
        }];

    }
    else //input not valid
    {
        [self.appDel.defObj showAlert:INVALID_INPUT];
    }
}

/**
 Validates user input
 @return BOOL
 */
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
    ok = ok && ([self.zipField.text length] > 0);
    
    ok = ok && [self.passwordField.text isEqualToString:self.passwordField2.text]; //ensure passwords are the same
    
    //TODO: check email addr, phone number length
    
    return ok;
}


@end
