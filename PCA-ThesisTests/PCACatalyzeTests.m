//
//  PCACatalyzeTests.m
//  PCA-Thesis
//
//  Created by David Ganey on 10/19/14.
//  Copyright (c) 2014 dhganey. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Catalyze.h"
#import "XCTestCase+AsyncTesting.h"

@interface PCACatalyzeTests : XCTestCase

@end

@implementation PCACatalyzeTests

NSString* username2 = @"dhganey";
NSString* pword2 = @"";

- (void)setUp
{
    [super setUp];
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testLogin
{
    [CatalyzeUser logInWithUsernameInBackground:username2 password:pword2 success:^(CatalyzeUser *result) {
        XCTAssertEqual(true, true);
    } failure:^(NSDictionary *result, int status, NSError *error) {
        XCTFail(@"failed to login to catalyze");
    }];
}

- (void)testLoginPerformance
{
    [self measureBlock:^
    {
        [CatalyzeUser logInWithUsernameInBackground:username2 password:pword2 success:^(CatalyzeUser *result) {
            XCTAssertEqual(true, true);
        } failure:^(NSDictionary *result, int status, NSError *error) {
            XCTFail(@"failed to login to catalyze");
        }];
    }];
}

-(void) testLogout
{
    [self measureBlock:^{
        [CatalyzeUser logInWithUsernameInBackground:username2 password:pword2 success:^(CatalyzeUser *result) {
            XCTAssertEqual(true, true);
            [[CatalyzeUser currentUser] logout];
        } failure:^(NSDictionary *result, int status, NSError *error) {
            XCTFail(@"failed to login");
        }];
    }];
}

@end
