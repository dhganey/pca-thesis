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

#import <Foundation/Foundation.h>
#import "JSONObject.h"

@interface HealthPlan : JSONObject<NSCoding>

@property (strong, nonatomic) NSString *institutionsId;
@property (strong, nonatomic) NSString *groupId;
@property (strong, nonatomic) NSString *groupName;
@property (strong, nonatomic) NSString *memberId;
@property (strong, nonatomic) NSString *type;

@end
