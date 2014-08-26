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
 The CatalyzeFileManager class provides an abstracted layer of functionality in
 order to not clutter to core of the catalyze.io iOS SDK. Network calls were viewed
 as a separate entity of the SDK entirely.  In order to emphasize this, **ALL**
 network traffic uploading or downloading files in or out of the SDK goes through
 this class. The library used for network traffic is AFNetworking found here
 http://afnetworking.com/ .
 
 The main purpose for this class is to translate AFNetworking results into
 completion blocks specified in CatalyzeConstants.
 
 This class does not have any ties to the rest of the catalyze.io iOS SDK and so
 it can be used as its own entity for your personal networking use.  Or you
 can simply use AFNetworking directly.
 */

#import <Foundation/Foundation.h>
#import "CatalyzeConstants.h"

@interface CatalyzeFileManager : NSObject

+ (void)uploadFileToUser:(NSData *)file phi:(BOOL)phi mimeType:(NSString *)mimeType success:(CatalyzeJsonSuccessBlock)success failure:(CatalyzeFailureBlock)failure;

+ (void)listFiles:(CatalyzeArraySuccessBlock)success failure:(CatalyzeFailureBlock)failure;

+ (void)retrieveFile:(NSString *)filesId success:(CatalyzeDataSuccessBlock)success failure:(CatalyzeFailureBlock)failure;

+ (void)deleteFile:(NSString *)filesId success:(CatalyzeSuccessBlock)success failure:(CatalyzeFailureBlock)failure;

+ (void)uploadFileToOtherUser:(NSData *)file usersId:(NSString *)usersId phi:(BOOL)phi mimeType:(NSString *)mimeType success:(CatalyzeJsonSuccessBlock)success failure:(CatalyzeFailureBlock)failure;

+ (void)listFilesForUser:(NSString *)usersId success:(CatalyzeArraySuccessBlock)success failure:(CatalyzeFailureBlock)failure;

+ (void)retrieveFileFromUser:(NSString *)filesId usersId:(NSString *)usersId success:(CatalyzeDataSuccessBlock)success failure:(CatalyzeFailureBlock)failure;

+ (void)deleteFileFromUser:(NSString *)filesId usersId:(NSString *)usersId success:(CatalyzeSuccessBlock)success failure:(CatalyzeFailureBlock)failure;

@end
