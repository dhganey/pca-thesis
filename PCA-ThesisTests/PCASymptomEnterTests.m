//
//  PCASymptomEnterTests.m
//  PCA-Thesis
//
//  Created by David Ganey on 10/19/14.
//  Copyright (c) 2014 dhganey. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "Catalyze.h"
#import "XCTestCase+AsyncTesting.h"
#import "AsyncXCTestingKit.h"

@interface PCASymptomEnterTests : XCTestCase

@end

@implementation PCASymptomEnterTests

NSString* user = @"dhganey";
NSString* pword = @"";

- (void)setUp
{
    [super setUp];
    
    [CatalyzeUser logInWithUsernameInBackground:user password:pword success:^(CatalyzeUser *result)
    {
        [self XCA_notify:XCTAsyncTestCaseStatusSucceeded];
    } failure:^(NSDictionary *result, int status, NSError *error) {
        XCTFail(@"could not sign in to catalyze");
    }];
    
    [self XCA_waitForStatus:XCTAsyncTestCaseStatusSucceeded timeout:10];
}

- (void)tearDown {
    [super tearDown];
    
    [[CatalyzeUser currentUser] logout];
}

@end
