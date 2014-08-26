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
 The catalyze.io iOS SDK is the preferred way of interacting with the catalyze.io 
 API when developing for iOS.  Functionalities include user, session, custom classes and data, 
 as well as querying management.  You can also find a guide for developing with the catalyze.io
 iOS SDK on the github repo.  This guide walks you through some of the most common 
 ways to use the SDK with code examples.  
 
 This class allows you to set and get your app key, url scheme, and app id as well 
 as provides a single file that you import in any place you need to use the 
 catalyze.io iOS SDK.  No matter which part of the SDK you are using, simply 
 "#import Catalyze.h" at the top of the file.
 
 **NOTE:**
 Developers must set their api key and app id in
 application:didFinishLaunchingWithOptions: or an exception will be thrown on the first network 
 request.
 */

#import <Foundation/Foundation.h>
#import "CatalyzeConstants.h"
#import "CatalyzeObject.h"
#import "CatalyzeEntry.h"
#import "CatalyzeReference.h"
#import "CatalyzeUser.h"
#import "CatalyzeHTTPManager.h"
#import "CatalyzeFileManager.h"
#import "CatalyzeQuery.h"
#import "Email.h"
#import "Name.h"
#import "PhoneNumber.h"
#import "Address.h"
#import "Geocode.h"
#import "Guardian.h"
#import "Language.h"
#import "SocialId.h"
#import "Mrn.h"
#import "HealthPlan.h"

@interface Catalyze : NSObject

/** @name Catalyze */

/** 
 @param applicationKey the app key given to developers for this specific app on http://developer.catalyze.io
 @param scheme the url scheme used for login callbacks that redirects a user back to their application on successful authentication
 @param appId the id of the application on the catalyze.io API
 */
+ (void)setApiKey:(NSString *)apiKey applicationId:(NSString *)appId;

/**
 @param applicationKey the app key given to developers for this specific app on http://developer.catalyze.io
 @param scheme the url scheme used for login callbacks that redirects a user back to their application on successful authentication
 @param appId the id of the application on the catalyze.io API
 @param baseUrl the base URL of the BaaS deployment you are using
 */
+ (void)setApiKey:(NSString *)apiKey applicationId:(NSString *)appId baseUrl:(NSString *)baseUrl;

/**
 @return the app key set by the developer in application:didFinishLaunchingWithOptions:
 */
+ (NSString *)apiKey;

/**
 @return the app id set by the developer in application:didFinishLaunchingWithOptions:
 */
+ (NSString *)applicationId;

/**
 Set the default logging level for all network requests. If set to kLoggingLevelOff, all logging will stop. If set to any other
 value, logging will be automatically turned on.
 */
+ (void)setLoggingLevel:(LoggingLevel)level;

@end
