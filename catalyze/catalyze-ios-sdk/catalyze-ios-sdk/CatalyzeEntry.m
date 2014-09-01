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

#import "CatalyzeEntry.h"
#import "AFNetworking.h"
#import "CatalyzeHTTPManager.h"

@interface CatalyzeEntry()

@end

@implementation CatalyzeEntry

#pragma mark Constructors

+ (CatalyzeEntry *)entryWithClassName:(NSString *)className {
    return [[CatalyzeEntry alloc] initWithClassName:className];
}

+ (CatalyzeEntry *)entryWithClassName:(NSString *)className dictionary:(NSDictionary *)dictionary {
    CatalyzeEntry *obj = [[CatalyzeEntry alloc] initWithClassName:className];
    for (NSString *s in [dictionary allKeys]) {
        [[obj content] setObject:[dictionary objectForKey:s] forKey:s];
    }
    return obj;
}

- (id)initWithClassName:(NSString *)newClassName {
    self = [super init];
    if (self) {
        _content = [[NSMutableDictionary alloc] init];
        self.className = newClassName;
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
#pragma mark Create

- (void)createInBackground {
    [self createInBackgroundWithSuccess:nil failure:nil];
}

- (void)createInBackgroundWithSuccess:(CatalyzeSuccessBlock)success failure:(CatalyzeFailureBlock)failure {
    [CatalyzeHTTPManager doPost:[self lookupURL:YES] withParams:[self prepSendDict] success:^(id result) {
        NSDictionary *responseDict = (NSDictionary *)result;
        [self setValuesForKeysWithDictionary:responseDict];
        self.content = [NSMutableDictionary dictionaryWithDictionary:self.content]; // to keep mutability
        if (success) {
            success(self);
        }
    } failure:failure];
}

- (void)createInBackgroundWithTarget:(id)target selector:(SEL)selector {
    [self createInBackgroundWithSuccess:^(id result) {
        [target performSelector:selector onThread:[NSThread mainThread] withObject:self waitUntilDone:NO];
    } failure:^(NSDictionary *result, int status, NSError *error) {
        [target performSelector:selector onThread:[NSThread mainThread] withObject:result waitUntilDone:NO];
    }];
}

- (void)createInBackgroundForUserWithUsersId:(NSString *)usersId {
    [self createInBackgroundForUserWithUsersId:usersId success:nil failure:nil];
}

- (void)createInBackgroundForUserWithUsersId:(NSString *)usersId success:(CatalyzeSuccessBlock)success failure:(CatalyzeFailureBlock)failure {
    [CatalyzeHTTPManager doPost:[NSString stringWithFormat:@"/classes/%@/entry/%@",[self className],usersId] withParams:[self prepSendDict] success:^(id result) {
        NSDictionary *responseDict = (NSDictionary *)result;
        [self setValuesForKeysWithDictionary:responseDict];
        self.content = [NSMutableDictionary dictionaryWithDictionary:self.content]; // to keep mutability
        if (success) {
            success(self);
        }
    } failure:failure];
}

- (void)createInBackgroundForUserWithUsersId:(NSString *)usersId target:(id)target selector:(SEL)selector {
    [self createInBackgroundForUserWithUsersId:usersId success:^(id result) {
        [target performSelector:selector onThread:[NSThread mainThread] withObject:self waitUntilDone:NO];
    } failure:^(NSDictionary *result, int status, NSError *error) {
        [target performSelector:selector onThread:[NSThread mainThread] withObject:result waitUntilDone:NO];
    }];
}

#pragma mark -
#pragma mark Save

- (void)saveInBackground {
    [self saveInBackgroundWithSuccess:nil failure:nil];
}

- (void)saveInBackgroundWithSuccess:(CatalyzeSuccessBlock)success failure:(CatalyzeFailureBlock)failure; {
    [CatalyzeHTTPManager doPut:[self lookupURL:NO] withParams:[self content] success:^(id result) {
        NSDictionary *responseDict = (NSDictionary *)result;
        [self setValuesForKeysWithDictionary:responseDict];
        self.content = [NSMutableDictionary dictionaryWithDictionary:self.content]; // to keep mutability
        if (success) {
            success(self);
        }
    } failure:failure];
}

- (void)saveInBackgroundWithTarget:(id)target selector:(SEL)selector {
    [self saveInBackgroundWithSuccess:^(id result) {
        [target performSelector:selector onThread:[NSThread mainThread] withObject:self waitUntilDone:NO];
    } failure:^(NSDictionary *result, int status, NSError *error) {
        [target performSelector:selector onThread:[NSThread mainThread] withObject:result waitUntilDone:NO];
    }];
}

#pragma mark -
#pragma mark Retrieve

- (void)retrieveInBackground {
    [self retrieveInBackgroundWithSuccess:nil failure:nil];
}

- (void)retrieveInBackgroundWithSuccess:(CatalyzeSuccessBlock)success failure:(CatalyzeFailureBlock)failure; {
    NSString *url = [self lookupURL:NO];
    [CatalyzeHTTPManager doGet:url success:^(id result) {
        NSDictionary *responseDict = (NSDictionary *)result;
        [self setValuesForKeysWithDictionary:responseDict];
        self.content = [NSMutableDictionary dictionaryWithDictionary:self.content]; // to keep mutability
        if (success) {
            success(self);
        }
    } failure:failure];
}

- (void)retrieveInBackgroundWithTarget:(id)target selector:(SEL)selector {
    [self retrieveInBackgroundWithSuccess:^(id result) {
        [target performSelector:selector onThread:[NSThread mainThread] withObject:self waitUntilDone:NO];
    } failure:^(NSDictionary *result, int status, NSError *error) {
        [target performSelector:selector onThread:[NSThread mainThread] withObject:result waitUntilDone:NO];
    }];
}

#pragma mark -
#pragma mark Delete

- (void)deleteInBackground  {
    [self deleteInBackgroundWithSuccess:nil failure:nil];
}

- (void)deleteInBackgroundWithSuccess:(CatalyzeSuccessBlock)success failure:(CatalyzeFailureBlock)failure; {
    [CatalyzeHTTPManager doDelete:[self lookupURL:NO] success:^(id result) {
        _className = nil;
        _entryId = nil;
        _authorId = nil;
        _parentId = nil;
        _content = nil;
        _updatedAt = nil;
        _createdAt = nil;
        if (success) {
            success(self);
        }
    } failure:failure];
}

- (void)deleteInBackgroundWithTarget:(id)target selector:(SEL)selector {
    [self deleteInBackgroundWithSuccess:^(id result) {
        [target performSelector:selector onThread:[NSThread mainThread] withObject:self waitUntilDone:NO];
    } failure:^(NSDictionary *result, int status, NSError *error) {
        [target performSelector:selector onThread:[NSThread mainThread] withObject:result waitUntilDone:NO];
    }];
}

#pragma mark - 
#pragma mark Helpers

- (NSString *)lookupURL:(BOOL)post {
    NSString *retval;
    if ([_className isEqualToString:@"reference"]) {
        retval = [NSString stringWithFormat:@"/classes/%@/%@/ref/%@",[CatalyzeHTTPManager percentEncode:[self valueForKey:@"__reference_parent_class"]],[CatalyzeHTTPManager percentEncode:[self valueForKey:@"__reference_parent_id"]],[CatalyzeHTTPManager percentEncode:[self valueForKey:@"__reference_name"]]];
    } else {
        retval = [NSString stringWithFormat:@"/classes/%@/entry",[CatalyzeHTTPManager percentEncode:_className]];
        if (!post) {
            retval = [NSString stringWithFormat:@"%@/%@",retval,[CatalyzeHTTPManager percentEncode:_entryId]];
        }
    }
    return retval;
}

- (NSDictionary *)prepSendDict {
    NSMutableDictionary *sendDict = [NSMutableDictionary dictionary];
    [sendDict setObject:_content forKey:@"content"];
    return sendDict;
}

@end
