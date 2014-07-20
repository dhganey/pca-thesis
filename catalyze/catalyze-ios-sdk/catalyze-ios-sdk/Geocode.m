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

#import "Geocode.h"

#define kEncodeKeyLatitude @"geocode_latitude"
#define kEncodeKeyLongitude @"geocode_longitude"

@implementation Geocode
@synthesize latitude = _latitude;
@synthesize longitude = _longitude;

- (id)init {
    self = [super init];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_latitude forKey:kEncodeKeyLatitude];
    [aCoder encodeObject:_longitude forKey:kEncodeKeyLongitude];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [self init];
    if (self) {;
        [self setLatitude:[aDecoder decodeObjectForKey:kEncodeKeyLatitude]];
        [self setLongitude:[aDecoder decodeObjectForKey:kEncodeKeyLongitude]];
    }
    return self;
}

@end
