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
#import "CatalyzeObjectProtocol.h"
#import "CatalyzeConstants.h"
#import "Email.h"
#import "Name.h"
#import "PhoneNumber.h"
#import "JSONObject.h"

@interface CatalyzeUser : JSONObject<NSCoding, CatalyzeObjectProtocol>

@property (strong, nonatomic) NSString *usersId;
@property (strong, nonatomic) NSNumber *active;
@property (strong, nonatomic) NSDate *createdAt;
@property (strong, nonatomic) NSDate *updatedAt;
@property (strong, nonatomic) NSString *username;
@property (strong, nonatomic) Email *email;
@property (strong, nonatomic) Name *name;
@property (strong, nonatomic) NSDate *dob;
@property (strong, nonatomic) NSNumber *age;
@property (strong, nonatomic) PhoneNumber *phoneNumber;
@property (strong, nonatomic) NSMutableArray *addresses;
@property (strong, nonatomic) NSString *gender;
@property (strong, nonatomic) NSString *maritalStatus;
@property (strong, nonatomic) NSString *religion;
@property (strong, nonatomic) NSString *race;
@property (strong, nonatomic) NSString *ethnicity;
@property (strong, nonatomic) NSMutableArray *guardians;
@property (strong, nonatomic) NSString *confCode;
@property (strong, nonatomic) NSMutableArray *languages;
@property (strong, nonatomic) NSMutableArray *socialIds;
@property (strong, nonatomic) NSMutableArray *mrns;
@property (strong, nonatomic) NSMutableArray *healthPlans;
@property (strong, nonatomic) NSString *avatar;
@property (strong, nonatomic) NSString *ssn;
@property (strong, nonatomic) NSString *profilePhoto;
@property (strong, nonatomic) NSMutableDictionary *extras;

+ (CatalyzeUser *)currentUser;

- (void)logout;

- (void)logoutWithBlock:(CatalyzeHTTPResponseBlock)block;

- (BOOL)isAuthenticated;

+ (CatalyzeUser *)user;

+ (void)logInWithUsernameInBackground:(NSString *)username password:(NSString *)password block:(CatalyzeHTTPResponseBlock)block;

+ (void)signUpWithUsernameInBackground:(NSString *)username email:(Email *)email name:(Name *)name  password:(NSString *)password block:(CatalyzeHTTPResponseBlock)block;

//TODO validate user routes

- (id)extraForKey:(NSString *)key;
- (void)setExtra:(id)extra forKey:(NSString *)key;
- (void)removeExtraForKey:(NSString *)key;

@end
