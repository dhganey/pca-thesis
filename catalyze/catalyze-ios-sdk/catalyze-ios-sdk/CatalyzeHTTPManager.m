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

#import "CatalyzeHTTPManager.h"
#import "AFNetworking.h"
#import "Catalyze.h"

@interface CatalyzeHTTPManager()

@property BOOL returned401;
@property AFHTTPRequestOperation *operationHolder;
@property NSError *errorHolder;

@end

@implementation CatalyzeHTTPManager
@synthesize operationHolder = _operationHolder;
@synthesize errorHolder = _errorHolder;
@synthesize returned401 = _returned401;

+ (AFHTTPRequestOperationManager *)httpClient {
    static AFHTTPRequestOperationManager *httpClient = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        httpClient = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:[[NSUserDefaults standardUserDefaults] valueForKey:kCatalyzeBaseUrlKey]]];
#ifdef LOCAL_ENV
        httpClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        httpClient.securityPolicy.allowInvalidCertificates = YES;
#endif
        httpClient.requestSerializer = [AFJSONRequestSerializer serializer];
        [httpClient.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        httpClient.responseSerializer = [AFHTTPResponseSerializer serializer];
        [httpClient.operationQueue setMaxConcurrentOperationCount:1];
    });
    return httpClient;
}

+ (void)doGet:(NSString *)urlString success:(CatalyzeSuccessBlock)success failure:(CatalyzeFailureBlock)failure {
    [CatalyzeHTTPManager updateHeaders];
    
    [[CatalyzeHTTPManager httpClient] GET:[NSString stringWithFormat:@"%@%@",kCatalyzeAPIVersionPath,urlString] parameters:nil success:[CatalyzeHTTPManager successBlock:success] failure:[CatalyzeHTTPManager failureBlock:failure]];
}

+ (void)doPost:(NSString *)urlString withParams:(NSDictionary *)params success:(CatalyzeSuccessBlock)success failure:(CatalyzeFailureBlock)failure {
    [CatalyzeHTTPManager updateHeaders];
    
    [[CatalyzeHTTPManager httpClient] POST:[NSString stringWithFormat:@"%@%@",kCatalyzeAPIVersionPath,urlString] parameters:params success:[CatalyzeHTTPManager successBlock:success] failure:[CatalyzeHTTPManager failureBlock:failure]];
}

+ (void)doPut:(NSString *)urlString withParams:(NSDictionary *)params success:(CatalyzeSuccessBlock)success failure:(CatalyzeFailureBlock)failure {
    [CatalyzeHTTPManager updateHeaders];
    
    [[CatalyzeHTTPManager httpClient] PUT:[NSString stringWithFormat:@"%@%@",kCatalyzeAPIVersionPath,urlString] parameters:params success:[CatalyzeHTTPManager successBlock:success] failure:[CatalyzeHTTPManager failureBlock:failure]];
}

+ (void)doDelete:(NSString *)urlString success:(CatalyzeSuccessBlock)success failure:(CatalyzeFailureBlock)failure {
    [CatalyzeHTTPManager updateHeaders];
    
    [[CatalyzeHTTPManager httpClient] DELETE:[NSString stringWithFormat:@"%@%@",kCatalyzeAPIVersionPath,urlString] parameters:nil success:[CatalyzeHTTPManager successBlock:success] failure:[CatalyzeHTTPManager failureBlock:failure]];
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
    [[CatalyzeHTTPManager httpClient].requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",[[NSUserDefaults standardUserDefaults] valueForKey:kCatalyzeAuthorizationKey]] forHTTPHeaderField:kCatalyzeAuthorizationHeader];
    [[CatalyzeHTTPManager httpClient].requestSerializer setValue:[NSString stringWithFormat:@"%@", [Catalyze apiKey]] forHTTPHeaderField:kCatalyzeApiKeyHeader];
}

@end
