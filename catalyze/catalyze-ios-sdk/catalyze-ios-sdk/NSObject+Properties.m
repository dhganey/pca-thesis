//
//  NSObject+Properties.m
//  Catalyze
//
//  Created by Josh Ault on 3/24/14.
//  Copyright (c) 2014 Catalyze, Inc. All rights reserved.
//

#import "NSObject+Properties.h"
#import <objc/runtime.h>

@implementation NSObject (Properties)

+ (NSArray *) propertyNames {
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
