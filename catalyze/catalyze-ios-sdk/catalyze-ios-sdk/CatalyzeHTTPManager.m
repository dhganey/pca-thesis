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
        httpClient = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:kCatalyzeBaseURL]];
        httpClient.requestSerializer = [AFJSONRequestSerializer serializer];
        [httpClient.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        httpClient.responseSerializer = [AFHTTPResponseSerializer serializer];
        [httpClient.operationQueue setMaxConcurrentOperationCount:1];
    });
    return httpClient;
}

+ (void)doGet:(NSString *)urlString block:(CatalyzeHTTPResponseBlock)block {
    if (CATALYZE_DEBUG) {
        NSLog(@"GET - %@ - %@",urlString, [[NSUserDefaults standardUserDefaults] valueForKey:@"Authorization"]);
    }
    
    [[CatalyzeHTTPManager httpClient].requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",[[NSUserDefaults standardUserDefaults] valueForKey:@"Authorization"]] forHTTPHeaderField:@"Authorization"];
    [[CatalyzeHTTPManager httpClient].requestSerializer setValue:[NSString stringWithFormat:@"%@", [Catalyze apiKey]] forHTTPHeaderField:@"X-Api-Key"];
    
    [[CatalyzeHTTPManager httpClient] GET:[NSString stringWithFormat:@"/v2%@",urlString] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (!responseObject) {
            responseObject = @"";
        }
        block((int)[[operation response] statusCode], [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding], nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (CATALYZE_DEBUG) {
            NSLog(@"error - %@ - %@", error, [error localizedDescription]);
        }
        block((int)[[operation response] statusCode], nil, error);
    }];
}

+ (void)doPost:(NSString *)urlString withParams:(NSDictionary *)params block:(CatalyzeHTTPResponseBlock)block {
    if (CATALYZE_DEBUG) {
        NSLog(@"POST - %@ - %@ - %@",urlString,params, [[NSUserDefaults standardUserDefaults] valueForKey:@"Authorization"]);
    }
    [[CatalyzeHTTPManager httpClient].requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",[[NSUserDefaults standardUserDefaults] valueForKey:@"Authorization"]] forHTTPHeaderField:@"Authorization"];
    [[CatalyzeHTTPManager httpClient].requestSerializer setValue:[NSString stringWithFormat:@"%@", [Catalyze apiKey]] forHTTPHeaderField:@"X-Api-Key"];
    
    [[CatalyzeHTTPManager httpClient] POST:[NSString stringWithFormat:@"/v2%@",urlString] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (!responseObject) {
            responseObject = @"";
        }
        block((int)[[operation response] statusCode], [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding], nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (CATALYZE_DEBUG) {
            NSLog(@"error - %@ - %@", error, [error localizedDescription]);
        }
        block((int)[[operation response] statusCode], nil, error);
    }];
}

+ (void)doQueryPost:(NSString *)urlString withParams:(NSDictionary *)params block:(CatalyzeHTTPArrayResponseBlock)block {
    if (CATALYZE_DEBUG) {
        NSLog(@"array POST - %@ - %@ - %@",urlString,params, [[NSUserDefaults standardUserDefaults] valueForKey:@"Authorization"]);
    }
    [[CatalyzeHTTPManager httpClient].requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",[[NSUserDefaults standardUserDefaults] valueForKey:@"Authorization"]] forHTTPHeaderField:@"Authorization"];
    [[CatalyzeHTTPManager httpClient].requestSerializer setValue:[NSString stringWithFormat:@"%@", [Catalyze apiKey]] forHTTPHeaderField:@"X-Api-Key"];
    
    [[CatalyzeHTTPManager httpClient] POST:[NSString stringWithFormat:@"/v2%@",urlString] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (!responseObject) {
            responseObject = @[];
        }
        block((int)[[operation response] statusCode], [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil], nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (CATALYZE_DEBUG) {
            NSLog(@"error - %@ - %@", error, [error localizedDescription]);
        }
        block((int)[[operation response] statusCode], nil, error);
    }];
}

+ (void)doPut:(NSString *)urlString withParams:(NSDictionary *)params block:(CatalyzeHTTPResponseBlock)block {
    if (CATALYZE_DEBUG) {
        NSLog(@"PUT - %@ - %@ - %@",urlString, params, [[NSUserDefaults standardUserDefaults] valueForKey:@"Authorization"]);
    }
    [[CatalyzeHTTPManager httpClient].requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",[[NSUserDefaults standardUserDefaults] valueForKey:@"Authorization"]] forHTTPHeaderField:@"Authorization"];
    [[CatalyzeHTTPManager httpClient].requestSerializer setValue:[NSString stringWithFormat:@"%@", [Catalyze apiKey]] forHTTPHeaderField:@"X-Api-Key"];
    
    [[CatalyzeHTTPManager httpClient] PUT:[NSString stringWithFormat:@"/v2%@",urlString] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (!responseObject) {
            responseObject = @"";
        }
        block((int)[[operation response] statusCode], [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding], nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (CATALYZE_DEBUG) {
            NSLog(@"error - %@ - %@", error, [error localizedDescription]);
        }
        block((int)[[operation response] statusCode], nil, error);
    }];
}

+ (void)doDelete:(NSString *)urlString block:(CatalyzeHTTPResponseBlock)block {
    if (CATALYZE_DEBUG) {
        NSLog(@"DELETE - %@ - %@",urlString, [[NSUserDefaults standardUserDefaults] valueForKey:@"Authorization"]);
    }
    [[CatalyzeHTTPManager httpClient].requestSerializer setValue:[NSString stringWithFormat:@"Bearer %@",[[NSUserDefaults standardUserDefaults] valueForKey:@"Authorization"]] forHTTPHeaderField:@"Authorization"];
    [[CatalyzeHTTPManager httpClient].requestSerializer setValue:[NSString stringWithFormat:@"%@", [Catalyze apiKey]] forHTTPHeaderField:@"X-Api-Key"];
    
    [[CatalyzeHTTPManager httpClient] DELETE:[NSString stringWithFormat:@"/v2%@",urlString] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (!responseObject) {
            responseObject = @"";
        }
        block((int)[[operation response] statusCode], [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding], nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (CATALYZE_DEBUG) {
            NSLog(@"error - %@ - %@", error, [error localizedDescription]);
        }
        block((int)[[operation response] statusCode], nil, error);
    }];
}

@end
