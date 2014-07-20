//
//  CatalyzeObjectProtocol.h
//  catalyze-ios-sdk
//
//  Created by Josh Ault on 3/23/14.
//  Copyright (c) 2014 Catalyze, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CatalyzeConstants.h"

@protocol CatalyzeObjectProtocol

@required
- (void)createInBackground;
- (void)createInBackgroundWithBlock:(CatalyzeBooleanResultBlock)block;
- (void)createInBackgroundWithTarget:(id)target selector:(SEL)selector;
- (void)saveInBackground;
- (void)saveInBackgroundWithBlock:(CatalyzeBooleanResultBlock)block;
- (void)saveInBackgroundWithTarget:(id)target selector:(SEL)selector;
- (void)retrieveInBackground;
- (void)retrieveInBackgroundWithBlock:(CatalyzeBooleanResultBlock)block;
- (void)retrieveInBackgroundWithTarget:(id)target selector:(SEL)selector;
- (void)deleteInBackground;
- (void)deleteInBackgroundWithBlock:(CatalyzeBooleanResultBlock)block;
- (void)deleteInBackgroundWithTarget:(id)target selector:(SEL)selector;
@end