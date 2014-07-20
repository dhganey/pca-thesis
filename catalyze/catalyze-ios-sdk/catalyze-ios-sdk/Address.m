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

#import "Address.h"
#import "NSObject+Properties.h"

#define kEncodeKeyType @"address_type"
#define kEncodeKeyAddressLine1 @"address_address_line_1"
#define kEncodeKeyAddressLine2 @"address_address_line_2"
#define kEncodeKeyCity @"address_city"
#define kEncodeKeyState @"address_state"
#define kEncodeKeyZipCode @"address_zip_code"
#define kEncodeKeyCountry @"address_country"
#define kEncodeKeyGeocode @"address_geocode"

@implementation Address
@synthesize type = _type;
@synthesize addressLine1 = _addressLine1;
@synthesize addressLine2 = _addressLine2;
@synthesize city = _city;
@synthesize state = _state;
@synthesize zipCode = _zipCode;
@synthesize country = _country;
@synthesize geocode = _geocode;

- (id)init {
    self = [super init];
    if (self) {
        _geocode = [[Geocode alloc] init];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_type forKey:kEncodeKeyType];
    [aCoder encodeObject:_addressLine1 forKey:kEncodeKeyAddressLine1];
    [aCoder encodeObject:_addressLine2 forKey:kEncodeKeyAddressLine2];
    [aCoder encodeObject:_city forKey:kEncodeKeyCity];
    [aCoder encodeObject:_state forKey:kEncodeKeyState];
    [aCoder encodeObject:_zipCode forKey:kEncodeKeyZipCode];
    [aCoder encodeObject:_country forKey:kEncodeKeyCountry];
    [aCoder encodeObject:_geocode forKey:kEncodeKeyGeocode];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [self init];
    if (self) {;
        [self setType:[aDecoder decodeObjectForKey:kEncodeKeyType]];
        [self setAddressLine1:[aDecoder decodeObjectForKey:kEncodeKeyAddressLine1]];
        [self setAddressLine2:[aDecoder decodeObjectForKey:kEncodeKeyAddressLine2]];
        [self setCity:[aDecoder decodeObjectForKey:kEncodeKeyCity]];
        [self setState:[aDecoder decodeObjectForKey:kEncodeKeyState]];
        [self setZipCode:[aDecoder decodeObjectForKey:kEncodeKeyZipCode]];
        [self setCountry:[aDecoder decodeObjectForKey:kEncodeKeyCountry]];
        [self setGeocode:[aDecoder decodeObjectForKey:kEncodeKeyGeocode]];
    }
    return self;
}

#pragma mark - JSONObject

- (id)JSON:(Class)aClass {
    NSMutableDictionary *dict = [super JSON:aClass];
    
    [dict setObject:[_geocode JSON:[Geocode class]] forKey:@"geocode"];
    return dict;
}

@end
