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

#import "HealthLookaheadUITextFieldDelegate.h"
#import "CatalyzeHTTPManager.h"

@implementation HealthLookaheadUITextFieldDelegate

- (id)init {
    self = [self initWithVocabulary:@"ICD9CM"];
    return self;
}

- (id)initWithVocabulary:(NSString *)vocab {
    self = [super init];
    if (self) {
        [self setVocabulary:vocab];
    }
    return self;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (_completionDelegate) {
        [CatalyzeHTTPManager doGet:[NSString stringWithFormat:@"/vocab/phrase/%@/%@",[self vocabulary],[self encodeToPercentEscapeString:[textField.text stringByReplacingCharactersInRange:range withString:string] ]] block:^(int status, NSString *response, NSError *error) {
            NSArray *responseArray = [NSJSONSerialization JSONObjectWithData:[response dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
            if (status == 200) {
                NSMutableArray *suggestions = [NSMutableArray array];
                for (NSDictionary *d in responseArray) {
                    [suggestions addObject:[d objectForKey:@"description"]];
                }
                [_completionDelegate showSuggestions:suggestions];
            } else {
                NSLog(@"failure - %i - %@",status, error);
            }
        }];
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    if (_completionDelegate) {
        [_completionDelegate textFieldDidReturnWithText:textField.text];
    }
    textField.text = @"";
    return YES;
}

- (NSString *) encodeToPercentEscapeString:(NSString *)string {
    return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef) string, NULL, (CFStringRef) @"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8));
}

@end
