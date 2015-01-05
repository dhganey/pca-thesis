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
 asynchronous methods. The base url for all objects is listed below.
 */

@class CatalyzeEntry;
@class CatalyzeUser;

typedef void (^CatalyzeSuccessBlock)(id result);
typedef void (^CatalyzeUserSuccessBlock)(CatalyzeUser *result);
typedef void (^CatalyzeEntrySuccessBlock)(CatalyzeEntry *result);
typedef void (^CatalyzeJsonSuccessBlock)(NSDictionary *result);
typedef void (^CatalyzeArraySuccessBlock)(NSArray *result);
typedef void (^CatalyzeDataSuccessBlock)(NSData *result);
typedef void (^CatalyzeFailureBlock)(NSDictionary *result, int status, NSError *error);

/**
 The base URL for the catalyze.io API.
 */
//#define LOCAL_ENV
#define kCatalyzeBaseUrl @"https://api.catalyze.io"
#define kCatalyzeAPIVersionPath @"/v2"

#define kCatalyzeAuthorizationHeader @"Authorization"
#define kCatalyzeApiKeyHeader @"X-Api-Key"

#define kCatalyzeAuthorizationKey @"_catalyze_authorization"
#define kCatalyzeApiKeyKey @"_catalyze_api_key"
#define kCatalyzeAppIdKey @"_catalyze_app_id"
#define kCatalyzeSessionTokenKey @"_catalyze_session_token"
#define kCatalyzeBaseUrlKey @"_catalyze_base_url"

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
