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

#import "Language.h"

#define kEncodeKeyLanguage @"language_language"
#define kEncodeKeyLanguageMode @"language_language_mode"

@implementation Language
@synthesize language = _language;
@synthesize languageMode = _languageMode;

- (id)init {
    self = [super init];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:_language forKey:kEncodeKeyLanguage];
    [aCoder encodeObject:_languageMode forKey:kEncodeKeyLanguageMode];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [self init];
    if (self) {;
        [self setLanguage:[aDecoder decodeObjectForKey:kEncodeKeyLanguage]];
        [self setLanguageMode:[aDecoder decodeObjectForKey:kEncodeKeyLanguageMode]];
    }
    return self;
}

@end
