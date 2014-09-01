//
//  PCADefinitions.m
//  PCA-Thesis
//
//  Created by David Ganey on 8/24/14.
//  Copyright (c) 2014 dhganey. All rights reserved.
//

#import "PCADefinitions.h"

@implementation PCADefinitions

//Shows an alert with different text depending on passed error code
-(void) showAlert: (ERROR_TYPE) type
{
    NSString *errorMessage = @"There was a problem. Please try again";
    switch (type)
    {
        case INVALID_INPUT:
            errorMessage = @"Invalid input. Please try again";
            break;
        case LOGIN_ERROR:
            errorMessage = @"Something went wrong while logging in. Please try again";
            break;
        case SIGNUP_ERROR:
            errorMessage = @"There was a problem signing up. Please try again";
            break;
        case USERNAME_TAKEN:
            errorMessage = @"Sorry, that username is already taken. Please try another";
            break;
        case NO_USER_LOGGED_IN:
            errorMessage = @"No user is logged in";
            break;
        case LOGOUT_ERROR:
            errorMessage = @"Error while logging out, please try again";
            break;
        case NOTHING_SELECTED:
            errorMessage = @"Please select an option";
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
