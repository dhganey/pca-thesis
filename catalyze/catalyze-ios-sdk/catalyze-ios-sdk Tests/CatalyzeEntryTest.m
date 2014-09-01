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

@interface CatalyzeEntryTest : CatalyzeTest

@end

@implementation CatalyzeEntryTest
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
    [super tearDown];
}

//method level
- (void)setUp {
    [super setUp];
    
}

- (void)tearDown {
    
    [super tearDown];
}

- (void)testCreate {
    CatalyzeEntry *entry = [CatalyzeEntry entryWithClassName:className.copy];
    NSDictionary *content = @{@"medication":@"vicodin", @"frequency":@2};
    [entry setContent:[NSMutableDictionary dictionaryWithDictionary:content]];
    
    __block BOOL finished = NO;
    [entry createInBackgroundWithSuccess:^(id result) {
        finished = YES;
    } failure:^(NSDictionary *result, int status, NSError *error) {
        finished = YES;
    }];
    
    NSDate *loopUntil = [NSDate dateWithTimeIntervalSinceNow:10];
    while (finished == NO && [loopUntil timeIntervalSinceNow] > 0) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:loopUntil];
    }
    XCTAssertNotNil(entry.entryId, @"entryId not populated");
    XCTAssertNotNil(entry.parentId, @"parentId not populated");
    XCTAssertNotNil(entry.authorId, @"authorId not populated");
    XCTAssertEqualObjects(entry.content, content, @"content incorrect");
    XCTAssertNotNil(entry.createdAt, @"createdAt not populated");
    XCTAssertNotNil(entry.updatedAt, @"updatedAt not populated");
}

- (void)testRetrieve {
    CatalyzeEntry *myEntry = [CatalyzeEntry entryWithClassName:className.copy];
    NSDictionary *content = @{@"medication":@"vicodin", @"frequency":@2};
    [myEntry setContent:[NSMutableDictionary dictionaryWithDictionary:content]];
    
    __block BOOL finished = NO;
    [myEntry createInBackgroundWithSuccess:^(id result) {
        CatalyzeEntry *retrieveEntry = [CatalyzeEntry entryWithClassName:className.copy];
        [retrieveEntry setEntryId:myEntry.entryId];
        [retrieveEntry retrieveInBackgroundWithSuccess:^(id result) {
            CatalyzeEntry *entry = (CatalyzeEntry *)result;
            XCTAssertEqualObjects(entry.entryId, retrieveEntry.entryId, @"\"entryId\" not set on retrieved object");
            XCTAssertEqualObjects(entry.parentId, retrieveEntry.parentId, @"\"parentId\" not set on retrieved object");
            XCTAssertEqualObjects(entry.authorId, retrieveEntry.authorId, @"\"authorId\" not set on retrieved object");
            XCTAssertEqualObjects(entry.content, retrieveEntry.content, @"\"content\" not set on retrieved object");
            XCTAssertEqualObjects(entry.createdAt, retrieveEntry.createdAt, @"\"createdAt\" not set on retrieved object");
            XCTAssertEqualObjects(entry.updatedAt, retrieveEntry.updatedAt, @"\"updatedAt\" not set on retrieved object");
            
            XCTAssertEqualObjects(myEntry.entryId, retrieveEntry.entryId, @"\"entryId\" not equivalent");
            XCTAssertEqualObjects(myEntry.parentId, retrieveEntry.parentId, @"\"parentId\" not equivalent");
            XCTAssertEqualObjects(myEntry.authorId, retrieveEntry.authorId, @"\"authorId\" not equivalent");
            XCTAssertEqualObjects(myEntry.content, retrieveEntry.content, @"\"content\" not equivalent");
            XCTAssertEqualObjects(myEntry.createdAt, retrieveEntry.createdAt, @"\"createdAt\" not equivalent");
            XCTAssertEqualObjects(myEntry.updatedAt, retrieveEntry.updatedAt, @"\"updatedAt\" not equivalent");
            finished = YES;
        } failure:^(NSDictionary *result, int status, NSError *error) {
            XCTFail(@"Failed to retrieve a custom class entry");
        }];
    } failure:^(NSDictionary *result, int status, NSError *error) {
        XCTFail(@"Failed to create a custom class entry");
    }];
    
    NSDate *loopUntil = [NSDate dateWithTimeIntervalSinceNow:10];
    while (finished == NO && [loopUntil timeIntervalSinceNow] > 0) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:loopUntil];
    }
    if (!finished) {
        XCTFail(@"Could not run %s due to network issues", __PRETTY_FUNCTION__);
    }
}

- (void)testRetrieveInvalidEntryId {
    CatalyzeEntry *myEntry = [CatalyzeEntry entryWithClassName:className.copy];
    NSDictionary *content = @{@"medication":@"vicodin", @"frequency":@2};
    [myEntry setContent:[NSMutableDictionary dictionaryWithDictionary:content]];
    [myEntry setEntryId:@"1234"];
    
    __block BOOL finished = NO;
    [myEntry retrieveInBackgroundWithSuccess:^(id result) {
        XCTFail(@"Retrieved invalid entry");
    } failure:^(NSDictionary *result, int status, NSError *error) {
        XCTAssertNotNil(error);
        XCTAssertNotNil(result);
        XCTAssertEqual(status, 404, @"Unexpected status");
        XCTAssertNotNil([result objectForKey:@"errors"]);
        finished = YES;
    }];
    
    NSDate *loopUntil = [NSDate dateWithTimeIntervalSinceNow:10];
    while (finished == NO && [loopUntil timeIntervalSinceNow] > 0) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:loopUntil];
    }
    if (!finished) {
        XCTFail(@"Could not run %s due to network issues", __PRETTY_FUNCTION__);
    }
}

- (void)testRetrieveHashEntryIdFormat {
    CatalyzeEntry *myEntry = [CatalyzeEntry entryWithClassName:className.copy];
    [myEntry setEntryId:@"1234  "];
    
    __block BOOL finished = NO;
    [myEntry retrieveInBackgroundWithSuccess:^(id result) {
        XCTFail(@"Retrieved invalid entry");
    } failure:^(NSDictionary *result, int status, NSError *error) {
        XCTAssertNotNil(error);
        XCTAssertNotNil(result);
        XCTAssertEqual(status, 404, @"Unexpected status");
        XCTAssertNotNil([result objectForKey:@"errors"]);
        finished = YES;
    }];
    
    NSDate *loopUntil = [NSDate dateWithTimeIntervalSinceNow:10];
    while (finished == NO && [loopUntil timeIntervalSinceNow] > 0) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:loopUntil];
    }
    if (!finished) {
        XCTFail(@"Could not run %s due to network issues", __PRETTY_FUNCTION__);
    }
}

- (void)testUpdate {
    CatalyzeEntry *myEntry = [CatalyzeEntry entryWithClassName:className.copy];
    NSDictionary *content = @{@"medication":@"vicodin", @"frequency":@2};
    [myEntry setContent:[NSMutableDictionary dictionaryWithDictionary:content]];
    
    __block BOOL finished = NO;
    [myEntry createInBackgroundWithSuccess:^(id result) {
        [[myEntry content] setObject:[NSNumber numberWithInt:1] forKey:@"frequency"];
        [myEntry saveInBackgroundWithSuccess:^(id result) {
            XCTAssertNotNil(myEntry.entryId, @"\"entryId\" not set on object");
            XCTAssertNotNil(myEntry.parentId, @"\"parentId\" not set on object");
            XCTAssertNotNil(myEntry.authorId, @"\"authorId\" not set on object");
            XCTAssertNotNil(myEntry.content, @"\"content\" not set on object");
            XCTAssertNotNil(myEntry.createdAt, @"\"createdAt\" not set on object");
            XCTAssertNotNil(myEntry.updatedAt, @"\"updatedAt\" not set on object");
            
            XCTAssertEqual([[myEntry.content objectForKey:@"frequency"] intValue], 1, @"Updated field is incorrect");
            finished = YES;
        } failure:^(NSDictionary *result, int status, NSError *error) {
            XCTFail(@"Failed to save the custom class entry");
        }];
    } failure:^(NSDictionary *result, int status, NSError *error) {
        XCTFail(@"Failed to create a custom class entry");
    }];
    
    NSDate *loopUntil = [NSDate dateWithTimeIntervalSinceNow:10];
    while (finished == NO && [loopUntil timeIntervalSinceNow] > 0) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:loopUntil];
    }
    if (!finished) {
        XCTFail(@"Could not run %s due to network issues", __PRETTY_FUNCTION__);
    }
}

- (void)testDelete {
    CatalyzeEntry *myEntry = [CatalyzeEntry entryWithClassName:className.copy];
    NSDictionary *content = @{@"medication":@"vicodin", @"frequency":@2};
    [myEntry setContent:[NSMutableDictionary dictionaryWithDictionary:content]];
    
    __block BOOL finished = NO;
    [myEntry createInBackgroundWithSuccess:^(id result) {
        [myEntry deleteInBackgroundWithSuccess:^(id result) {
            XCTAssertNil(myEntry.entryId, @"\"entryId\" not unset on object");
            XCTAssertNil(myEntry.parentId, @"\"parentId\" not unset on object");
            XCTAssertNil(myEntry.authorId, @"\"authorId\" not unset on object");
            XCTAssertNil(myEntry.content, @"\"content\" not unset on object");
            XCTAssertNil(myEntry.createdAt, @"\"createdAt\" not unset on object");
            XCTAssertNil(myEntry.updatedAt, @"\"updatedAt\" not unset on object");
            finished = YES;
        } failure:^(NSDictionary *result, int status, NSError *error) {
            XCTFail(@"Failed to delete the custom class entry");
        }];
    } failure:^(NSDictionary *result, int status, NSError *error) {
        XCTFail(@"Failed to create a custom class entry");
    }];
    
    NSDate *loopUntil = [NSDate dateWithTimeIntervalSinceNow:10];
    while (finished == NO && [loopUntil timeIntervalSinceNow] > 0) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:loopUntil];
    }
    if (!finished) {
        XCTFail(@"Could not run %s due to network issues", __PRETTY_FUNCTION__);
    }
}

- (void)testDeleteInvalidEntryId {
    CatalyzeEntry *myEntry = [CatalyzeEntry entryWithClassName:className.copy];
    NSDictionary *content = @{@"medication":@"vicodin", @"frequency":@2};
    [myEntry setContent:[NSMutableDictionary dictionaryWithDictionary:content]];
    [myEntry setEntryId:@"1234"];
    
    __block BOOL finished = NO;
    [myEntry deleteInBackgroundWithSuccess:^(id result) {
        XCTFail(@"Deleted an invalid custom class entry");
    } failure:^(NSDictionary *result, int status, NSError *error) {
        XCTAssertEqual(404, status, @"Unexpected status");
        finished = YES;
    }];
    
    NSDate *loopUntil = [NSDate dateWithTimeIntervalSinceNow:10];
    while (finished == NO && [loopUntil timeIntervalSinceNow] > 0) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:loopUntil];
    }
    if (!finished) {
        XCTFail(@"Could not run %s due to network issues", __PRETTY_FUNCTION__);
    }
}

@end
