//
//  JSONObject.m
//  catalyze-ios-sdk
//
//  Created by Josh Ault on 3/23/14.
//  Copyright (c) 2014 Catalyze, Inc. All rights reserved.
//

#import "JSONObject.h"
#import "NSObject+Properties.h"

@implementation JSONObject

- (id)JSON:(Class)aClass {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    NSArray *propertyNames = [aClass propertyNames];
    
	NSString *propName;
	for (propName in propertyNames) {
		[dict setValue:[self valueForKey:propName] forKey:propName];
	}
	
	return dict;
}

@end
