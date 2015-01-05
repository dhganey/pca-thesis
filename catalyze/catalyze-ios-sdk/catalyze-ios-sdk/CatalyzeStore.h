//
//  CatalyzeStore.h
//  catalyze-ios-sdk
//
//  Created by Josh Ault on 9/3/14.
//  Copyright (c) 2014 Catalyze, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <HealthKit/HealthKit.h>

@interface CatalyzeStore : NSObject

+ (HKHealthStore *)healthStore;

+ (void)saveQuantitySampleWithUnitString:(NSString *)unitString value:(double)value identifier:(NSString *)identifier startDate:(NSDate *)startDate endDate:(NSDate *)endDate metadata:(NSDictionary *)metadata completion:(void(^)(BOOL success, NSError *error))completion;

@end
