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

#import "Guardian.h"

#define kEncodeKeyGuardianId @"guardian_guardian_id"
#define kEncodeKeyRelationship @"guardian_relationship"
#define kEncodeKeyViewPhi @"guardian_view_phi"

@implementation Guardian
@synthesize guardianId = _guardianId;
@synthesize relationship = _relationship;
@synthesize viewPhi = _viewPhi;

- (id)init {
    self = [super init];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_guardianId forKey:kEncodeKeyGuardianId];
    [aCoder encodeObject:_relationship forKey:kEncodeKeyRelationship];
    [aCoder encodeObject:_viewPhi forKey:kEncodeKeyViewPhi];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [self init];
    if (self) {;
        [self setGuardianId:[aDecoder decodeObjectForKey:kEncodeKeyGuardianId]];
        [self setRelationship:[aDecoder decodeObjectForKey:kEncodeKeyRelationship]];
        [self setViewPhi:[aDecoder decodeObjectForKey:kEncodeKeyViewPhi]];
    }
    return self;
}

@end
