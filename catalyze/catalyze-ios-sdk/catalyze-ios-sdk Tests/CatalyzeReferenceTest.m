/*
 * Copyright (C) 2013 catalyze.io, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 *    you may not use this file except in compliance with the License.
 *    You may obtain a copy of the License at
 *
 *        http://www.apache.org/licenses/LICENSE-2.0
 *
 *    Unless required by applicable law or agreed to in writing, software
 *    distributed under the License is distributed on an "AS IS" BASIS,
 *    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *    See the License for the specific language governing permissions and
 *    limitations under the License.
 */

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "Catalyze.h"
#import "CatalyzeTest.h"

@interface CatalyzeReferenceTest : CatalyzeTest

@end

@implementation CatalyzeReferenceTest
static const NSString * const className = @"medications";

//class level
+ (void)setUp {
    [super setUp];
    
    __block BOOL finished = NO;
    
    NSDictionary *customClass = @{@"name":className, @"schema":@{@"medication":@"string", @"frequency":@"integer"}};
    [CatalyzeHTTPManager doPost:@"/classes" withParams:customClass success:^(id result) {
        finished = YES;
    } failure:^(NSDictionary *result, int status, NSError *error) {
        [NSException raise:@"CustomClassException" format:@"Could not create the custom class"];
    }];
    NSDate *loopUntil = [NSDate dateWithTimeIntervalSinceNow:10];
    while (finished == NO && [loopUntil timeIntervalSinceNow] > 0) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:loopUntil];
    }
}

+ (void)tearDown {
    __block BOOL finished = NO;
    
    [CatalyzeHTTPManager doDelete:[NSString stringWithFormat:@"/classes/%@", className] success:^(id result) {
        finished = YES;
    } failure:^(NSDictionary *result, int status, NSError *error) {
        [NSException raise:@"CustomClassException" format:@"Could not delete the custom class"];
    }];
    
    NSDate *loopUntil = [NSDate dateWithTimeIntervalSinceNow:10];
    while (finished == NO && [loopUntil timeIntervalSinceNow] > 0) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:loopUntil];
    }
    if (!finished) {
        [NSException raise:@"TeardownException" format:@"Could not properly execute %s", __PRETTY_FUNCTION__];
    }
    [super tearDown];
}

//method level
- (void)setUp {
    [super setUp];
    
}

- (void)tearDown {
    
    [super tearDown];
}

@end
