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

#import "NSObject+Properties.h"
#import <objc/runtime.h>

@implementation NSObject (Properties)

+ (NSArray *)propertyNames {
	unsigned int i, count = 0;
	objc_property_t * properties = class_copyPropertyList( self, &count );
	
	if ( count == 0 )
	{
		free( properties );
		return ( nil );
	}
	
	NSMutableArray * list = [NSMutableArray array];
	
	for ( i = 0; i < count; i++ )
		[list addObject: [NSString stringWithUTF8String: property_getName(properties[i])]];
    
    free( properties );   // Fixed by Eli Wang
	
	return ( [list copy] );
}

@end
