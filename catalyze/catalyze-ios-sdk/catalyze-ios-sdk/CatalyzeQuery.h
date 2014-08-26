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
 A CatalyzeQuery is a developers tool for searching a custom class.  CatalyzeQuery's are initialized
 with a class name which corresponds to a pre-defined custom class on the cataluze.io API.
 CatalyzeQuerys are used to search a single field to match a single value.  These are specified 
 by queryField and queryValue.  Paging is also included with pageNumber and pageSize.  
 
 **NOTE**
 Future releases are on track to have a more in depth Querying API. 
 */

#import <Foundation/Foundation.h>
#import "Catalyze.h"

@interface CatalyzeQuery : NSObject

#pragma mark Constructors

/** @name Constructors */

/**
 Initializes a CatalyzeQuery object with the given class name.  This class name is used
 for URLs dealing with the custom class.
 
 @param className the name of the custom class on the catalyze.io API being queried.
 */
+ (CatalyzeQuery *)queryWithClassName:(NSString *)className;

/**
 Initializes a CatalyzeQuery object with the given class name.  This class name is used
 for URLs dealing with the custom class.
 
 @param newClassName the name of the custom class on the catalyze.io API being queried.
 */
- (id)initWithClassName:(NSString *)newClassName;

#pragma mark -
#pragma mark Properties

/** @name Properties */

/**
 The name of the custom class that this query is searching.
 */
@property (readonly) NSString *catalyzeClassName;

/**
 The name of the column to search in.
 */
@property (strong, nonatomic) NSString *queryField;

/**
 The value to look for in the column queryField.
 */
@property (strong, nonatomic) id queryValue;

/**
 The page number to get results from.
 */
@property int pageNumber;

/**
 The size of the pages to retrieve results from.
 */
@property int pageSize;

#pragma mark -
#pragma mark Retrieve

/** @name Retrieve */

/**
 Performs the query asynchronously.  This should only be called after setting at minimum, the
 queryField and queryValue.  Upon completion of the request, the CatalyzeArrayResultBlock is
 performed with the results of the query. This query requires administrator, superivsor, or
 the appropriate ACL permission level to query all entries in a custom class.
 
 @param block the completion block to be executed upon the request's completion
 */
- (void)retrieveAllEntriesInBackgroundWithSuccess:(CatalyzeArraySuccessBlock)success failure:(CatalyzeFailureBlock)failure;

/**
 Performs the query asynchronously.  This should only be called after setting at minimum, the
 queryField and queryValue.  Upon completion of the request, the given selector will be
 performed on the given target with the array of results as the object of the selector.
 This query requires administrator, superivsor, or the appropriate ACL permission level 
 to query all entries in a custom class.
 
 **NOTE:**
 The selector is performed on the target on the **Main Thread** see
 [[NSThread mainThread]](http://bit.ly/11Z9D47)
 
 @param target the target to perform the given selector on the **Main Thread**
 upon the request's completion
 @param selector the selector to be performed on the given target on the **Main Thread**
 upon the request's completion
 */
- (void)retrieveAllEntriesInBackgroundWithTarget:(id)target selector:(SEL)selector;

/**
 Performs the query asynchronously.  This should only be called after setting at minimum, the
 queryField and queryValue.  Upon completion of the request, the CatalyzeArrayResultBlock is 
 performed with the results of the query. This only queries for your own entries.
 
 @param block the completion block to be executed upon the request's completion
 */
- (void)retrieveInBackgroundWithSuccess:(CatalyzeArraySuccessBlock)success failure:(CatalyzeFailureBlock)failure;

/**
 Performs the query asynchronously.  This should only be called after setting at minimum, the
 queryField and queryValue.  Upon completion of the request, the given selector will be 
 performed on the given target with the array of results as the object of the selector.
 This only queries for your own entries.
 
 **NOTE:**
 The selector is performed on the target on the **Main Thread** see
 [[NSThread mainThread]](http://bit.ly/11Z9D47)
 
 @param target the target to perform the given selector on the **Main Thread**
 upon the request's completion
 @param selector the selector to be performed on the given target on the **Main Thread**
 upon the request's completion
 */
- (void)retrieveInBackgroundWithTarget:(id)target selector:(SEL)selector;

/**
 Performs the query asynchronously.  This should only be called after setting at minimum, the
 queryField and queryValue.  Upon completion of the request, the CatalyzeArrayResultBlock is
 performed with the results of the query. This query searches all entries in a custom class
 that belong to the user with the given usersId. The user performing this query must have
 administrator, supervisor, or the appropriate ACL permissions to view the data belonging to
 that user.
 
 @param usersId the ID of the user whose entries are to be queried for
 @param block the completion block to be executed upon the request's completion
 */
- (void)retrieveInBackgroundForUsersId:(NSString *)usersId success:(CatalyzeArraySuccessBlock)success failure:(CatalyzeFailureBlock)failure;

/**
 Performs the query asynchronously.  This should only be called after setting at minimum, the
 queryField and queryValue.  Upon completion of the request, the given selector will be
 performed on the given target with the array of results as the object of the selector.
 This query searches all entries in a custom class that belong to the user with the given 
 usersId. The user performing this query must have administrator, supervisor, or the 
 appropriate ACL permissions to view the data belonging to that user.
 
 **NOTE:**
 The selector is performed on the target on the **Main Thread** see
 [[NSThread mainThread]](http://bit.ly/11Z9D47)
 
 @param usersId the ID of the user whose entries are to be queried for
 @param target the target to perform the given selector on the **Main Thread**
 upon the request's completion
 @param selector the selector to be performed on the given target on the **Main Thread**
 upon the request's completion
 */
- (void)retrieveInBackgroundForUsersId:(NSString *)usersId target:(id)target selector:(SEL)selector;

@end
