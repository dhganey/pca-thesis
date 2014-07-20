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
 CatalyzeObject is the base class of CatalyzeUser.  It is also the base class for custom
 classes on the catalyze.io API.  A CatalyzeObject is initialized with the name of the custom
 class it is associated with and is the container for an Entry in that class.
 
 CatalyzeObject stores all of the fields in its objectDict.  CatalyzeObject will
 only send fields to the catalyze.io API that have been changed.  See dirtyFields.
 This is in place to save on network traffic size and to increase overall performance
 of the SDK.
 
 **NOTE**
 Unless instantiated for use with a Custom Class, a CatalyzeObject should never be used in 
 place of a CatalyzeUser.  If you are dealing with a user, please use CatalyzeUser.
 */

#import <Foundation/Foundation.h>
#import "CatalyzeConstants.h"

@interface CatalyzeObject : NSObject {
    
    /*
     This BOOL provides a quick way for this CatalyzeObject to determine 
     if any of its fields have been changed since the last network call.  If 
     NO, the network call will return immediately.  If YES, only the fields 
     specified in dirtyFields will be sent to the catalyze.io API. 
     */
    BOOL dirty;
    
    /*
     The list of fields that have been changed since the last network request 
     and the fields in this array are the ones that will be sent to the 
     catalyze.io API only.  This array is updated on every network request.
     */
    NSMutableArray *dirtyFields;
}

- (void)resetDirty;

#pragma mark Constructors

/** @name Constructors */

/**
 Initializes a CatalyzeObject with a class name.  This class name is used to lookup
 URL routes.  Valid class names are those which are named after a custom class on the
 catalyze.io API.
 
 @param className a valid class name representing the type of CatalyzeObject being created
 @return a newly created CatalyzeObject with the given class name
 @exception NSInvalidArgumentException will be thrown if className is not a valid class name specified in CatalyzeConstants
 */
+ (CatalyzeObject *)objectWithClassName:(NSString *)className;

/**
 Initializes a CatalyzeObject with a class name.  This class name is used to lookup
 URL routes.  Valid class names are those which are named after a custom class on the
 catalyze.io API. The dictionary may contain any key value pairs, such as predefined 
 fields like first_name, last_name or custom fields.
 
 @param className a valid class name representing the type of CatalyzeObject being created
 @param dictionary key value pairs to be stored with the CatalyzeObject on the next network request.
 @return a newly created CatalyzeObject with the given class name and key value pairs stored from the dictionary
 @exception NSInvalidArgumentException will be thrown if className is not a valid class name specified in CatalyzeConstants
 */
+ (CatalyzeObject *)objectWithClassName:(NSString *)className dictionary:(NSDictionary *)dictionary;

/**
 Constructs a new instance of CatalzeObject with the given class name.  See [CatalyzeObject objectWithClassName:]
 
 @param newClassName a valid class name representing the type of CatalyzeObject being created
 @return the newly created instance of CatalyzeObject
 */
- (id)initWithClassName:(NSString *)newClassName;

#pragma mark -
#pragma mark Properties

/** @name Properties */

/**
 A string representation of the type of CatalyzeObject being created.  Valid
 class names are documented in CatalyzeConstants.  This is for **internal
 use only**. Developers should not change this class name or set this class
 name directly.  This will result in thrown exceptions upon the next network request.
 
 To set the catalyzeClassName, see [CatalyzeObject objectWithClassName:]
 */
@property (readonly) NSString *catalyzeClassName;

/**
 The unique identifier of this CatalyzeObject. 
 
 Often this objectId is nil or an empty string. May be useful for a developer to
 set these as custom unique ids to keep track of their objects.  This key is **NEVER** sent
 to the catalyze.io API.
 */
@property (nonatomic, retain) NSString *objectId;

#pragma mark -
#pragma mark Get and set

/** @name Get and Set */

/**
 This method returns an array of all of the keys set in this CatalyzeObject.  For example
 if the child class of this CatalyzeObject is a CatalyzeUser it may return an array
 containing the keys @[@"firstName",@"lastName", and @"userId"]. Useful
 for iterating through all the elements on this CatalyzeObject and displaying their
 values to the user.
 
 @return the array of keys stored in the objectDict
 */
- (NSArray *)allKeys;

/** 
 @param key the key to look for in objectDict
 @return the object in the objectDict stored with the given key
 */
- (id)objectForKey:(NSString *)key;

/**
 If an object is previously stored with this key, the old object **will** be overwritten
 
 @param object the object to save in objectDict such as @"John"
 @param key the key to store the given object under in the objectDict such as @"firstName"
 */
- (void)setObject:(id)object forKey:(NSString *)key;

/**
 @param key the location of the object to be removed from the objectDict
 */
- (void)removeObjectForKey:(NSString *)key;

/**
 This method functions exactly the same as objectForKey:
 
 @param key the location to look for an object to return in objectDict
 @return the object stored in objectDict with the specified key, or nil if one does not exist
 */
- (id)valueForKey:(NSString *)key;

/**
 This method functions exactly the same as setObject:forKey:
 
 @param value the value to save in objectDict such as @"John"
 @param key the key to store the given value under in the objectDict such as @"firstName"
 */
- (void)setValue:(id)value forKey:(NSString *)key;

/**
 This method functions exactly the same as removeObjectForKey:
 
 @param key the location of the object to be removed from the objectDict
 */
- (void)removeValueForKey:(NSString *)key;

#pragma mark -
#pragma mark Create

/** @name Create */

/**
 Creates a new CatalyzeObject on the catalyze.io API.  If this is the parent class of a
 CatalyzeUser, this method should never be called.  This method creates a new custom class entry
 on the catalyze.io API. This method offers no indication as to when the request is completed.  
 If this is necessary, see createInBackgroundWithBlock:
 */
- (void)createInBackground;

/**
 Creates a new custom class entry on the catalyze.io API.  Upon the request's 
 completion, this CatalyzeObject will have all fields updated and save which 
 can be retrieved by calling objectForKey:. Upon request completion, the 
 CatalyzeBooleanResultBlock is executed whether the request succeeded or failed.
 
 @param block the completion block to be executed upon the request's completion. 
 See CatalyzeBooleanResultBlock to tell whether or not the request was successful.
 */
- (void)createInBackgroundWithBlock:(CatalyzeBooleanResultBlock)block;

/**
 Creates a new custom class entry on the catalyze.io API.  Upon the request's
 completion, this CatalyzeObject will have all fields updated and save which
 can be retrieved by calling objectForKey:. The object sent with the selector 
 will be the error of the request or nil of the request was successful.
 
 **NOTE:**
 the selector is performed on the target on the **Main Thread** see [[NSThread mainThread]](http://bit.ly/11Z9D47)
 
 @param target the target to perform the given selector on the **Main Thread** 
 upon the request's completion
 @param selector the selector to be performed on the given target on the **Main Thread** 
 upon the request's completion
 */
- (void)createInBackgroundWithTarget:(id)target selector:(SEL)selector;

#pragma mark -
#pragma mark Save

/** @name Save */

/**
 Saves this CatalyzeObject in the background.  Only dirty fields are sent to the 
 catalyze.io API and saved.  This method offers no indication as to whether or not 
 the request completed, succeeded, or failed.  If this is neccessary, see 
 saveInBackgroundWithBlock:.
 */
- (void)saveInBackground;

/**
 Saves this CatalyzeObject in the background.  Only dirty fields are sent to the
 catalyze.io API and saved.  Upon completion of the request, the CatalyzeBooleanResultBlock 
 is executed whether the request succeeded or failed.  To tell if the request succeeded 
 or not, see CatalyzeBooleanResultBlock
 
 @param block the completion block to be executed upon the request's completion
 */
- (void)saveInBackgroundWithBlock:(CatalyzeBooleanResultBlock)block;

/**
 Saves this CatalyzeObject in the background.  Only dirty fields are sent to the
 catalyze.io API and saved.  Upon completion of the request, the given selector 
 will be performed on the given target.  The object sent with the selector is the 
 error of the request, or nil if the request was successful.
 
 **NOTE:**
 the selector is performed on the target on the **Main Thread** see [[NSThread mainThread]](http://bit.ly/11Z9D47)
 
 @param target the target to perform the given selector on the **Main Thread** 
 upon the request's completion
 @param selector the selector to be performed on the given target on the **Main Thread** 
 upon the request's completion
 */
- (void)saveInBackgroundWithTarget:(id)target selector:(SEL)selector;

#pragma mark -
#pragma mark Retrieve

/** @name Retrieve */

/**
 Retrieves this CatalyzeObject in the background.  Mostly used for objects that have
 an id but no data.  This method offers no indication as to whether or not the request 
 completed, succeeded, or failed. If this is necessary see retriveInBackgroundWithBlock:.  
 Upon completion, this CatalyzeObject will have its objectDict updated with all of the 
 keys received from the catalyze.io API.
 */
- (void)retrieveInBackground;

/**
 Retrieves this CatalyzeObject in the background.  Mostly used for objects that have
 an id but no data.  Upon completion of the request the CatalyzeObjectResultBlock will 
 be executed whether or not the request completed, succeeded, or failed.  Upon completion, 
 this CatalyzeObject will have its objectDict updated with all of the keys received 
 from the catalyze.io API and this CatalyzeObject is sent back in the completion block as well.
 
 @param block the completion block to be executed upon the request's completion
 */
- (void)retrieveInBackgroundWithBlock:(CatalyzeObjectResultBlock)block;

/**
 Retrieves this CatalyzeObject in the background.  Mostly used for objects that have
 an id but no data.  Upon completion of the request the given selector will be performed 
 on the target whether or not the request completed, succeeded, or failed.  Upon 
 completion, this CatalyzeObject will have its objectDict updated with all of the keys 
 received from the catalyze.io API and this CatalyzeObject is sent back as the object 
 of the selector.
 
 **NOTE:**
 The selector is performed on the target on the **Main Thread** see
 [[NSThread mainThread]](http://bit.ly/11Z9D47)
 
 @param target the target to perform the given selector on the **Main Thread** 
 upon the request's completion
 @param selector the selector to be performed on the given target on the **Main Thread** 
 upon the request's completion
 */
- (void)retrieveInBackgroundWithTarget:(id)target selector:(SEL)selector;

#pragma mark -
#pragma mark Delete

/** @name Delete */

/**
 Deletes this CatalyzeObject in the background from the catalyze.io API.  This 
 method offers no indication as to whether or not the request completed,
 succeeded, or failed. If this is necessary see deleteInBackgroundWithBlock:.  
 Upon completion, this CatalyzeObject will have nothing stored in its objectDict
 and should be discarded and set to nil.
 */
- (void)deleteInBackground;

/**
 Deletes this CatalyzeObject in the background.  Upon completion of the request
 the CatalyzeObjectResultBlock will be executed whether or not the request
 completed, succeeded, or failed.  Upon completion, this CatalyzeObject
 will have nothing stored in its objectDict and should be discarded and set to nil.
 
 @param block the completion block to be executed upon the request's completion
 */
- (void)deleteInBackgroundWithBlock:(CatalyzeBooleanResultBlock)block;

/**
 Deletes this CatalyzeObject in the background.  Upon completion of the request
 the given selector will be performed on the target whether or not the request
 completed, succeeded, or failed.  Upon completion, this CatalyzeObject
 will have nothing stored in its objectDict and should be discarded and set to nil.
 
 **NOTE:**
 The selector is performed on the target on the **Main Thread** see
 [[NSThread mainThread]](http://bit.ly/11Z9D47)
 
 @param target the target to perform the given selector on the **Main Thread**
 upon the request's completion
 @param selector the selector to be performed on the given target on the **Main Thread**
 upon the request's completion
 */
- (void)deleteInBackgroundWithTarget:(id)target selector:(SEL)selector;

@end
