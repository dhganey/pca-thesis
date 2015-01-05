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

@interface CatalyzeFileManagerTest : CatalyzeTest

@end

@implementation CatalyzeFileManagerTest

- (NSString *)uploadFile:(NSData *)data expectedStatus:(int)expectedStatus {
    __block NSString *filesId = nil;
    
    [CatalyzeFileManager uploadFileToUser:data phi:NO mimeType:@"text/plain" success:^(NSDictionary *result) {
        XCTAssertEqual(expectedStatus, 200, @"Unexpected status %i", 200);
        filesId = [result valueForKey:@"filesId"];
    } failure:^(NSDictionary *result, int status, NSError *error) {
        XCTAssertEqual(expectedStatus, status, @"Unexpected status %i - %@", status, error.localizedDescription);
        filesId = @"";
    }];
    NSDate *loopUntil = [NSDate dateWithTimeIntervalSinceNow:30];
    while (filesId == nil && [loopUntil timeIntervalSinceNow] > 0) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:loopUntil];
    }
    return filesId;
}

- (NSString *)uploadFile:(NSData *)data toUser:(NSString *)usersId expectedStatus:(int)expectedStatus {
    __block NSString *filesId = nil;
    
    [CatalyzeFileManager uploadFileToOtherUser:data usersId:usersId phi:NO mimeType:@"text/plain" success:^(NSDictionary *result) {
        XCTAssertEqual(expectedStatus, 200, @"Unexpected status %i", 200);
        filesId = [result valueForKey:@"filesId"];
    } failure:^(NSDictionary *result, int status, NSError *error) {
        XCTAssertEqual(expectedStatus, status, @"Unexpected status %i - %@", status, error.localizedDescription);
        filesId = @"";
    }];
    NSDate *loopUntil = [NSDate dateWithTimeIntervalSinceNow:30];
    while (filesId == nil && [loopUntil timeIntervalSinceNow] > 0) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:loopUntil];
    }
    return filesId;
}

- (void)testUploadFileToUser {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *path = [bundle pathForResource:@"testFile" ofType:@"txt"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSString *filesId = [self uploadFile:data expectedStatus:200];
    XCTAssertNotNil(filesId, @"filesId not returned from upload");
}

- (void)testListFiles {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *path = [bundle pathForResource:@"testFile" ofType:@"txt"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSString *filesId = [self uploadFile:data expectedStatus:200];
    
    __block BOOL finished = NO;
    [CatalyzeFileManager listFiles:^(NSArray *result) {
        XCTAssertGreaterThanOrEqual(result.count, 1);
        BOOL found = NO;
        for (id fileId in result) {
            if ([[fileId valueForKey:@"filesId"] isEqualToString:filesId]) {
                found = YES;
            }
        }
        XCTAssertTrue(found, @"Uploaded file not found in files list");
        finished = YES;
    } failure:^(NSDictionary *result, int status, NSError *error) {
        XCTFail(@"Failed to list files");
    }];
    NSDate *loopUntil = [NSDate dateWithTimeIntervalSinceNow:30];
    while (finished == NO && [loopUntil timeIntervalSinceNow] > 0) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:loopUntil];
    }
}

- (void)testRetrieveFile {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *path = [bundle pathForResource:@"testFile" ofType:@"txt"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSString *filesId = [self uploadFile:data expectedStatus:200];
    
    __block BOOL finished = NO;
    [CatalyzeFileManager retrieveFile:filesId success:^(NSData *result) {
        XCTAssertEqualObjects(result, data);
        finished = YES;
    } failure:^(NSDictionary *result, int status, NSError *error) {
        XCTFail(@"Failed to retrieve file");
    }];
    NSDate *loopUntil = [NSDate dateWithTimeIntervalSinceNow:30];
    while (finished == NO && [loopUntil timeIntervalSinceNow] > 0) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:loopUntil];
    }
}

- (void)testRetrieveInvalidFile {
    __block BOOL finished = NO;
    [CatalyzeFileManager retrieveFile:@"fake_id" success:^(NSData *result) {
        XCTFail(@"Retrieved invalid file");
    } failure:^(NSDictionary *result, int status, NSError *error) {
        XCTAssertEqual(status, 404);
        finished = YES;
    }];
    NSDate *loopUntil = [NSDate dateWithTimeIntervalSinceNow:30];
    while (finished == NO && [loopUntil timeIntervalSinceNow] > 0) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:loopUntil];
    }
}

- (void)testDeleteFile {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *path = [bundle pathForResource:@"testFile" ofType:@"txt"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSString *filesId = [self uploadFile:data expectedStatus:200];
    
    __block BOOL finished = NO;
    [CatalyzeFileManager deleteFile:filesId success:^(id result) {
        [CatalyzeFileManager retrieveFile:filesId success:^(NSData *result) {
            XCTFail(@"Retrieved a deleted file");
        } failure:^(NSDictionary *result, int status, NSError *error) {
            XCTAssertEqual(status, 404);
            finished = YES;
        }];
    } failure:^(NSDictionary *result, int status, NSError *error) {
        XCTFail(@"Failed to delete file");
    }];
    
    NSDate *loopUntil = [NSDate dateWithTimeIntervalSinceNow:30];
    while (finished == NO && [loopUntil timeIntervalSinceNow] > 0) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:loopUntil];
    }
}

- (void)testUploadFileToOtherUser {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *path = [bundle pathForResource:@"testFile" ofType:@"txt"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSString *filesId = [self uploadFile:data toUser:secondaryUsersId.copy expectedStatus:200];
    XCTAssertNotNil(filesId, @"filesId not returned from upload to user");
}

- (void)testListFilesForUser {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *path = [bundle pathForResource:@"testFile" ofType:@"txt"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSString *filesId = [self uploadFile:data toUser:secondaryUsersId.copy expectedStatus:200];
    
    __block BOOL finished = NO;
    [CatalyzeFileManager listFilesForUser:secondaryUsersId.copy success:^(NSArray *result) {
        XCTAssertGreaterThanOrEqual(result.count, 1);
        BOOL found = NO;
        for (id fileId in result) {
            if ([[fileId valueForKey:@"filesId"] isEqualToString:filesId]) {
                found = YES;
            }
        }
        XCTAssertTrue(found, @"Uploaded file not found in files list from user");
        finished = YES;
    } failure:^(NSDictionary *result, int status, NSError *error) {
        XCTFail(@"Failed to list files from user");
    }];
    NSDate *loopUntil = [NSDate dateWithTimeIntervalSinceNow:30];
    while (finished == NO && [loopUntil timeIntervalSinceNow] > 0) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:loopUntil];
    }
}

- (void)testRetrieveFileFromUser {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *path = [bundle pathForResource:@"testFile" ofType:@"txt"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSString *filesId = [self uploadFile:data toUser:secondaryUsersId.copy expectedStatus:200];
    
    __block BOOL finished = NO;
    [CatalyzeFileManager retrieveFileFromUser:filesId usersId:secondaryUsersId.copy success:^(NSData *result) {
        XCTAssertEqualObjects(result, data);
        finished = YES;
    } failure:^(NSDictionary *result, int status, NSError *error) {
        XCTFail(@"Failed to retrieve file from user");
    }];
    NSDate *loopUntil = [NSDate dateWithTimeIntervalSinceNow:30];
    while (finished == NO && [loopUntil timeIntervalSinceNow] > 0) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:loopUntil];
    }
}

- (void)testDeleteFileFromUser {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *path = [bundle pathForResource:@"testFile" ofType:@"txt"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    NSString *filesId = [self uploadFile:data toUser:secondaryUsersId.copy expectedStatus:200];
    
    __block BOOL finished = NO;
    [CatalyzeFileManager deleteFileFromUser:filesId usersId:secondaryUsersId.copy success:^(id result) {
        [CatalyzeFileManager retrieveFileFromUser:filesId usersId:secondaryUsersId.copy success:^(NSData *result) {
            XCTFail(@"Retrieved a deleted file from user");
        } failure:^(NSDictionary *result, int status, NSError *error) {
            XCTAssertEqual(status, 404);
            finished = YES;
        }];
    } failure:^(NSDictionary *result, int status, NSError *error) {
        XCTFail(@"Failed to delete file from user");
    }];
    
    NSDate *loopUntil = [NSDate dateWithTimeIntervalSinceNow:30];
    while (finished == NO && [loopUntil timeIntervalSinceNow] > 0) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:loopUntil];
    }
}

@end
