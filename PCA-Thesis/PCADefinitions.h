//
//  PCADefinitions.h
//  PCA-Thesis
//
//  Created by David Ganey on 8/24/14.
//  Copyright (c) 2014 dhganey. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Catalyze.h"

@interface PCADefinitions : NSObject

/**
Enumerated type for symptom names
*/
typedef enum
{
    PAIN = 0,
    ACTIVITY = 1,
    NAUSEA,
    DEPRESSION,
    ANXIETY,
    DROWSINESS,
    APPETITE,
    WEAKNESS,
    SHORTNESS_OF_BREATH,
    OTHER,
    MAX_SYMPTOMS = OTHER+1 //for for loops
} SYMPTOM;

/**
Enumerated type to distinguish between screens which use sliders and those which use segmented "radio" controls
*/
typedef enum
{
    SLIDER = 0,
    RADIO
} INPUT_TYPE;

/**
Enumerated type to distinguish types of errors.
Provides clarity in code by offloading UIAlertView functions and error message strings to PCADefinitions
*/
typedef enum
{
    INVALID_INPUT = 0,
    LOGIN_ERROR,
    SIGNUP_ERROR,
    PASSWORD_CHANGE_ERROR,
    USERNAME_TAKEN,
    NO_USER_LOGGED_IN,
    LOGOUT_ERROR,
    NOTHING_SELECTED,
    QUERY_EMPTY
} ERROR_TYPE;

/**
Enumerated type for popup selection buttons
*/
typedef enum
{
    CANCEL = 0,
    CONTINUE
} BUTTON_VALUE;

/**
Enumerated type for "doneness"
Users can complete entering symptoms in multiple ways, this distinguishes those routes
*/
typedef enum
{
    DONE_ENTERING = 0,
    NO_NEED,
    NOT_DONE,
    NOT_SET
} ALL_DONE_TYPE;

/**
Enumerated type for day of the week. There's probably an NS type for this...
*/
typedef enum
{
    SUNDAY = 1,
    MONDAY,
    TUESDAY,
    WEDNESDAY,
    THURSDAY,
    FRIDAY,
    SATURDAY
} DAYS_OF_WEEK;

-(void) showAlert: (ERROR_TYPE) type;
-(void) showAlertWithText: (NSString*) text;
-(NSString*)determineSymptomName:(int)symptom;
-(CatalyzeEntry*) findMostRecent:(NSArray*) result;

@end
