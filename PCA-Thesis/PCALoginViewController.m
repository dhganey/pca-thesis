//
//  PCAViewController.m
//  PCA-Thesis
//
//  Created by David Ganey on 4/13/14.
//  Copyright (c) 2014 dhganey. All rights reserved.
//

#import "PCALoginViewController.h"

@interface PCALoginViewController ()

@end

@implementation PCALoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //[self.view setBackgroundColor:[UIColor clearColor]];
    
    if ([CatalyzeUser currentUser]) //if someone is logged in
    {
        [self performSegueWithIdentifier:@"doneLoggingSegue" sender:self];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

/**
 Called before view appears. Used to empty the password field
 @param animated BOOL
 @return void
 */
-(void) viewWillAppear:(BOOL)animated
{
    self.passwordField.text = @""; //empty the password field
}

/**
 Called when touches begin. Used to hide keyboard
 @param touches NSSet* of touches
 @param event UIEvent*
 @return void
 */
-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.usernameField resignFirstResponder];
    [self.passwordField resignFirstResponder];
    [self.view endEditing:YES];
}

/**
 Called when login button is pressed by user
 @param sender id of login button
 @return IBAction
 */
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
            [PCADefinitions showAlert:LOGIN_ERROR];
        }];
    }
    else //if user input is invalid
    {
        [PCADefinitions showAlert:INVALID_INPUT];
    }
}

/**
 Called when finished logging in. Segues to the main view controller.
 @return void
 */
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
        [self performSegueWithIdentifier:@"doneLoggingInPatientSegue" sender:self];
    }
}

/**
 Called before executing a segue. Determines whether to execute doctor query early
 @param segue to be executed
 @param sender id of sender
 @return void
 */
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UINavigationController* destinationNC = segue.destinationViewController;
    UIViewController* nextVC = [[destinationNC viewControllers] objectAtIndex:0];
    if ([nextVC isKindOfClass:[PCAPatientTableViewController class]])
    {
        PCAPatientTableViewController* realNextVC = [[destinationNC viewControllers] objectAtIndex:0];
        [realNextVC queryUserTranslations];
        [realNextVC executeQuery];
    }
}

/**
 Ensures that the length of inputted username and password is at least 1
 @return BOOL
 */
-(BOOL) validateInput
{
    BOOL ok = true;
    
    ok = ok && ([self.usernameField.text length] > 0);
    ok = ok && ([self.passwordField.text length] > 0);
    
    return ok;
}

/**
 Called when signup pressed. Segues to signup controller
 @param sender id of signup button
 @return IBAction
 */
- (IBAction)signupPressed:(id)sender
{
    [self performSegueWithIdentifier:@"signupSegue" sender:self];
}

/**
 Called when "change password" pressed. Creates a Catalyze HTTP request and sends it to change the password
 User receives an email with a web form to change the password (handled by Catalyze)
 @param sender id of button
 @return IBAction
 */
- (IBAction)forgotPasswordPressed:(id)sender
{
    if (self.usernameField.text.length > 0)
    {
        NSString* requestString = [NSString stringWithFormat:@"/%@/reset/user/%@", [Catalyze applicationId], self.usernameField.text];
        [CatalyzeHTTPManager doGet:requestString success:^(id result)
         {
             [[[UIAlertView alloc] initWithTitle:@"Success" message:@"Please check your email to complete the reset process." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
         } failure:^(NSDictionary *result, int status, NSError *error)
         {
             NSLog(@"password reset failed %@", result);
         }];
    }
    else
    {
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enter a username" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    }
}
@end
