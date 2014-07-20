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

#import <UIKit/UIKit.h>

/**
 The protocol a class must conform to in order to receive callbacks from the 
 HealthLookaheadUITextFieldDelegate's network requests.
 */
@protocol HealthLookaheadCompletionDelegate <NSObject>

/**
 Performed after the User hits the Return key on their keyboard.  The text currently in the text 
 field is sent back and the keyboard is closed automatically.
 
 @param text the text that is in the text field
 */
- (void)textFieldDidReturnWithText:(NSString *)text;

/**
 As the User types, an API request is made, when that comes back, the JSON is transformed into 
 an array of strings.  These strings are the description of any medication relating to what 
 the User has typed.  It is up to the developer on how to display these suggested medication names.
 
 @param suggestions the array of medications as strings
 */
- (void)showSuggestions:(NSArray *)suggestions;

@end

/**
 The catalyze.io API allows you to look up medications or codes in over 100 different vocabularies.
 The list of vocabularies can be found here http://1.usa.gov/apKB6w.  To use this in the iOS SDK,
 this HealthLookaheadUITextFieldDelegate class has been provided.  Rather than having a User type
 freely a medication name, you can set the text field’s delegate to an instance of
 HealthLookaheadUITextFieldDelegate.  As the User types, the delegate will perform a regex search
 on the specified vocabulary with what is currently typed in the text field.
 */

@interface HealthLookaheadUITextFieldDelegate : NSObject<UITextFieldDelegate>

/**
 The class conforming to the HealthLookaheadCompletionDelegate protocol and will receive 
 callbacks when a network request has been made.
 */
@property (strong, nonatomic) id<HealthLookaheadCompletionDelegate> completionDelegate;

/**
 The vocabulary to search in.  This must be a valid vocabulary. The list of vocabularies can be 
 found here http://1.usa.gov/apKB6w.
 */
@property (strong, nonatomic) NSString *vocabulary;

/**
 Initializes a new HealthLookaheadUITextFieldDelegate and sets the vocabulary to given string.
 
 @param vocab the vocabulary to search
 */
- (id)initWithVocabulary:(NSString *)vocab;

@end
