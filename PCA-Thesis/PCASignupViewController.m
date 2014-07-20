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

    //add observers for notifications
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:self.view.window];
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:self.view.window];
    
    //set size of scrollView
    CGSize scrollContentSize = CGSizeMake(320, 400);
    self.scrollView.contentSize = scrollContentSize;
    
    //[self.view endEditing:YES];
    
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

//Notification method to scroll when keyboard appears
-(void)keyboardWillShow:(NSNotification *) notification
{
    NSDictionary *userInfo = notification.userInfo; //save userInfo from notification
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    CGRect viewFrame = self.scrollView.frame;
    viewFrame.size.height -= (keyboardSize.height + 10); //shift up by size of keyboard
    self.scrollView.frame = viewFrame;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:.3];
    [self.scrollView setFrame:viewFrame];
    [UIView commitAnimations];
}

//Notification method to move scroll area when keyboard hides
-(void) keyboardWillHide:(NSNotification *) notification
{
    NSDictionary *userInfo = notification.userInfo; //save userInfo from notification
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    CGRect viewFrame = self.scrollView.frame;
    viewFrame.size.height += (keyboardSize.height + 10); //shift down by size of keyboard
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationBeginsFromCurrentState:YES];
    [UIView setAnimationDuration:.3];
    [self.scrollView setFrame:viewFrame];
    [UIView commitAnimations];
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
