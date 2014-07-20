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

#import "PhoneNumber.h"

#define kEncodeKeyHome @"phone_number_home"
#define kEncodeKeyMobile @"phone_number_mobile"
#define kEncodeKeyWork @"phone_number_work"
#define kEncodeKeyOther @"phone_number_other"
#define kEncodeKeyPreferred @"phone_number_preferred"

@implementation PhoneNumber
@synthesize home = _home;
@synthesize mobile = _mobile;
@synthesize work = _work;
@synthesize other = _other;
@synthesize preferred = _preferred;

- (id)init {
    self = [super init];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_home forKey:kEncodeKeyHome];
    [aCoder encodeObject:_mobile forKey:kEncodeKeyMobile];
    [aCoder encodeObject:_work forKey:kEncodeKeyWork];
    [aCoder encodeObject:_other forKey:kEncodeKeyOther];
    [aCoder encodeObject:_preferred forKey:kEncodeKeyPreferred];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [self init];
    if (self) {;
        [self setHome:[aDecoder decodeObjectForKey:kEncodeKeyHome]];
        [self setMobile:[aDecoder decodeObjectForKey:kEncodeKeyMobile]];
        [self setWork:[aDecoder decodeObjectForKey:kEncodeKeyWork]];
        [self setOther:[aDecoder decodeObjectForKey:kEncodeKeyOther]];
        [self setPreferred:[aDecoder decodeObjectForKey:kEncodeKeyPreferred]];
    }
    return self;
}

@end
