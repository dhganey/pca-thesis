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

@interface CatalyzeUserTest : CatalyzeTest

@end

@implementation CatalyzeUserTest

- (void)testLogin {
    __block BOOL finished = NO;
    [CatalyzeUser logInWithUsernameInBackground:secondaryUsername.copy password:secondaryPassword.copy success:^(CatalyzeUser *result) {
        XCTAssertEqualObjects(result.usersId, secondaryUsersId.copy);
        XCTAssertEqualObjects(result.username, secondaryUsername.copy);
        XCTAssertEqualObjects(result, [CatalyzeUser currentUser], @"CurrentUser was not assigned to the logged in user");
        finished = YES;
    } failure:^(NSDictionary *result, int status, NSError *error) {
        XCTFail(@"Could not login the user");
    }];
    NSDate *loopUntil = [NSDate dateWithTimeIntervalSinceNow:10];
    while (finished == NO && [loopUntil timeIntervalSinceNow] > 0) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:loopUntil];
    }
    [super setUp]; //log back in the admin user so other tests can run successfully
}

- (void)testSignUp {
    __block BOOL finished = NO;
    Email *email = [[Email alloc] init];
    email.primary = [self generateEmail];
    [CatalyzeUser signUpWithUsernameInBackground:[self generateUsername] email:email name:[[Name alloc] init] password:secondaryPassword.copy success:^(CatalyzeUser *result) {
        XCTAssertNotNil(result);
        XCTAssertEqualObjects(result, [CatalyzeUser currentUser], @"CurrentUser was not assigned to the logged in user");
        finished = YES;
    } failure:^(NSDictionary *result, int status, NSError *error) {
        XCTFail(@"Could not sign up a new user");
    }];
    NSDate *loopUntil = [NSDate dateWithTimeIntervalSinceNow:10];
    while (finished == NO && [loopUntil timeIntervalSinceNow] > 0) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:loopUntil];
    }
    [super setUp]; //log back in the admin user so other tests can run successfully
}

- (void)testLogout {
    __block BOOL finished = NO;
    [CatalyzeUser logInWithUsernameInBackground:secondaryUsername.copy password:secondaryPassword.copy success:^(CatalyzeUser *result) {
        [result logoutWithSuccess:^(id result) {
            XCTAssertNil([CatalyzeUser currentUser], @"CurrentUser not unset on logout");
            finished = YES;
        } failure:^(NSDictionary *result, int status, NSError *error) {
            XCTFail(@"Could not logout the user");
        }];
    } failure:^(NSDictionary *result, int status, NSError *error) {
        XCTFail(@"Could not login the user");
    }];
    NSDate *loopUntil = [NSDate dateWithTimeIntervalSinceNow:10];
    while (finished == NO && [loopUntil timeIntervalSinceNow] > 0) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:loopUntil];
    }
    [super setUp]; //log back in the admin user so other tests can run successfully
}

- (void)testIsAuthenticated {
    __block BOOL finished = NO;
    [CatalyzeUser logInWithUsernameInBackground:secondaryUsername.copy password:secondaryPassword.copy success:^(CatalyzeUser *result) {
        XCTAssertTrue([result isAuthenticated]);
        [result logoutWithSuccess:^(id result) {
            XCTAssertFalse([result isAuthenticated]);
            finished = YES;
        } failure:^(NSDictionary *result, int status, NSError *error) {
            XCTFail(@"Could not logout the user");
        }];
    } failure:^(NSDictionary *result, int status, NSError *error) {
        XCTFail(@"Could not login the user");
    }];
    NSDate *loopUntil = [NSDate dateWithTimeIntervalSinceNow:10];
    while (finished == NO && [loopUntil timeIntervalSinceNow] > 0) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:loopUntil];
    }
    [super setUp]; //log back in the admin user so other tests can run successfully
}

- (void)testRetrieve {
    __block BOOL finished = NO;
    [CatalyzeUser logInWithUsernameInBackground:secondaryUsername.copy password:secondaryPassword.copy success:^(CatalyzeUser *result) {
        [result retrieveInBackgroundWithSuccess:^(id result) {
            CatalyzeUser *resultUser = (CatalyzeUser *)result;
            XCTAssertEqualObjects(resultUser.usersId, secondaryUsersId.copy);
            XCTAssertEqualObjects(resultUser.username, secondaryUsername.copy);
            finished = YES;
        } failure:^(NSDictionary *result, int status, NSError *error) {
            XCTFail(@"Could not retrieve the user");
        }];
    } failure:^(NSDictionary *result, int status, NSError *error) {
        XCTFail(@"Could not login the user");
    }];
    NSDate *loopUntil = [NSDate dateWithTimeIntervalSinceNow:10];
    while (finished == NO && [loopUntil timeIntervalSinceNow] > 0) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:loopUntil];
    }
    [super setUp]; //log back in the admin user so other tests can run successfully
}

- (void)testSave {
    __block BOOL finished = NO;
    [CatalyzeUser logInWithUsernameInBackground:secondaryUsername.copy password:secondaryPassword.copy success:^(CatalyzeUser *result) {
        [result setType:@"Physician"];
        [result setDob:[NSDate date]];
        [result saveInBackgroundWithSuccess:^(id result) {
            CatalyzeUser *resultUser = (CatalyzeUser *)result;
            XCTAssertEqualObjects(resultUser.type, @"Physician");
            
            [result retrieveInBackgroundWithSuccess:^(id result) {
                CatalyzeUser *resultUser = (CatalyzeUser *)result;
                XCTAssertEqualObjects(resultUser.type, @"Physician");
                finished = YES;
            } failure:^(NSDictionary *result, int status, NSError *error) {
                XCTFail(@"Could not retrieve the user");
            }];
        } failure:^(NSDictionary *result, int status, NSError *error) {
            XCTFail(@"Could not save the user %@", result);
        }];
    } failure:^(NSDictionary *result, int status, NSError *error) {
        XCTFail(@"Could not login the user");
    }];
    NSDate *loopUntil = [NSDate dateWithTimeIntervalSinceNow:10];
    while (finished == NO && [loopUntil timeIntervalSinceNow] > 0) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:loopUntil];
    }
    [super setUp]; //log back in the admin user so other tests can run successfully
}

- (void)testDelete {
    __block BOOL finished = NO;
    Email *email = [[Email alloc] init];
    email.primary = [self generateEmail];
    [CatalyzeUser signUpWithUsernameInBackground:[self generateUsername] email:email name:[[Name alloc] init] password:secondaryPassword.copy success:^(CatalyzeUser *result) {
        [result deleteInBackgroundWithSuccess:^(id result) {
            XCTAssertNil([CatalyzeUser currentUser], @"CurrentUser not unset on delete");
            
            CatalyzeUser *userResult = (CatalyzeUser *)result;
            XCTAssertNil(userResult.usersId, @"Previous CatalyzerUser properties not unset on delete");
            XCTAssertNil(userResult.active, @"Previous CatalyzerUser properties not unset on delete");
            XCTAssertNil(userResult.createdAt, @"Previous CatalyzerUser properties not unset on delete");
            XCTAssertNil(userResult.updatedAt, @"Previous CatalyzerUser properties not unset on delete");
            XCTAssertNil(userResult.username, @"Previous CatalyzerUser properties not unset on delete");
            XCTAssertNil(userResult.email, @"Previous CatalyzerUser properties not unset on delete");
            XCTAssertNil(userResult.name, @"Previous CatalyzerUser properties not unset on delete");
            XCTAssertNil(userResult.dob, @"Previous CatalyzerUser properties not unset on delete");
            XCTAssertNil(userResult.age, @"Previous CatalyzerUser properties not unset on delete");
            XCTAssertNil(userResult.phoneNumber, @"Previous CatalyzerUser properties not unset on delete");
            XCTAssertNil(userResult.addresses, @"Previous CatalyzerUser properties not unset on delete");
            XCTAssertNil(userResult.gender, @"Previous CatalyzerUser properties not unset on delete");
            XCTAssertNil(userResult.maritalStatus, @"Previous CatalyzerUser properties not unset on delete");
            XCTAssertNil(userResult.religion, @"Previous CatalyzerUser properties not unset on delete");
            XCTAssertNil(userResult.race, @"Previous CatalyzerUser properties not unset on delete");
            XCTAssertNil(userResult.ethnicity, @"Previous CatalyzerUser properties not unset on delete");
            XCTAssertNil(userResult.guardians, @"Previous CatalyzerUser properties not unset on delete");
            XCTAssertNil(userResult.confCode, @"Previous CatalyzerUser properties not unset on delete");
            XCTAssertNil(userResult.languages, @"Previous CatalyzerUser properties not unset on delete");
            XCTAssertNil(userResult.socialIds, @"Previous CatalyzerUser properties not unset on delete");
            XCTAssertNil(userResult.mrns, @"Previous CatalyzerUser properties not unset on delete");
            XCTAssertNil(userResult.healthPlans, @"Previous CatalyzerUser properties not unset on delete");
            XCTAssertNil(userResult.avatar, @"Previous CatalyzerUser properties not unset on delete");
            XCTAssertNil(userResult.ssn, @"Previous CatalyzerUser properties not unset on delete");
            XCTAssertNil(userResult.profilePhoto, @"Previous CatalyzerUser properties not unset on delete");
            XCTAssertNil(userResult.type, @"Previous CatalyzerUser properties not unset on delete");
            XCTAssertNil(userResult.extras, @"Previous CatalyzerUser properties not unset on delete");
            
            XCTAssertFalse([result isAuthenticated], @"Session information not cleared on delete");
            finished = YES;
        } failure:^(NSDictionary *result, int status, NSError *error) {
            XCTFail(@"Could not delete a user: %@", result);
        }];
    } failure:^(NSDictionary *result, int status, NSError *error) {
        XCTFail(@"Could not sign up a new user");
    }];
    NSDate *loopUntil = [NSDate dateWithTimeIntervalSinceNow:10];
    while (finished == NO && [loopUntil timeIntervalSinceNow] > 0) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:loopUntil];
    }
    [super setUp]; //log back in the admin user so other tests can run successfully
}

- (void)testCreatedAtUpdatedAtDobAreDates {
    __block BOOL finished = NO;
    [CatalyzeUser logInWithUsernameInBackground:secondaryUsername.copy password:secondaryPassword.copy success:^(CatalyzeUser *result) {
        [result retrieveInBackgroundWithSuccess:^(id result) {
            CatalyzeUser *resultUser = (CatalyzeUser *)result;
            XCTAssertTrue([resultUser.createdAt isKindOfClass:[NSDate class]], @"\"createdAt\" is not of type NSDate");
            XCTAssertTrue([resultUser.updatedAt isKindOfClass:[NSDate class]], @"\"updatedAt\" is not of type NSDate");
            XCTAssertTrue(!resultUser.dob || [resultUser.dob isKindOfClass:[NSDate class]], @"\"dob\" is not of type NSDate: %@", [resultUser.dob class]);
            finished = YES;
        } failure:^(NSDictionary *result, int status, NSError *error) {
            XCTFail(@"Could not retrieve the user");
        }];
    } failure:^(NSDictionary *result, int status, NSError *error) {
        XCTFail(@"Could not login the user");
    }];
    NSDate *loopUntil = [NSDate dateWithTimeIntervalSinceNow:10];
    while (finished == NO && [loopUntil timeIntervalSinceNow] > 0) {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:loopUntil];
    }
    [super setUp]; //log back in the admin user so other tests can run successfully
}

- (NSString *)generateUsername {
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity:10];
    
    for (int i=0; i<10; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform((uint)[letters length]) % [letters length]]];
    }
    
    return randomString;
}

- (NSString *)generateEmail {
    return [NSString stringWithFormat:@"%@@catalyze.io", [self generateUsername]];
}

@end
