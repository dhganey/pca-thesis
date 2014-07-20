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

#import "CatalyzeObject.h"
#import "AFNetworking.h"
#import "CatalyzeHTTPManager.h"

@interface CatalyzeObject()

@property (strong, nonatomic) NSArray *protected;
@property (strong, nonatomic) NSMutableDictionary *objectDict;

@end

@implementation CatalyzeObject
@synthesize protected = _protected;
@synthesize objectDict = _objectDict;

- (void)resetDirty {
    dirty = NO;
    dirtyFields = [[NSMutableArray alloc] init];
}

#pragma mark Constructors

+ (CatalyzeObject *)objectWithClassName:(NSString *)className {
    return [[CatalyzeObject alloc] initWithClassName:className];
}

+ (CatalyzeObject *)objectWithClassName:(NSString *)className dictionary:(NSDictionary *)dictionary {
    CatalyzeObject *obj = [[CatalyzeObject alloc] initWithClassName:className];
    for (NSString *s in [dictionary allKeys]) {
        [obj setObject:[dictionary objectForKey:s] forKey:s];
    }
    return obj;
}

- (id)initWithClassName:(NSString *)newClassName {
    self = [super init];
    if (self) {
        _protected = [NSArray arrayWithObjects:@"__class_name",@"id",@"username", nil];
        _objectDict = [[NSMutableDictionary alloc] init];
        [self setCatalyzeClassName:newClassName];
        dirtyFields = [[NSMutableArray alloc] init];
    }
    return self;
}

- (id)init {
    self = [self initWithClassName:@"object"];
    return self;
}

#pragma mark -
#pragma mark Properties

- (NSString *)catalyzeClassName {
    return [self objectForKey:@"__class_name"];
}

- (void)setCatalyzeClassName:(NSString *)catalyzeClassName {
    [self setObject:catalyzeClassName forKey:@"__class_name"];;
}

- (NSString *)objectId {
    return [self objectForKey:@"id"];
}

- (void)setObjectId:(NSString *)objectId {
    [self setObject:objectId forKey:@"id"];
}

- (NSArray *)allKeys {
    return [_objectDict allKeys];
}

#pragma mark -
#pragma mark Get and set

- (id)objectForKey:(NSString *)key {
    if (!_objectDict) {
        _objectDict = [[NSMutableDictionary alloc] init];
    }
    if ([_objectDict objectForKey:key] == [NSNull null]) {
        //if we are keeping it as NSNull for the next network call, make the user believe
        //the object was actually removed from the dictionary
        return nil;
    }
    return [_objectDict objectForKey:key];
}

- (void)setObject:(id)object forKey:(NSString *)key {
    if (!_objectDict) {
        _objectDict = [[NSMutableDictionary alloc] init];
    }
    if (object) {
        [dirtyFields addObject:key];
        dirty = YES;
        [_objectDict setObject:object forKey:key];
    }
}

- (void)removeObjectForKey:(NSString *)key {
    [self setObject:[NSNull null] forKey:key];
}

- (id)valueForKey:(NSString *)key {
    return [self objectForKey:key];
}

- (void)setValue:(id)value forKey:(NSString *)key {
    if (value) {
        [self setObject:value forKey:key];
    }
}

- (void)removeValueForKey:(NSString *)key {
    [self removeObjectForKey:key];
}

#pragma mark -
#pragma mark Create

- (void)createInBackground {
    [self createInBackgroundWithBlock:nil];
}

- (void)createInBackgroundWithBlock:(CatalyzeBooleanResultBlock)block {
    NSLog(@"calling POST for creation");
    NSDictionary *sendDict = [self prepSendDict];
    if (sendDict.count > 0) {
        [CatalyzeHTTPManager doPost:[self lookupURL:YES] withParams:sendDict block:^(int status, NSString *response, NSError *error) {
            NSLog(@"created");
            if (!error) {
                NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
                dirty = NO;
                for (NSString *s in [self allKeys]) {
                    [self removeObjectForKey:s];
                }
                for (NSString *s in [responseDict allKeys]) {
                    [self setObject:[responseDict objectForKey:s] forKey:s];
                }
                [dirtyFields removeAllObjects];
            }
            if (block) {
                block(error == nil, status, error);
            }
        }];
    } else {
        if (block) {
            block(YES, 200, nil);
        }
    }
}

- (void)createInBackgroundWithTarget:(id)target selector:(SEL)selector {
    [self createInBackgroundWithBlock:^(BOOL succeeded, int status, NSError *error) {
        [target performSelector:selector onThread:[NSThread mainThread] withObject:error waitUntilDone:NO];
    }];
}

#pragma mark -
#pragma mark Save

- (void)saveInBackground {
    [self saveInBackgroundWithBlock:nil];
}

- (void)saveInBackgroundWithBlock:(CatalyzeBooleanResultBlock)block {
    NSDictionary *sendDict = [self prepSendDict];
    if (sendDict.count > 0) {
        [CatalyzeHTTPManager doPut:[self lookupURL:NO] withParams:sendDict block:^(int status, NSString *response, NSError *error) {
            if (!error) {
                NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
                dirty = NO;
                for (NSString *s in [responseDict allKeys]) {
                    [self setObject:[responseDict objectForKey:s] forKey:s];
                }
                [dirtyFields removeAllObjects];
            }
            if (block) {
                block(error == nil, status, error);
            }
        }];
    } else {
        if (block) {
            block(YES, 200, nil);
        }
    }
}

- (void)saveInBackgroundWithTarget:(id)target selector:(SEL)selector {
    [self saveInBackgroundWithBlock:^(BOOL succeeded, int status, NSError *error) {
        [target performSelector:selector onThread:[NSThread mainThread] withObject:error waitUntilDone:NO];
    }];
}

#pragma mark -
#pragma mark Retrieve

- (void)retrieveInBackground {
    [self retrieveInBackgroundWithBlock:nil];
}

- (void)retrieveInBackgroundWithBlock:(CatalyzeObjectResultBlock)block {
    NSString *url = [self lookupURL:NO];
    [CatalyzeHTTPManager doGet:url block:^(int status, NSString *response, NSError *error) {
        if (!error) {
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
            NSString *cname = [self catalyzeClassName];
            for (NSString *s in [self allKeys]) {
                [self removeObjectForKey:s];
            }
            [self setCatalyzeClassName:cname];
            for (NSString *s in [responseDict allKeys]) {
                [self setObject:[responseDict objectForKey:s] forKey:s];
            }
            dirty = NO;
            [dirtyFields removeAllObjects];
        }
        if (block) {
            block(self, error);
        }
    }];
}

- (void)retrieveInBackgroundWithTarget:(id)target selector:(SEL)selector {
    [self retrieveInBackgroundWithBlock:^(CatalyzeObject *object, NSError *error) {
        [target performSelector:selector onThread:[NSThread mainThread] withObject:error waitUntilDone:NO];
    }];
}

#pragma mark -
#pragma mark Delete

- (void)deleteInBackground  {
    [self deleteInBackgroundWithBlock:nil];
}

- (void)deleteInBackgroundWithBlock:(CatalyzeBooleanResultBlock)block {
    [CatalyzeHTTPManager doDelete:[self lookupURL:NO] block:^(int status, NSString *response, NSError *error) {
        if (!error) {
            dirty = NO;
            for (NSString *s in [self allKeys]) {
                [self removeObjectForKey:s];
            }
            
            [dirtyFields removeAllObjects];
        }
        if (block) {
            block(error == nil, status, error);
        }
    }];
}

- (void)deleteInBackgroundWithTarget:(id)target selector:(SEL)selector {
    [self deleteInBackgroundWithBlock:^(BOOL succeeded, int status, NSError *error) {
        [target performSelector:selector onThread:[NSThread mainThread] withObject:error waitUntilDone:NO];
    }];
}

#pragma mark - 
#pragma mark Helpers

- (NSString *)lookupURL:(BOOL)post {
    NSString *retval;
    if ([self.catalyzeClassName isEqualToString:@"reference"]) {
        retval = [NSString stringWithFormat:@"/classes/%@/%@/ref/%@",[self valueForKey:@"__reference_parent_class"],[self valueForKey:@"__reference_parent_id"],[self valueForKey:@"__reference_name"]];
    } else {
        retval = [NSString stringWithFormat:@"/classes/%@/entry",[self catalyzeClassName]];
        if (!post) {
            retval = [NSString stringWithFormat:@"%@/%@",retval,[self objectForKey:@"id"]];
        }
    }
    return retval;
}

- (NSDictionary *)prepSendDict {
    NSMutableDictionary *sendDict = [NSMutableDictionary dictionaryWithDictionary:_objectDict];
    for (NSString *s in [sendDict allKeys]) {
        if ([_protected containsObject:s]) {
            [sendDict removeObjectForKey:s];
        }
        if (![dirtyFields containsObject:s]) {
            [sendDict removeObjectForKey:s];
        }
    }
    NSMutableDictionary *outerSendDict = [NSMutableDictionary dictionary];
    [outerSendDict setObject:sendDict forKey:@"content"];
    return outerSendDict;
}

@end
