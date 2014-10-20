//
//  PCASymptomEnterTests.m
//  PCA-Thesis
//
//  Created by David Ganey on 10/19/14.
//  Copyright (c) 2014 dhganey. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Catalyze.h"
#import "XCTestCase+AsyncTesting.h"

@interface PCASymptomEnterTests : XCTestCase

@end

@implementation PCASymptomEnterTests

NSString* username1 = @"dhganey";
NSString* pword1 = @"";

- (void)setUp
{
    [super setUp];
    
    [CatalyzeUser logInWithUsernameInBackground:username1 password:pword1 success:^(CatalyzeUser *result)
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
