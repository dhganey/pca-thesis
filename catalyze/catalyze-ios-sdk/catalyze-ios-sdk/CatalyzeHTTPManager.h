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
 The CatalyzeHTTPManager class provides an abstracted layer of functionality in 
 order to not clutter to core of the catalyze.io iOS SDK. Network calls were viewed 
 as a separate entity of the SDK entirely.  In order to emphasize this, **ALL** 
 network traffic in or out of the SDK goes through one of the following four 
 methods.  The library used for network traffic is AFNetworking found here 
 http://afnetworking.com/ . 
 
 The main purpose for this class is to translate AFNetworking results into
 completion blocks specified in CatalyzeConstants.
 
 This class does not have any ties to the rest of the catalyze.io iOS SDK and so 
 it can be used as its own entity for your personal networking use.  Or you 
 can simply download AFNetworking directly at the above link.
 */

#import <Foundation/Foundation.h>
#import "CatalyzeConstants.h"

@interface CatalyzeHTTPManager : NSObject

/** @name GET */

/**
 Performs a GET request at the given url and executes the CatalyzeHTTPResponseBlock 
 upon completion of the request whether it succeeded or failed.  
 
 @param urlString the url to direct the request to
 @param block the completion block to be executed upon the request's completion
 */
+ (void)doGet:(NSString *)urlString block:(CatalyzeHTTPResponseBlock)block;

/** @name POST */

/**
 Performs a POST request at the given url with the given parameters and executes 
 the CatalyzeHTTPResponseBlock upon completion of the request whether it succeeded 
 or failed.
 
 @param urlString the url to direct the request to
 @param params the key value pairs to be sent to the specified url
 @param block the completion block to be executed upon the request's completion
 */
+ (void)doPost:(NSString *)urlString withParams:(NSDictionary *)params block:(CatalyzeHTTPResponseBlock)block;

/**
 Identical to doPost:withParams:block: except that this method has a CatalyzeHTTPArrayResponseBlock instead
 of the basic HTTP response.
 
 @param urlString the url to direct the request to
 @param params the key value pairs to be sent to the specified url
 @param block the completion block to be executed upon the request's completion
 */
+ (void)doQueryPost:(NSString *)urlString withParams:(NSDictionary *)params block:(CatalyzeHTTPArrayResponseBlock)block;

/** @name PUT */

/**
 Performs a PUT request at the given url with the given parameters and executes 
 the CatalyzeHTTPResponseBlock upon completion of the request whether it succeeded 
 or failed.
 
 @param urlString the url to direct the request to
 @param params the key value pairs to be sent to the specified url
 @param block the completion block to be executed upon the request's completion
 */
+ (void)doPut:(NSString *)urlString withParams:(NSDictionary *)params block:(CatalyzeHTTPResponseBlock)block;

/** @name DELETE */

/**
 Performs a DELETE request at the given url and executes the CatalyzeHTTPResponseBlock
 upon completion of the request whether it succeeded or failed.
 
 @param urlString the url to direct the request to
 @param block the completion block to be executed upon the request's completion
 */
+ (void)doDelete:(NSString *)urlString block:(CatalyzeHTTPResponseBlock)block;

@end
