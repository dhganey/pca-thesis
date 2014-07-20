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

#import "Name.h"

#define kEncodeKeyPrefix @"name_prefix"
#define kEncodeKeyFirstName @"name_first_name"
#define kEncodeKeyMiddleName @"name_middle_name"
#define kEncodeKeyLastName @"name_last_name"
#define kEncodeKeyMaidenName @"name_maiden_name"
#define kEncodeKeySuffix @"name_suffix"

@implementation Name
@synthesize prefix = _prefix;
@synthesize firstName = _firstName;
@synthesize middleName = _middleName;
@synthesize lastName = _lastName;
@synthesize maidenName = _maidenName;
@synthesize suffix = _suffix;

- (id)init {
    self = [super init];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_prefix forKey:kEncodeKeyPrefix];
    [aCoder encodeObject:_firstName forKey:kEncodeKeyFirstName];
    [aCoder encodeObject:_middleName forKey:kEncodeKeyMiddleName];
    [aCoder encodeObject:_lastName forKey:kEncodeKeyLastName];
    [aCoder encodeObject:_maidenName forKey:kEncodeKeyMaidenName];
    [aCoder encodeObject:_suffix forKey:kEncodeKeySuffix];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [self init];
    if (self) {;
        [self setPrefix:[aDecoder decodeObjectForKey:kEncodeKeyPrefix]];
        [self setFirstName:[aDecoder decodeObjectForKey:kEncodeKeyFirstName]];
        [self setMiddleName:[aDecoder decodeObjectForKey:kEncodeKeyMiddleName]];
        [self setLastName:[aDecoder decodeObjectForKey:kEncodeKeyLastName]];
        [self setMaidenName:[aDecoder decodeObjectForKey:kEncodeKeyMaidenName]];
        [self setSuffix:[aDecoder decodeObjectForKey:kEncodeKeySuffix]];
    }
    return self;
}

@end
