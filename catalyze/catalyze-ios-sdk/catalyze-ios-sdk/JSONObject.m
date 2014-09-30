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

#import "JSONObject.h"
#import "NSObject+Properties.h"
#import "CatalyzeUser.h"

@implementation JSONObject

- (id)JSON:(Class)aClass {
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    NSArray *propertyNames = [aClass propertyNames];
    
	NSString *propName;
	for (propName in propertyNames) {
        id value = [self valueForKey:propName];
        if ([value isKindOfClass:[NSDate class]]) {
            NSDateFormatter *format = [[NSDateFormatter alloc] init];
            [format setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
            if ([propName isEqualToString:@"createdAt"] || [propName isEqualToString:@"updatedAt"]) {
                //only set the full length for the createdAt and updatedAt timestamps, everything else uses short dates
                [format setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
            } else {
                [format setDateFormat:@"yyyy-MM-dd"];
            }
            value = [format stringFromDate:value];
        }
		[dict setValue:value forKey:propName];
	}
	
	return dict;
}

- (void)setValue:(id)value forKey:(NSString *)key {
    @try {
        [super setValue:value forKey:key];
    } @catch (NSException *e) {}
}

@end
