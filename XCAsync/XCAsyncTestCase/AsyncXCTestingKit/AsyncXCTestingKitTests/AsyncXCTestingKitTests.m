//
//  AsyncXCTestingKitTests.m
//  AsyncXCTestingKitTests
//
//  Created by 小野 将司 on 12/03/17.
//  Modified for XCTest by Vincil Bishop
//  Copyright (c) 2012年 AppBankGames Inc. All rights reserved.
//

#import "AsyncXCTestingKitTests.h"
#import "XCTestCase+AsyncTesting.h"

@implementation AsyncXCTestingKitTests

- (void)setUp
{
    [super setUp];
    NSLog(@"%s", __func__);
}

- (void)tearDown
{
    NSLog(@"%s", __func__);
    [super tearDown];
}


#pragma mark -


- (void)testAsyncTimeoutsProperly
{
    [self waitForTimeout:3.0];
}

- (void)testAsyncTimeoutsProperly_EXPECT_FAIL
{

    XCTAssertThrows([self waitForStatus:XCTAsyncTestCaseStatusSucceeded timeout:1.0], @"there should be an exception");
}


#pragma mark -


- (void)testAsyncWithMethods
{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self helperForAsyncWithMethods];
        [self notify:XCTAsyncTestCaseStatusSucceeded];
    });
    
    [self waitForStatus:XCTAsyncTestCaseStatusSucceeded timeout:10.0];
    NSLog(@"Test Finished!");
}

- (void)helperForAsyncWithMethods {
    
    [self notify:XCTAsyncTestCaseStatusSucceeded];
}

#pragma mark -

- (void)testAsyncWithBlocks
{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self notify:XCTAsyncTestCaseStatusSucceeded];
    });
    
    
    XCTAssertThrows([self waitForStatus:XCTAsyncTestCaseStatusSucceeded timeout:1.0], @"there should be an exception");
    NSLog(@"Test Finished!");
}

- (void)testAsyncWithBlocksStatusDoesntMatch_EXPECT_FAIL
{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

        [self notify:XCTAsyncTestCaseStatusCancelled];
    });


    XCTAssertThrows([self waitForStatus:XCTAsyncTestCaseStatusSucceeded timeout:10.0], @"there should be an exception");
    NSLog(@"Test Finished!");
}

- (void)testAsyncWithBlocksError_EXPECT_FAIL
{
    
    __block BOOL canceled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        XCTAssertTrue(canceled, @"the async operation wasnt canceled");
    });
    

    XCTAssertThrows([self waitForStatus:XCTAsyncTestCaseStatusFailed timeout:0.1], @"there should be an exception");
    canceled = YES;
}


#pragma mark -


- (void)testAsyncMainQueue
{
    /*

     This is the preferred way if you're using iOS SDK 4 or above.

     Test Case '-[AsyncSenTestingKitTests testAsyncMainQueue]' started.
     2012-03-17 16:27:49.974 otest[939:7b03] -[AsyncSenTestingKitTests setUp]
     2012-03-17 16:27:49.975 otest[939:7b03] Wait loop start
     2012-03-17 16:27:51.976 otest[939:7b03] Notified
     2012-03-17 16:27:51.977 otest[939:7b03] Wait loop finished
     2012-03-17 16:27:51.979 otest[939:7b03] -[AsyncSenTestingKitTests tearDown]
     Test Case '-[AsyncSenTestingKitTests testAsyncMainQueue]' passed (2.007 seconds).

     */
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 2.0 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^{
        [self notify:XCTAsyncTestCaseStatusSucceeded];
    });
    [self waitForStatus:XCTAsyncTestCaseStatusSucceeded timeout:5.0];
}


- (void)testAsyncPerformSelector
{
    /*

     Using -performSelector:withObject:afterDelay is no longer recommended as the test has to wait until timeout, like below:

     Test Case '-[AsyncSenTestingKitTests testAsyncPerformSelector]' started.
     2012-03-17 16:27:51.980 otest[939:7b03] -[AsyncSenTestingKitTests setUp]
     2012-03-17 16:27:51.981 otest[939:7b03] Wait loop start
     2012-03-17 16:27:53.982 otest[939:7b03] Notified
     2012-03-17 16:27:56.983 otest[939:7b03] Wait loop finished
     2012-03-17 16:27:56.984 otest[939:7b03] -[AsyncSenTestingKitTests tearDown]
     Test Case '-[AsyncSenTestingKitTests testAsyncPerformSelector]' passed (5.004 seconds).

     This is because the -performSelector:withObject:afterDelay method internally uses timer. Timers are not considered to be
     the input sources thus -runMode:beforeDate: doesn't return.

     */
    [self performSelector:@selector(___internal___testAsyncPerformSelector) withObject:nil afterDelay:2.0];
    [self waitForStatus:XCTAsyncTestCaseStatusSucceeded timeout:5.0];
}

- (void)___internal___testAsyncPerformSelector
{
    [self notify:XCTAsyncTestCaseStatusSucceeded];
}

#pragma mark - Tests for Block wait, replicates the tests for the existing waitForStatus:timeout:

- (void)testAsyncTimeoutsProperlyUsingBlock_EXPECT_FAIL
{
    
    XCTAssertThrows([self waitForStatus:XCTAsyncTestCaseStatusSucceeded timeout:3.0 withBlock:nil], @"there should be an exception");
}


- (void)testAsyncWithDelegateUsingBlock
{
    [self waitForStatus:XCTAsyncTestCaseStatusSucceeded timeout:10.0 withBlock:^{
        [self helperForAsyncWithMethods];
    }];
}

- (void)testAsyncWithBlocks200UsingBlock
{
    [self waitForStatus:XCTAsyncTestCaseStatusSucceeded timeout:10.0 withBlock:^{

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self notify:XCTAsyncTestCaseStatusSucceeded];
        });
        
    }];
}

- (void)testAsyncWithBlocks200UsingBlock_EXPECT_FAIL
{
    XCTAssertThrows([self waitForStatus:XCTAsyncTestCaseStatusSucceeded timeout:0.1 withBlock:^{

        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self notify:XCTAsyncTestCaseStatusSucceeded];
        });
    
    }], @"there should be an exception");
}

- (void)testAsyncWithBlocksStatusDoesntMatchUsingBlock_EXPECT_FAIL
{
    XCTAssertThrows([self waitForStatus:XCTAsyncTestCaseStatusSucceeded timeout:10.0 withBlock:^{
        
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self notify:XCTAsyncTestCaseStatusFailed];
        });
        
    }], @"there should be an exception");
}

- (void)testAsyncWithBlocksErrorUsingBlock
{
    XCTAssertThrows([self waitForStatus:XCTAsyncTestCaseStatusFailed timeout:1.0 withBlock:^{
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self notify:XCTAsyncTestCaseStatusFailed];
        });
        
    }], @"there should be an exception");
}

- (void)testAsyncWithBlocksErrorUsingBlock_EXPECT_FAIL
{
    
    XCTAssertThrows([self waitForStatus:XCTAsyncTestCaseStatusSucceeded timeout:10.0 withBlock:^{
        
        
            [self notify:XCTAsyncTestCaseStatusFailed];
        
    }], @"there should be an exception");
    
    
}

- (void)testAsyncMainQueueUsingBlock
{
    /*

     This is the preferred way if you're using iOS SDK 4 or above.

     Test Case '-[AsyncSenTestingKitTests testAsyncMainQueue]' started.
     2012-03-17 16:27:49.974 otest[939:7b03] -[AsyncSenTestingKitTests setUp]
     2012-03-17 16:27:49.975 otest[939:7b03] Wait loop start
     2012-03-17 16:27:51.976 otest[939:7b03] Notified
     2012-03-17 16:27:51.977 otest[939:7b03] Wait loop finished
     2012-03-17 16:27:51.979 otest[939:7b03] -[AsyncSenTestingKitTests tearDown]
     Test Case '-[AsyncSenTestingKitTests testAsyncMainQueue]' passed (2.007 seconds).

     */
    [self waitForStatus:XCTAsyncTestCaseStatusSucceeded timeout:5.0 withBlock:^{
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 2.0 * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^{
            [self notify:XCTAsyncTestCaseStatusSucceeded];
        });
    }];
}


- (void)testAsyncPerformSelectorUsingBlock
{
    /*

     Using -performSelector:withObject:afterDelay is no longer recommended as the test has to wait until timeout, like below:

     Test Case '-[AsyncSenTestingKitTests testAsyncPerformSelector]' started.
     2012-03-17 16:27:51.980 otest[939:7b03] -[AsyncSenTestingKitTests setUp]
     2012-03-17 16:27:51.981 otest[939:7b03] Wait loop start
     2012-03-17 16:27:53.982 otest[939:7b03] Notified
     2012-03-17 16:27:56.983 otest[939:7b03] Wait loop finished
     2012-03-17 16:27:56.984 otest[939:7b03] -[AsyncSenTestingKitTests tearDown]
     Test Case '-[AsyncSenTestingKitTests testAsyncPerformSelector]' passed (5.004 seconds).

     This is because the -performSelector:withObject:afterDelay method internally uses timer. Timers are not considered to be
     the input sources thus -runMode:beforeDate: doesn't return.

     */
    [self waitForStatus:XCTAsyncTestCaseStatusSucceeded timeout:5.0 withBlock:^{
        [self performSelector:@selector(___internal___testAsyncPerformSelector) withObject:nil afterDelay:2.0];
    }];
}

#pragma mark - Test Cases Where waitForStatus:timeout: will fail but waitForStatus:timeout:withBlock: does not
/*
 The disabled "Expect Fail" tests below are here just for proof that the block based waitForStatus: method is better since it original method can cause unexpected failures where the correct status is set, but the notified property was reset to NO after the status had already been set.  This can happen when testing a block bacsed method that may or may not be asynchronous, but sets the status before the waitForStatus:timeout: method to be called.  The waitForStatus:timeout:withBlock: method works everywhere the waitForStatus:timeout method does and more.  And it has the benefit of being more readable.
 */
- (void)blockMethodThatReturnsImmediately:(void(^)(void))block {
    if (block) {
        block();
    }
}

- (void)testBlockThatReturnImmediately {
    
    void (^testBlock)() = ^{
        
        [self notify:XCTAsyncTestCaseStatusSucceeded];
    };
    

    testBlock();
    XCTAssertThrows([self waitForStatus:XCTAsyncTestCaseStatusSucceeded timeout:1.0], @"there should be an exception");
    NSLog(@"Test Finished!");

}

- (void)testSeeminglyAsyncBlockMethodThatReturnsImmediatelyStillReturnsSuccess {
    [self waitForStatus:XCTAsyncTestCaseStatusSucceeded timeout:2.0 withBlock:^{
        [self blockMethodThatReturnsImmediately:^{
            [self notify:XCTAsyncTestCaseStatusSucceeded];
        }];
    }];
}

- (void)testSeeminglyAsyncBlockMethodThatReturnsImmediatelyStillReturnsSuccessWithDelay {
    
    [self blockMethodThatReturnsImmediately:^{
        
        [self notify:XCTAsyncTestCaseStatusSucceeded withDelay:0.1];
    }];

    [self waitForStatus:XCTAsyncTestCaseStatusSucceeded timeout:10.0];
    NSLog(@"Test Finished!");
}

- (void)testSeeminglyAsyncBlockMethodThatReturnsImmediatelyStillReturnsSuccess_EXPECT_FAIL {
    [self blockMethodThatReturnsImmediately:^{
        [self notify:XCTAsyncTestCaseStatusSucceeded];
    }];
    XCTAssertThrows([self waitForStatus:XCTAsyncTestCaseStatusSucceeded timeout:2.0], @"there should be an exception");
}


- (void)testSeeminglyAsyncBlockMethodThatReturnsImmediatelyStillReturnsFailed {
    [self waitForStatus:XCTAsyncTestCaseStatusFailed timeout:2.0 withBlock:^{
        [self blockMethodThatReturnsImmediately:^{
            [self notify:XCTAsyncTestCaseStatusFailed];
        }];
    }];
}

- (void)testSeeminglyAsyncBlockMethodThatReturnsImmediatelyStillReturnsFailed_EXPECT_FAIL {
    [self blockMethodThatReturnsImmediately:^{
        [self notify:XCTAsyncTestCaseStatusFailed];
    }];

    XCTAssertThrows([self waitForStatus:XCTAsyncTestCaseStatusFailed timeout:2.0], @"there should be an exception");
}


- (void)testSeeminglyAsyncBlockMethodThatReturnsImmediatelyStillReturnsCanceled {
    [self waitForStatus:XCTAsyncTestCaseStatusCancelled timeout:2.0 withBlock:^{
        [self blockMethodThatReturnsImmediately:^{
            [self notify:XCTAsyncTestCaseStatusCancelled];
        }];
    }];
}

- (void)testSeeminglyAsyncBlockMethodThatReturnsImmediatelyStillReturnsCanceled_EXPECT_FAIL {
    [self blockMethodThatReturnsImmediately:^{
        [self notify:XCTAsyncTestCaseStatusCancelled];
    }];

    XCTAssertThrows([self waitForStatus:XCTAsyncTestCaseStatusCancelled timeout:2.0], @"there should be an exception");
}


- (void)testSeeminglyAsyncBlockMethodThatReturnsImmediatelyStillReturnsWaiting {
    [self waitForStatus:XCTAsyncTestCaseStatusWaiting timeout:2.0 withBlock:^{
        [self blockMethodThatReturnsImmediately:^{
            [self notify:XCTAsyncTestCaseStatusWaiting];
        }];
    }];
}

- (void)testSeeminglyAsyncBlockMethodThatReturnsImmediatelyStillReturnsWaiting_EXPECT_FAIL {
    [self blockMethodThatReturnsImmediately:^{
        [self notify:XCTAsyncTestCaseStatusWaiting];
    }];

    XCTAssertThrows([self waitForStatus:XCTAsyncTestCaseStatusWaiting timeout:2.0], @"there should be an exception");
}


- (void)testSeeminglyAsyncBlockMethodThatReturnsImmediatelyStillReturnsUnkown {
    [self waitForStatus:XCTAsyncTestCaseStatusUnknown timeout:2.0 withBlock:^{
        [self blockMethodThatReturnsImmediately:^{
            [self notify:XCTAsyncTestCaseStatusUnknown];
        }];
    }];
}

- (void)testSeeminglyAsyncBlockMethodThatReturnsImmediatelyStillReturnsUnknown_EXPECT_FAIL {
    [self blockMethodThatReturnsImmediately:^{
        [self notify:XCTAsyncTestCaseStatusUnknown];
    }];

    XCTAssertThrows([self waitForStatus:XCTAsyncTestCaseStatusUnknown timeout:2.0], @"there should be an exception");
}

@end
