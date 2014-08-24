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
    MAX_SYMPTOMS = 10
} SYMPTOMS;

typedef enum
{
    SLIDER = 0,
    RADIO
} INPUT_TYPE;

@end
