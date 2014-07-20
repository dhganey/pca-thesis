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

#import "Mrn.h"

#define kEncodeKeyInstitutionsId @"mrn_institutions_id"
#define kEncodeKeyMrn @"mrn_mrn"

@implementation Mrn
@synthesize institutionsId = _institutionsId;
@synthesize mrn = _mrn;

- (id)init {
    self = [super init];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_institutionsId forKey:kEncodeKeyInstitutionsId];
    [aCoder encodeObject:_mrn forKey:kEncodeKeyMrn];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [self init];
    if (self) {;
        [self setInstitutionsId:[aDecoder decodeObjectForKey:kEncodeKeyInstitutionsId]];
        [self setMrn:[aDecoder decodeObjectForKey:kEncodeKeyMrn]];
    }
    return self;
}

@end
