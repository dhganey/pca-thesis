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

/**
 CatalyzeEntry is the base class of CatalyzeUser.  It is also the base class for custom
 classes on the catalyze.io API.  A CatalyzeEntry is initialized with the name of the custom
 class it is associated with and is the container for an Entry in that class.
 
 CatalyzeEntry stores all of the fields in its objectDict.  CatalyzeEntry will
 only send fields to the catalyze.io API that have been changed.  See dirtyFields.
 This is in place to save on network traffic size and to increase overall performance
 of the SDK.
 
 **NOTE**
 Unless instantiated for use with a Custom Class, a CatalyzeEntry should never be used in 
 place of a CatalyzeUser.  If you are dealing with a user, please use CatalyzeUser.
 */

#import <Foundation/Foundation.h>
#import "CatalyzeConstants.h"
#import "CatalyzeObjectProtocol.h"

@interface CatalyzeEntry : NSObject<CatalyzeObjectProtocol>

#pragma mark Constructors

/** @name Constructors */

/**
 Initializes a CatalyzeEntry with a class name.  This class name is used to lookup
 URL routes.  Valid class names are those which are named after a custom class on the
 catalyze.io API.
 
 @param className a valid class name representing the type of CatalyzeEntry being created
 @return a newly created CatalyzeEntry with the given class name
 @exception NSInvalidArgumentException will be thrown if className is not a valid class name specified in CatalyzeConstants
 */
+ (CatalyzeEntry *)entryWithClassName:(NSString *)className;

/**
 Initializes a CatalyzeEntry with a class name.  This class name is used to lookup
 URL routes.  Valid class names are those which are named after a custom class on the
 catalyze.io API. The dictionary may contain any key value pairs, such as predefined 
 fields like first_name, last_name or custom fields.
 
 @param className a valid class name representing the type of CatalyzeEntry being created
 @param dictionary key value pairs to be stored with the CatalyzeEntry on the next network request.
 @return a newly created CatalyzeEntry with the given class name and key value pairs stored from the dictionary
 @exception NSInvalidArgumentException will be thrown if className is not a valid class name specified in CatalyzeConstants
 */
+ (CatalyzeEntry *)entryWithClassName:(NSString *)className dictionary:(NSDictionary *)dictionary;

/**
 Constructs a new instance of CatalzeObject with the given class name.  See [CatalyzeEntry objectWithClassName:]
 
 @param newClassName a valid class name representing the type of CatalyzeEntry being created
 @return the newly created instance of CatalyzeEntry
 */
- (id)initWithClassName:(NSString *)newClassName;

#pragma mark -
#pragma mark Properties

/** @name Properties */

@property (strong, nonatomic) NSString *className;
@property (strong, nonatomic) NSString *authorId;
@property (strong, nonatomic) NSString *parentId;
@property (strong, nonatomic) NSString *entryId;
@property (strong, nonatomic) NSMutableDictionary *content;
@property (strong, nonatomic) NSDate *createdAt;
@property (strong, nonatomic) NSDate *updatedAt;

#pragma mark -
#pragma mark Create

/** @name Create */

- (void)createInBackgroundForUserWithUsersId:(NSString *)usersId;

- (void)createInBackgroundForUserWithUsersId:(NSString *)usersId success:(CatalyzeSuccessBlock)success failure:(CatalyzeFailureBlock)failure;

- (void)createInBackgroundForUserWithUsersId:(NSString *)usersId target:(id)target selector:(SEL)selector;

@end
