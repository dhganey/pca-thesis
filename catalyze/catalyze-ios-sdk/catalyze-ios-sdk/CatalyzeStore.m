//
//  CatalyzeStore.m
//  catalyze-ios-sdk
//
//  Created by Josh Ault on 9/3/14.
//  Copyright (c) 2014 Catalyze, Inc. All rights reserved.
//

#import "CatalyzeStore.h"
#import "CatalyzeEntry.h"

@implementation CatalyzeStore

+ (HKHealthStore *)healthStore {
    static HKHealthStore *healthStore = nil;
    static dispatch_once_t catalyzeHealthStoreOncePredicate;
    dispatch_once(&catalyzeHealthStoreOncePredicate, ^{
        healthStore = [[HKHealthStore alloc] init];
    });
    return healthStore;
}

+ (void)saveQuantitySampleWithUnitString:(NSString *)unitString value:(double)value identifier:(NSString *)identifier startDate:(NSDate *)startDate endDate:(NSDate *)endDate metadata:(NSDictionary *)metadata completion:(void (^)(BOOL, NSError *))completion {
    //create a CatalyzeEntry and save to the Catalyze API
    CatalyzeEntry *entry = [CatalyzeEntry entryWithClassName:@"health_kit"];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
    
    [entry.content setObject:[formatter stringFromDate:startDate] forKey:@"startDate"];
    [entry.content setObject:[formatter stringFromDate:endDate] forKey:@"endDate"];
    
    [entry.content setValue:identifier forKey:@"identifier"];
    [entry.content setValue:[NSNumber numberWithDouble:value] forKey:@"value"];
    [entry.content setValue:unitString forKey:@"units"];
    
    [entry createInBackgroundWithSuccess:^(id result) {
        NSLog(@"successfully created entry!");
    } failure:^(NSDictionary *result, int status, NSError *error) {
        NSLog(@"Failed to create entry! %i - %@", status, result);
    }];
    
    //save to healthkit
    HKUnit *unit = [HKUnit unitFromString:unitString];
    HKQuantity *quantity = [HKQuantity quantityWithUnit:unit doubleValue:value];
    HKQuantityType *type = [HKObjectType quantityTypeForIdentifier:identifier];
    HKQuantitySample *sample = [HKQuantitySample quantitySampleWithType:type quantity:quantity startDate:startDate endDate:endDate metadata:metadata];
    [[CatalyzeStore healthStore] saveObject:sample withCompletion:^(BOOL success, NSError *error) {
        if (!success) {
            NSLog(@"An error occured saving to health kit. The error was: %@.", error);
        } else {
            NSLog(@"successfully stored data in health kit");
        }
        //almost all completion blocks used in health kit are executed on an arbitrary background queue, so to
        //do anything useful, especially with the UI we have to dispatch the useful code back on the main queue
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completion) completion(success, error);
        });
    }];
}

@end
