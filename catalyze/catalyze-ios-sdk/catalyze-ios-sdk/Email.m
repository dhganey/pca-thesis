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

#import "Email.h"

#define kEncodeKeyPrimary @"email_primary"
#define kEncodeKeySecondary @"email_secondary"
#define kEncodeKeyWork @"email_work"
#define kEncodeKeyOther @"email_other"

@implementation Email
@synthesize primary = _primary;
@synthesize secondary = _secondary;
@synthesize work = _work;
@synthesize other = _other;

- (id)init {
    self = [super init];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_primary forKey:kEncodeKeyPrimary];
    [aCoder encodeObject:_secondary forKey:kEncodeKeySecondary];
    [aCoder encodeObject:_work forKey:kEncodeKeyWork];
    [aCoder encodeObject:_other forKey:kEncodeKeyOther];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [self init];
    if (self) {;
        [self setPrimary:[aDecoder decodeObjectForKey:kEncodeKeyPrimary]];
        [self setSecondary:[aDecoder decodeObjectForKey:kEncodeKeySecondary]];
        [self setWork:[aDecoder decodeObjectForKey:kEncodeKeyWork]];
        [self setOther:[aDecoder decodeObjectForKey:kEncodeKeyOther]];
    }
    return self;
}

@end
