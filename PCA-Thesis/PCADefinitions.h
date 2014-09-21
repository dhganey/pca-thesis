//
//  PCADefinitions.h
//  PCA-Thesis
//
//  Created by David Ganey on 8/24/14.
//  Copyright (c) 2014 dhganey. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PCADefinitions : NSObject

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

typedef enum
{
    SLIDER = 0,
    RADIO
} INPUT_TYPE;

typedef enum
{
    INVALID_INPUT = 0,
    LOGIN_ERROR,
    SIGNUP_ERROR,
    USERNAME_TAKEN,
    NO_USER_LOGGED_IN,
    LOGOUT_ERROR,
    NOTHING_SELECTED
} ERROR_TYPE;

typedef enum
{
    CANCEL = 0,
    CONTINUE
} BUTTON_VALUE;

typedef enum
{
    DONE_ENTERING = 0,
    NO_NEED
} ALL_DONE_TYPE;


-(void) showAlert: (ERROR_TYPE) type;

@end
