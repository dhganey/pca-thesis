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

#import "CatalyzeQuery.h"

@implementation CatalyzeQuery
@synthesize catalyzeClassName = _catalyzeClassName;
@synthesize pageNumber = _pageNumber;
@synthesize pageSize = _pageSize;
@synthesize queryValue = _queryValue;
@synthesize queryField = _queryField;

+ (CatalyzeQuery *)queryWithClassName:(NSString *)className {
    return [[CatalyzeQuery alloc] initWithClassName:className];
}

- (id)initWithClassName:(NSString *)newClassName {
    self = [super init];
    if (self) {
        _catalyzeClassName = newClassName;
    }
    return self;
}

- (id)init {
    self = [self initWithClassName:@"object"];
    return self;
}

- (void)setValue:(id)value forKey:(NSString *)key {
    @try {
        [super setValue:value forKey:key];
    } @catch (NSException *e) {}
}

#pragma mark -
#pragma mark Retrieve

- (void)retrieveAllEntriesInBackgroundWithSuccess:(CatalyzeArraySuccessBlock)success failure:(CatalyzeFailureBlock)failure; {
    [CatalyzeHTTPManager doGet:[NSString stringWithFormat:@"/classes/%@/query?pageSize=%i&pageNumber=%i%@%@",[CatalyzeHTTPManager percentEncode:[self catalyzeClassName]], _pageSize, _pageNumber, [self constructQueryFieldParam], [self constructQueryValueParam]] success:^(id result) {
        if (success) {
            NSArray *array = (NSArray *)result;
            NSMutableArray *entries = [NSMutableArray array];
            for (id dict in array) {
                CatalyzeEntry *entry = [CatalyzeEntry entryWithClassName:_catalyzeClassName];
                [entry setValuesForKeysWithDictionary:dict];
                entry.content = [NSMutableDictionary dictionaryWithDictionary:entry.content]; // to keep mutability
                [entries addObject:entry];
            }
            success(entries);
        }
    } failure:failure];
}

- (void)retrieveAllEntriesInBackgroundWithTarget:(id)target selector:(SEL)selector {
    [self retrieveAllEntriesInBackgroundWithSuccess:^(NSArray *result) {
        [target performSelector:selector onThread:[NSThread mainThread] withObject:result waitUntilDone:NO];
    } failure:^(NSDictionary *result, int status, NSError *error) {
        [target performSelector:selector onThread:[NSThread mainThread] withObject:result waitUntilDone:NO];
    }];
}

- (void)retrieveInBackgroundWithSuccess:(CatalyzeArraySuccessBlock)success failure:(CatalyzeFailureBlock)failure; {
    [self retrieveInBackgroundForUsersId:[[CatalyzeUser currentUser] usersId] success:success failure:failure];
}

- (void)retrieveInBackgroundWithTarget:(id)target selector:(SEL)selector {
    [self retrieveInBackgroundWithSuccess:^(NSArray *result) {
        [target performSelector:selector onThread:[NSThread mainThread] withObject:result waitUntilDone:NO];
    } failure:^(NSDictionary *result, int status, NSError *error) {
        [target performSelector:selector onThread:[NSThread mainThread] withObject:result waitUntilDone:NO];
    }];
}

- (void)retrieveInBackgroundForUsersId:(NSString *)usersId success:(CatalyzeArraySuccessBlock)success failure:(CatalyzeFailureBlock)failure; {
    [CatalyzeHTTPManager doGet:[NSString stringWithFormat:@"/classes/%@/query/%@?pageSize=%i&pageNumber=%i%@%@",[CatalyzeHTTPManager percentEncode:[self catalyzeClassName]], usersId, _pageSize, _pageNumber, [self constructQueryFieldParam], [self constructQueryValueParam]] success:^(id result) {
        if (success) {
            NSArray *array = (NSArray *)result;
            NSMutableArray *entries = [NSMutableArray array];
            for (id dict in array) {
                CatalyzeEntry *entry = [CatalyzeEntry entryWithClassName:_catalyzeClassName];
                [entry setValuesForKeysWithDictionary:dict];
                entry.content = [NSMutableDictionary dictionaryWithDictionary:entry.content]; // to keep mutability
                [entries addObject:entry];
            }
            success(entries);
        }
    } failure:failure];
}

- (void)retrieveInBackgroundForUsersId:(NSString *)usersId target:(id)target selector:(SEL)selector {
    [self retrieveInBackgroundForUsersId:usersId success:^(NSArray *result) {
        [target performSelector:selector onThread:[NSThread mainThread] withObject:result waitUntilDone:NO];
    } failure:^(NSDictionary *result, int status, NSError *error) {
        [target performSelector:selector onThread:[NSThread mainThread] withObject:result waitUntilDone:NO];
    }];
}

#pragma mark -
#pragma mark Helpers

- (NSString *)constructQueryFieldParam {
    NSString *queryFieldParam = @"";
    if (_queryField) {
        if (![_queryField isKindOfClass:[NSString class]] || ([_queryField isKindOfClass:[NSString class]] && ![_queryField isEqualToString:@""])) {
            queryFieldParam = [NSString stringWithFormat:@"&field=%@", [CatalyzeHTTPManager percentEncode:_queryField]];
        }
    }
    return queryFieldParam;
}

- (NSString *)constructQueryValueParam {
    NSString *queryValueParam = @"";
    if (_queryValue) {
        if (![_queryValue isKindOfClass:[NSString class]] || ([_queryValue isKindOfClass:[NSString class]] && ![_queryValue isEqualToString:@""])) {
            queryValueParam = [NSString stringWithFormat:@"&searchBy=%@", [CatalyzeHTTPManager percentEncode:_queryValue]];
        }
    }
    return queryValueParam;
}

@end
