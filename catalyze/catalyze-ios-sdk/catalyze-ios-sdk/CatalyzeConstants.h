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
 The CatalyzeConstants is where all of the completion blocks are defined for 
 asynchronous methods as well as the values used for catalyzeClassName in 
 CatalyzeObject.  These catalyzeClassNames are then used to lookup the url that 
 any network request should be directed to.  The base url for all objects is listed
 below.
 */

@class CatalyzeObject;
@class CatalyzeUser;

/**
 The completion block indicating whether or not any given request was a success or not.
 
 @param succeeded indicates if the request was a success
 @param status the HTTP status code received from the network request.
 @param error any error that went wrong during the request, nil if successful
 */
typedef void (^CatalyzeBooleanResultBlock)(BOOL succeeded, int status, NSError *error);

/**
 The completion block used in a saveAll or retrieveAll method that passes back 
 all of the objects that were acted upon
 
 @param objects the array of objects that resulted in the success of the request.  
 nil if the request failed
 @param error any error that went wrong during the request, nil if successful
 */
typedef void (^CatalyzeArrayResultBlock)(NSArray *objects, NSError *error);

/**
 The completion block used when an object should be returned after a successful 
 network request
 
 @param object the object that was successful retrieved, updated, or created, nil 
 if the request failed
 @param error any error that went wrong during the request, nil if successful
 */
typedef void (^CatalyzeObjectResultBlock)(CatalyzeObject *object, NSError *error);

/**
 The completion block used when a network request is finished.  This is primarily
 used in CatalyzeHTTPManager.
 
 @param status the HTTP status code received from the network request.
 @param response the raw string that the catalyze.io server responded with
 @param error any error that went wrong during the request, nil if successful
 */
typedef void (^CatalyzeHTTPResponseBlock)(int status, NSString *response, NSError *error);

/**
 The completion block used when a network request is finished and an array of objects
 is expected as the result.
 
 @param status the HTTP status code received from the network request.
 @param response the raw array of objects that the catalyze.io server
 responded with
 @param error any error that went wrong during the request, nil if successful
 */
typedef void (^CatalyzeHTTPArrayResponseBlock)(int status, NSArray *response, NSError *error);

/**
 The completion block used when a User authenticates and the SDK takes care of the rest.  After
 saving any data needed, the completion block is performed.
 
 @param authenticated boolean flag indicating if the User successfully signed in
 @param newUser boolean flag indicating if this is the first time this user has signed in
 */
typedef void (^CatalyzeHandleOpenURLBlock)(BOOL authenticated, BOOL newUser);

/**
 The base URL for the catalyze.io API.  All URLs begin with this URL.
 */
#define kCatalyzeBaseURL @"https://apiv2.catalyze.io"

typedef enum {
    kLoggingLevelDebug,
    kLoggingLevelInfo,
    kLoggingLevelOff,
    kLoggingLevelWarn
} LoggingLevel;

/**
 Logging Levels (from AFNetworkingActivityLogger.h)
 
 The following constants specify the available logging levels:
 
 kLoggingLevelDebug,
 kLoggingLevelInfo,
 kLoggingLevelOff,
 kLoggingLevelWarn
 
 `kLoggingLevelDebug`
 Logs HTTP method, URL, header fields, & request body for requests, and status code, URL, header fields, response string, & elapsed time for responses.
 
 `kLoggingLevelInfo`
 Logs HTTP method & URL for requests, and status code, URL, & elapsed time for responses.
 
 `kLoggingLevelOff`
 Do not log requests or responses.
 
 `kLoggingLevelWarn`
 Logs HTTP method & URL for requests, and status code, URL, & elapsed time for responses, but only for failed requests.
 */
