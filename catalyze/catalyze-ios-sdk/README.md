Getting Started
===============

Installation
------------
The preferred method of installation is through [cocoapods][2]. Simply add ```pod 'catalyze-ios-sdk', '~> 2.3'``` to your Podfile, run ```pod install``` and you will be ready to start developing. Optionally if you do not use cocoapods or have an existing project that has not integrated cocoapods, you can clone this repository to your computer. Simply copy the iOS SDK folder anywhere into your project directory by clicking on the File menu and then "Add Files to 'yourProjectName'...". Navigate to the directory of the iOS SDK and click Add. You're now ready to use the iOS SDK in your application.

License
--------

    Copyright 2013 catalyze.io, Inc.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.

Using the catalyze.io iOS SDK
=============================

The first thing you must do is set-up an Application on the [dashboard][1].  You will need the following information about your Application: api key and application id. Please be aware that there are three components to an api key: the type, identifier, and id. A complete api key looks like ```ios io.catalyze.sdk 426881c0-f39b-4d52-82de-be509d5450f6``` or more generally ```<type> <identifier> <id>```.  After you have this information, you MUST call 

    [Catalyze setApiKey:@"{fullApiKey}" applicationId:@"{appId}"];

in `application:didFinishLaunchingWithOptions:`.  Note: all methods that require a network request are run asynchronously. 
Don't forget to `#import "Catalyze.h"` whenever you need to use the iOS SDK.

Objects
-------
A CatalyzeObject represents an Object that can be stored on the catalyze.io API in a pre defined custom class.  These custom classes must be created in the dashboard before being used or referenced within an app or the API will return a 4XX status code. 

Creating Objects
----------------
To use a CatalyzeObject you must initialize it with the name of the custom class you created on the dashboard:

    CatalyzeObject *myObject = [CatalyzeObject objectWithClassName:@"{customClassName}"];

Now that you have a CatalyzeObject you can save values, retrieve values, and create the new Entry on the catalyze.io API.

    [myObject setObject:@"blue" forKey:@"favorite_color"];
    NSString *myColor = [myObject objectForKey:@"favorite_color"];
    [myObject createInBackground];

You can also initialize an object with a its unique identifier.  This is useful when the id is known, but you have to fetch the object from the API because all of the other data for that Entry is not stored locally.  To do this simply

    CatalyzeObject *myNewObject = [CatalyzeObject objectWithClassName:@"{customClassName}" dictionary:[NSDictionary dictionaryWithObjectsAndKeys:@"4eab4-acde-bbab-34221",@"id", nil]];
    [myNewObject retrieveInBackgroundWithBlock:^(CatalyzeObject *object, NSError *error) {
            //take action here
            //the object is passed back in the block, but its not needed since you have a reference to myNewObject
    }];
    
Saving Your Data
----------------
To save changes to any data you have to the catalyze.io API you have 3 options.  Save the data asynchronously without a callback, save the data asynchronously with a callback, or save the data asynchronously and perform a given selector on the main thread once completed.  They are performed as follows:

Asynchronous without callback:

    [catalyzeObjectInstance saveInBackground];

Asynchronous with callback:

    [catalyzeObjectInstance saveInBackgroundWithBlock:^(BOOL succeeded, int status, NSError *error) {
            //perform actions here
    }];

Asynchronous and perform a selector on the main thread:

    [catalyzeObjectInstance saveInBackgroundWithTarget:self selector:@selector(takeAction:)];
    
Referenced Objects
------------------
On the catalyze.io API you can also have references to a custom class inside another custom class.  Let's say you have a custom class called "MovieStar" and another called "Address".  When you create "MovieStar" in the dashboard, you can specify a column as being a reference.  References are of type CatalyzeReference in the iOS SDK.

CatalyzeUser
------------
Before you can perform any action on the Catalyze API, you need to authenticate. This is done by logging in or signing up through CatalyzeUser. A CatalyzeUser represents any entity logging in to an application. Specific data is tied to this user and any CatalyzeObjects created while the user is logged in are tied to their account.

Similarly to CatalyzeObjects, you can save any information you want to a user but it is called an 'extra'. This is because there are a number of predefined data elements on a CatalyzeUser listed below.  So instead of using the methods

    setObject:forKey:
    removeObjectForKey:
    objectForKey:

You will use these for extras on a CatalyzeUser

    setExtra:forKey:
    removeExtraForKey:
    extraForKey:

The full list of supported fields on a CatalyzeUser are

* usersId
* active
* createdAt
* updatedAt
* username
* email*
* name*
* dob
* age
* phoneNumber*
* addresses**
* gender
* maritalStatus
* religion
* race
* ethnicity
* guardians**
* confCode
* languages**
* socialIds**
* mrns**
* healthPlans**
* avatar
* ssn
* profilePhoto
* extras

All of these fields have getters and setters on a CatalyzeUser object.  All other data must be stored as an Extra.

Some fields are not primitive data types. Those marked with a ```*``` above are nested objects. Those marked with a ```**``` are arrays of nested objects. Those objects and their corresponding properties can be viewed in the respective classes. 

Log in
------
Log in by calling

    [CatalyzeUser logInWithUsernameInBackground:username password:password block:^(int status, NSString *response, NSError *error) {
            if (!error) {
                NSLog(@"successful login");
            } else {
                [[[UIAlertView alloc] initWithTitle:@"Login Error" message:@"Wrong username / password" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
            }
        }];

Logout
------
To logout you call

    [[CatalyzeUser currentUser] logout];

This will clear all locally stored information about the User including session information and tell the API to destroy your session token.

Updating/Saving your User
-------------------------
Now that we are logged into an Application lets save some supported fields to our User. If we wanted to update our first name, last name, age, and an extra field:

    [[[CatalyzeUser currentUser] name] setFirstName:@"John"];
    [[[CatalyzeUser currentUser] name] setLastName:@"Smith"];
    [[CatalyzeUser currentUser] setAge:[NSNumber numberWithInt:32]];
    [[CatalyzeUser currentUser] setExtra:[NSNumber numberWithBool:YES] forKey:@”on_medication”];
    [[CatalyzeUser currentUser] saveInBackground];

Note: All of the same methods for saving a CatalyzeObject apply to saving a CatalyzeUser as well.

Health Vocabularies
-------------------
The catalyze.io API allows you to look up medications or codes in over 100 different vocabularies.  The list of vocabularies can be found here http://1.usa.gov/apKB6w.  To use this in the SDK, a `HealthLookaheadUITextFieldDelegate` class has been provided.  Rather than having a User type freely a medication name, you can set the text field’s delegate to an instance of `HealthLookaheadUITextFieldDelegate`.  As the User types, the delegate will perform a regex search on the specified vocabulary with what is currently typed in the text field.  All you have to do is conform to the `HealthLookaheadCompletionDelegate` protocol and implement two methods.  These two methods are 

    textFieldDidReturnWithText: 
    showSuggestions:  

The first is performed after the User hits the Return key on their keyboard.  The text currently in the text field is sent back to the developer through this method.  You don’t need to worry about dismissing the keyboard as that is done in the `HealthLookaheadUITextFieldDelegate` class.  The latter of the two methods is used when an API request completes.  As the User types, an API request is made, when that comes back, the JSON is transformed into an array of strings.  These strings are the description of any medication relating to what the User has typed.  It is up to the developer on how to display these suggested medication names.

    HealthLookaheadUITextFieldDelegate *healthDelegate = [[HealthLookaheadUITextFieldDelegate alloc] initWithVocabulary:@”ICD9CM”]; // ICD9CM is the default vocabulary
    UITextField *textField = [[UITextField alloc] init];
    [textField setDelegate:healthDelegate];
    // add the text field to the screen

Don't forget to implement the two methods specified in the HealthCompletionDelegate protocol

    - (void)showSuggestions:(NSArray *)suggestions {
        NSLog(@"show these suggestions: %@",suggestions);
    }
    
    - (void)textFieldDidReturnWithText:(NSString *)text {
        NSLog(@”User has typed: %@”,text);
    }

Querying
--------
A CatalyzeQuery is how you manage searching a custom class.  If a custom class HAS NOT been marked as PHI you can query any Entry in the class and it will be returned to you.  If a class HAS been marked as PHI, you may only query your own Entries.  You don’t need to worry about doing this however, as the API takes care of it for you.  There are four parts to a CatalyzeQuery.

The first two are "pageSize" and "pageNumber".  "pageSize" is the amount of Entries you want to receive back from the API.  Note that you will not always receive "pageSize" number of Entries in return.  The actual number depends on the "pageNumber" requested and the amount of Entries in the custom class.  "pageNumber" is used to specify how many Entries should be skipped.  For example, say there are 50 Entries in a custom class numbered 0 to 49.  "pageNumber" of 1 and a "pageSize" of 20 will return Entries 0 through 19.  A "pageNumber" of 2 and a "pageSize" of 20 will return Entries 20 through 39.

The second two are "queryField" and "queryValue".  "queryField" is the data column of the custom class that is to be searched and "queryValue" is the actual value that is to be looked for in the "queryField" column.

To use CatalyzeQuery you must initialize the object with the name of the custom class that is being queried.

    CatalyzeQuery *myQuery = [CatalyzeQuery queryWithClassName:@”{myCustomClass}”];
    [query setQueryValue:@”53202”];
    [query setQueryField:@"zip_code"];
    [query setPageNumber:1];
    [query setPageSize:100];
    [query retrieveInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (error) {
                NSLog(@"query failed - %@",error);
            } else {
                NSLog(@"query completed successfully - %@",objects);
            }
    }];

If you want to query your own Entries, you simply set the "queryField" to be "parentId" and the "queryValue" to the User’s id.

    CatalyzeQuery *myQuery = [CatalyzeQuery queryWithClassName:@”{myCustomClass}”];
    [query setQueryValue:[[CatalyzeUser currentUser] usersId]];
    [query setQueryField:@"parentId"];
    [query setPageNumber:1];
    [query setPageSize:100];
    [query retrieveInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (error) {
                NSLog(@"query failed - %@",error);
            } else {
                NSLog(@"query completed successfully - %@",objects);
            }
    }];

[1]: https://dashboard.catalyze.io
[2]: http://cocoapods.org/
