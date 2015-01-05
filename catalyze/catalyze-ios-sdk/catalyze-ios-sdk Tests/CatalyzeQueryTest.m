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

@interface CatalyzeQueryTest : CatalyzeTest

@end

@implementation CatalyzeQueryTest
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
    
    CatalyzeEntry *entry = [CatalyzeEntry entryWithClassName:className.copy];
    NSDictionary *content = @{@"medication":@"vicodin", @"frequency":@2};
    [entry setContent:[NSMutableDictionary dictionaryWithDictionary:content]];
    
    finished = NO;
    [entry createInBackgroundWithSuccess:^(id result) {
        finished = YES;
    } failure:^(NSDictionary *result, int status, NSError *error) {
        [NSException raise:@"CustomClassException" format:@"Could not create the custom class entry"];
    }];
    
    loopUntil = [NSDate dateWithTimeIntervalSinceNow:10];
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
    [super tearDown];
}

//method level
- (void)setUp {
    [super setUp];
    
}

- (void)tearDown {
    
    [super tearDown];
}

- (void)testQuery {
    __block BOOL finished = NO;
    CatalyzeQuery *query = [CatalyzeQuery queryWithClassName:className.copy];
    [query setPageSize:10];
    [query setPageNumber:1];
    [query setQueryField:@"frequency"];
    [query setQueryValue:[NSNumber numberWithInt:2]];
    [query retrieveInBackgroundWithSuccess:^(NSArray *result) {
        XCTAssertEqual(result.count, 1);
        CatalyzeEntry *entry = (CatalyzeEntry *)[result objectAtIndex:0];
        NSLog(@"entry1 %@",entry);
        NSLog(@"entry2 %@",entry.content);
        NSLog(@"entry3 %@",[entry.content valueForKey:@"medication"]);
        NSLog(@"entry4 %@",[entry.content valueForKey:@"frequency"]);
        XCTAssertEqualObjects([entry.content valueForKey:@"medication"], @"vicodin");
        XCTAssertEqual([[entry.content valueForKey:@"frequency"] intValue], 2);
    } failure:^(NSDictionary *result, int status, NSError *error) {
        XCTFail(@"Could not query the custom class");
    }];
    NSDate *loopUntil = [NSDate dateWithTimeIntervalSinceNow:10];
    while (finished == NO && [loopUntil timeIntervalSinceNow] > 0) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:loopUntil];
    }
}

@end
