//
//  PCAAppDelegate.h
//  PCA-Thesis
//
//  Created by David Ganey on 4/13/14.
//  Copyright (c) 2014 dhganey. All rights reserved.
//

#pragma once

#import <UIKit/UIKit.h>

#import "PCADefinitions.h"

@interface PCAAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

/**
 The singleton PCADefinitions object used throughout the app to call static functions (e.g. showAlert)
 @warning Make sure to initialize an object of the AppDelegate as a property in each VC before trying to use this object
 */
@property PCADefinitions* defObj;

/**
 Define some colors for navigation bar customization
 */
#define RED 10.0f
#define GREEN 4.0f
#define BLUE 199.0f
#define BASE 255.0f
#define ALPHA 1.0f

@end
