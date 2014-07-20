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

#import "HealthPlan.h"

#define kEncodeKeyInstitutionsId @"health_plan_institutions_id"
#define kEncodeKeyGroupId @"health_plan_group_id"
#define kEncodeKeyGroupName @"health_plan_group_name"
#define kEncodeKeyMemberId @"health_plan_member_id"
#define kEncodeKeyType @"health_plan_type"

@implementation HealthPlan
@synthesize institutionsId = _institutionsId;
@synthesize groupId = _groupId;
@synthesize groupName = _groupName;
@synthesize memberId = _memberId;
@synthesize type = _type;

- (id)init {
    self = [super init];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_institutionsId forKey:kEncodeKeyInstitutionsId];
    [aCoder encodeObject:_groupId forKey:kEncodeKeyGroupId];
    [aCoder encodeObject:_groupName forKey:kEncodeKeyGroupName];
    [aCoder encodeObject:_memberId forKey:kEncodeKeyMemberId];
    [aCoder encodeObject:_type forKey:kEncodeKeyType];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [self init];
    if (self) {;
        [self setInstitutionsId:[aDecoder decodeObjectForKey:kEncodeKeyInstitutionsId]];
        [self setGroupId:[aDecoder decodeObjectForKey:kEncodeKeyGroupId]];
        [self setGroupName:[aDecoder decodeObjectForKey:kEncodeKeyGroupName]];
        [self setMemberId:[aDecoder decodeObjectForKey:kEncodeKeyMemberId]];
        [self setType:[aDecoder decodeObjectForKey:kEncodeKeyType]];
    }
    return self;
}

@end
