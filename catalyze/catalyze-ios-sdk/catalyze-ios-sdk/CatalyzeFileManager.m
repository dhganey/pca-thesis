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

#import "CatalyzeFileManager.h"
#import "AFNetworking.h"
#import "Catalyze.h"

@interface CatalyzeFileManager()

@end

@implementation CatalyzeFileManager

+ (AFHTTPRequestOperationManager *)fileClient {
    static AFHTTPRequestOperationManager *fileClient = nil;
    static dispatch_once_t onceFilePredicate;
    dispatch_once(&onceFilePredicate, ^{
        fileClient = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] valueForKey:kCatalyzeBaseUrlKey]]];
#ifdef LOCAL_ENV
        fileClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        fileClient.securityPolicy.allowInvalidCertificates = YES;
#endif
        fileClient.responseSerializer = [AFHTTPResponseSerializer serializer];
        [fileClient.operationQueue setMaxConcurrentOperationCount:1];
    });
    return fileClient;
}

+ (void)uploadFileToUser:(NSData *)file phi:(BOOL)phi mimeType:(NSString *)mimeType success:(CatalyzeJsonSuccessBlock)success failure:(CatalyzeFailureBlock)failure {
    [CatalyzeFileManager updateHeaders];
    
    [[CatalyzeFileManager fileClient] POST:[NSString stringWithFormat:@"%@/users/files",kCatalyzeAPIVersionPath] parameters:@{@"phi":[NSNumber numberWithBool:phi]} constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:file name:@"file" fileName:@"filename" mimeType:mimeType];
    } success:[CatalyzeFileManager successBlock:success] failure:[CatalyzeFileManager failureBlock:failure]];
}

+ (void)listFiles:(CatalyzeArraySuccessBlock)success failure:(CatalyzeFailureBlock)failure {
    [CatalyzeFileManager updateHeaders];
    
    [[CatalyzeFileManager fileClient] GET:[NSString stringWithFormat:@"%@/users/files",kCatalyzeAPIVersionPath] parameters:nil success:[CatalyzeFileManager successBlock:success] failure:[CatalyzeFileManager failureBlock:failure]];
}

+ (void)retrieveFile:(NSString *)filesId success:(CatalyzeDataSuccessBlock)success failure:(CatalyzeFailureBlock)failure {
    [CatalyzeFileManager updateHeaders];
    
    [[CatalyzeFileManager fileClient] GET:[NSString stringWithFormat:@"%@/users/files/%@",kCatalyzeAPIVersionPath,filesId] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:[CatalyzeFileManager failureBlock:failure]];
}

+ (void)deleteFile:(NSString *)filesId success:(CatalyzeSuccessBlock)success failure:(CatalyzeFailureBlock)failure {
    [CatalyzeFileManager updateHeaders];
    
    [[CatalyzeFileManager fileClient] DELETE:[NSString stringWithFormat:@"%@/users/files/%@",kCatalyzeAPIVersionPath,filesId] parameters:nil success:[CatalyzeFileManager successBlock:success] failure:[CatalyzeFileManager failureBlock:failure]];
}

+ (void)uploadFileToOtherUser:(NSData *)file usersId:(NSString *)usersId phi:(BOOL)phi mimeType:(NSString *)mimeType success:(CatalyzeJsonSuccessBlock)success failure:(CatalyzeFailureBlock)failure {
    [CatalyzeFileManager updateHeaders];
    
    [[CatalyzeFileManager fileClient] POST:[NSString stringWithFormat:@"%@/users/%@/files",kCatalyzeAPIVersionPath,usersId] parameters:@{@"phi":[NSNumber numberWithBool:phi]} constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:file name:@"file" fileName:@"filename" mimeType:mimeType];
    } success:[CatalyzeFileManager successBlock:success] failure:[CatalyzeFileManager failureBlock:failure]];
}

+ (void)listFilesForUser:(NSString *)usersId success:(CatalyzeArraySuccessBlock)success failure:(CatalyzeFailureBlock)failure {
    [CatalyzeFileManager updateHeaders];
    
    [[CatalyzeFileManager fileClient] GET:[NSString stringWithFormat:@"%@/users/%@/files",kCatalyzeAPIVersionPath,usersId] parameters:nil success:[CatalyzeFileManager successBlock:success] failure:[CatalyzeFileManager failureBlock:failure]];
}

+ (void)retrieveFileFromUser:(NSString *)filesId usersId:(NSString *)usersId success:(CatalyzeDataSuccessBlock)success failure:(CatalyzeFailureBlock)failure {
    [CatalyzeFileManager updateHeaders];
    
    [[CatalyzeFileManager fileClient] GET:[NSString stringWithFormat:@"%@/users/%@/files/%@",kCatalyzeAPIVersionPath,usersId,filesId] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:[CatalyzeFileManager failureBlock:failure]];
}

+ (void)deleteFileFromUser:(NSString *)filesId usersId:(NSString *)usersId success:(CatalyzeSuccessBlock)success failure:(CatalyzeFailureBlock)failure {
    [CatalyzeFileManager updateHeaders];
    
    [[CatalyzeFileManager fileClient] DELETE:[NSString stringWithFormat:@"%@/users/%@/files/%@",kCatalyzeAPIVersionPath,usersId,filesId] parameters:nil success:[CatalyzeFileManager successBlock:success] failure:[CatalyzeFileManager failureBlock:failure]];
}

+ (void (^)(AFHTTPRequestOperation *operation, id responseObject))successBlock:(CatalyzeSuccessBlock)success {
    return ^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success([NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil]);
        }
    };
}

+ (void (^)(AFHTTPRequestOperation *operation, id responseObject))failureBlock:(CatalyzeFailureBlock)failure {
    return ^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure([NSJSONSerialization JSONObjectWithData:[operation responseObject] options:0 error:nil], (int)[[operation response] statusCode], error);
        }
    };
}

+ (void)updateHeaders {
    [[CatalyzeFileManager fileClient].requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",[[NSUserDefaults standardUserDefaults] valueForKey:kCatalyzeAuthorizationKey]] forHTTPHeaderField:kCatalyzeAuthorizationHeader];
    [[CatalyzeFileManager fileClient].requestSerializer setValue:[NSString stringWithFormat:@"%@", [Catalyze apiKey]] forHTTPHeaderField:kCatalyzeApiKeyHeader];
}

@end
