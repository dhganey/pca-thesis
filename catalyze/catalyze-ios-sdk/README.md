Getting Started
===============

Migrating to version 3.X?
-------------------------
If you are upgrading from version 2.X to version 3.X checkout out the [migration guide](https://github.com/catalyzeio/catalyze-ios-sdk/wiki/ios-3.0-migration-guide) to learn about the significant changes and how you can quickly get up to speed! Or if you're just getting started for the first time keep reading!

Installation
------------
The preferred method of installation is through [cocoapods](http://cocoapods.org/). Simply add ```pod 'catalyze-ios-sdk', '~> 3.0'``` to your Podfile, run ```pod install``` and you will be ready to start developing. Optionally if you do not use cocoapods or have an existing project that has not integrated cocoapods, you can clone this repository to your computer. Simply copy the iOS SDK folder anywhere into your project directory by clicking on the File menu and then "Add Files to 'yourProjectName'...". Navigate to the directory of the iOS SDK and click Add. You're now ready to use the iOS SDK in your application.

Catalyze Documentation
----------------------
If you're looking for some more documentation on the Catalyze platform, be sure to check out our [resources page](https://resources.catalyze.io/).

Using the catalyze.io iOS SDK
=============================

The first thing you must do is set-up an Application on the [dashboard](https://dashboard.catalyze.io).  You will need the following information about your Application: api key and application id. Please be aware that there are three components to an api key: the type, identifier, and id. A complete api key looks like ```ios io.catalyze.sdk 426881c0-f39b-4d52-82de-be509d5450f6``` or more generally ```<type> <identifier> <id>```.  After you have this information, you MUST call 

    [Catalyze setApiKey:@"{fullApiKey}" applicationId:@"{appId}"];

in `application:didFinishLaunchingWithOptions:`.  Note: all methods that require a network request are run asynchronously. 
Don't forget to `#import "Catalyze.h"` whenever you need to use the iOS SDK.

Editing the Base URL
--------------------
In order to make the SDK more portable, you can change the base URL that it uses to communicate with the API. This way if you have a requirement to use a different deployment thatn the public APIs you can still use the iOS SDK. Simply call

	[Catalyze setApiKey:@"{fullApiKey}" applicationId:@"{appId}" baseUrl:@"{https://myBaseUrl}"];
	
Please note, DO NOT include the API version path (`/v2`) in the base URL. A sample base URL looks like this `https://apiv2.catalyze.io`. This can only be done once and cannot be changed at runtime. 

Logging
-------
For debugging purposes, you can enable logging of all requests made through the Catalyze SDK. Call `[Catalyze setLoggingLevel:kLoggingLevelDebug];` in your `application:didFinishLaunchingWithOptions:` method. For different levels of logging and their descriptions please see `CatalyzeConstants.h`.

Completion Blocks
=================
The iOS SDK makes heavy use of blocks for all network requests. Since version 3.0.0 every request requires a success and a failure block. 

Success Blocks
--------------
All objects conforming to the `CatalyzeObjectProtocol` (CatalyzeEntry and CatalyzeUser) require a success block of type `CatalyzeSuccessBlock`. The `CatalyzeSuccessBlock` has a single parameter passed back of type `id`. This is of type `id` because its type changes based on the context you are in. If you are making a request with the CatalyzeEntry class it is of type CatalyzeEntry and similarly it is of type CatalyzeUser when making requests with the CatalyzeUser class. This makes it easy to accomplish whatever you need. 

Although the object is passed back in the success block it is not necessary to use it. You should still have a reference to the original object that is making the request. All values are updated on that object so it is never required to use the value given in the success block. It is simply there for convenience. 

Failure Blocks
--------------
There is a single failure block for the entire SDK. This is of type `CatalyzeFailureBlock`. It has 3 parameters: `NSDictionary *result, int status, NSError *error`. The `result` dictionary is the JSON error response from the API. Now you can see the exact errors you are getting without having to turn on logging! `status` and `error` are identical to how they have always been: the HTTP status code and the NSError object constructed from the response.

CatalyzeUser
============
Before you can perform any action on the Catalyze API, you need to authenticate. This is done by logging in or signing up through CatalyzeUser. A CatalyzeUser represents any entity logging in to an application. Specific data is tied to this user and any CatalyzeEntrys created while the user is logged in are tied to their account.

Similarly to a CatalyzeEntry, you can save any information you want to a user but it is called an 'extra'. This is because there are a number of predefined data elements on a CatalyzeUser listed below.  So instead of using the methods

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
* type
* extras

All of these fields have getters and setters on a CatalyzeUser object.  All other data must be stored as an Extra.

Some fields are not primitive data types. Those marked with a ```*``` above are nested objects. Those marked with a ```**``` are arrays of nested objects. Those objects and their corresponding properties can be viewed in the respective classes. 

Log in
------
Log in by calling

    [CatalyzeUser logInWithUsernameInBackground:username password:password success:^(CatalyzeUser *result) {
		//logged in, take appropriate action
    } failure:^(NSDictionary *result, int status, NSError *error) {
        //check the result dictionary and show an appropriate response
    }];
    
The logged in user is passed back in the success block but is also assigned to the currentUser property of the CatalyzeUser class. Only one user can be logged in at any time using the SDK so after a successful login this use can be accessed by calling 

	[CatalyzeUser currentUser];

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
    [[CatalyzeUser currentUser] setExtra:[NSNumber numberWithBool:YES] forKey:@"on_medication"];
    [[CatalyzeUser currentUser] saveInBackground];

**Note**: All of the same methods for performing CRUD operations on a CatalyzeEntry apply to saving a CatalyzeUser as well except creation. If you need to create a CatalyzeUser please use `[CatalyzeUser signUpWithUsernameInBackground:email:name:password:success:failure:]` instead. Your code will not compile if you try to use the creation methods for CatalyzeUser.

Entries
=======
A CatalyzeEntry represents an Entry that can be stored on the catalyze.io API in a pre defined custom class.  These custom classes must be created in the dashboard before being used or referenced within an app or the API will return a 4XX status code. 

CatalyzeEntrys have a few properties to them: entryId, authorId, parentId, updatedAt, createdAt, and content. The following list explains these in short detail

* entryId - the unique ID of the entry itself
* authorId - the unique ID of the user who created this entry
* parentId - the unique ID of the user who owns this entry
* updatedAt - timestamp of the last time the entry was updated
* createdAt - timestamp of when the entry was created
* content - a 1-to-1 mapping of keys and values to the custom classes schema (the meat of the entry)

Creating Entries
----------------
To use a CatalyzeEntry you must initialize it with the name of the custom class you created on the dashboard:

    CatalyzeEntry *myEntry = [CatalyzeEntry entryWithClassName:@"{customClassName}"];

Now that you have a CatalyzeEntry you can save values, retrieve values, and create the new Entry on the catalyze.io API.

    [[myEntry content] setObject:@"blue" forKey:@"favorite_color"];
    NSString *myColor = [[myEntry content] objectForKey:@"favorite_color"];
    [myEntry createInBackground];

You can also initialize an entry with a its unique identifier.  This is useful when the id is known, but you have to fetch the entry from the API because all of the other data for that Entry is not stored locally.  To do this simply

    CatalyzeEntry *myNewEntry = [CatalyzeEntry entryWithClassName:@"{customClassName}"];
    [myNewEntry setEntryId:@"1234"];
    [myNewEntry retrieveInBackgroundWithSuccess:^(id result) {
		//take action here
		//the object is passed back in the block, but its not needed since you have a reference to myNewEntry
    } failure:^(NSDictionary *result, int status, NSError *error) {
		//take appropriate action here, show a message to the user!
		//you can access the error message from the server in the `result` dictionary
    }];
    
Saving Your Data
----------------
To save changes to any data you have to the catalyze.io API you have 3 options.  Save the data asynchronously without a callback, save the data asynchronously with a callback, or save the data asynchronously and perform a given selector on the main thread once completed.  These three options are available for any object conforming to the `CatalyzeObjectProtocol` protocol which is currently just CatalyzeEntry and CatalyzeUser. They are performed as follows:

Asynchronous without callback:

    [catalyzeEntryInstance saveInBackground];

Asynchronous with callback:

    [catalyzeEntryInstance saveInBackgroundWithSuccess:^(id result) {
		//perform actions here
    } failure:^(NSDictionary *result, int status, NSError *error) {
		//take appropriate actions for failure here
    }];

Asynchronous and perform a selector on the main thread:

    [catalyzeEntryInstance saveInBackgroundWithTarget:self selector:@selector(takeAction:)];

Querying
========
A CatalyzeQuery is how you manage searching a custom class.  There are four parts to a CatalyzeQuery.

The first two are `pageSize` and `pageNumber`.  `pageSize` is the amount of Entries you want to receive back from the API.  Note that you will not always receive `pageSize` number of Entries in return.  The actual number depends on the `pageNumber` requested and the amount of Entries in the custom class. `pageNumber` is used to specify how many Entries should be skipped.  For example, say there are 50 Entries in a custom class numbered 0 to 49.  `pageNumber` of 1 and a `pageSize` of 20 will return Entries 0 through 19.  A `pageNumber` of 2 and a `pageSize` of 20 will return Entries 20 through 39.

The second two are `queryField` and `queryValue`.  `queryField` is the data column of the custom class that is to be searched and `queryValue` is the actual value that is to be looked for in the `queryField` column.

To use CatalyzeQuery you must initialize the object with the name of the custom class that is being queried.

    CatalyzeQuery *query = [CatalyzeQuery queryWithClassName:@"{myCustomClass}"];
    [query setQueryValue:@"53202"];
    [query setQueryField:@"zip_code"];
    [query setPageNumber:1];
    [query setPageSize:100];
    [query retrieveInBackgroundWithSuccess:^(NSArray *result) {
        //query completed successfully with an array CatalyzeEntry instances
    } failure:^(NSDictionary *result, int status, NSError *error) {
        //query failed
    }];

If you are an **administrator or supervisor (or have the appropriate ACLs)** you can query the entire custom class.

    CatalyzeQuery *query = [CatalyzeQuery queryWithClassName:@"{myCustomClass}"];
    [query setQueryValue:@"53202"];
    [query setQueryField:@"zip_code"];
    [query setPageNumber:1];
    [query setPageSize:100];
    [query retrieveAllEntriesInBackgroundWithSuccess:^(NSArray *result) {
        //query completed successfully with an array CatalyzeEntry instances
    } failure:^(NSDictionary *result, int status, NSError *error) {
        //query failed
    }];
    
Another option you have **with appropriate privileges** is to query another users data directly. You must know their usersId first.

	CatalyzeQuery *query = [CatalyzeQuery queryWithClassName:@"{myCustomClass}"];
    [query setQueryValue:@"53202"];
    [query setQueryField:@"zip_code"];
    [query setPageNumber:1];
    [query setPageSize:100];
    [query retrieveInBackgroundForUsersId:@"{otherUsersId}" success:^(NSArray *result) {
        //query completed successfully with an array CatalyzeEntry instances
    } failure:^(NSDictionary *result, int status, NSError *error) {
        //query failed
    }];

File Management
===============
Rather than just saving simple data types such as strings, numbers, or booleans, you can also store files on the Catalyze API using the iOS SDK. All file management tasks are done through the `CatalyzeFileManager` class. You can upload files, download files, list your files, or delete files. You can also perform those same operations for another user **with the appropriate permission level** of course.

Uploading Files
---------------
Uploading a file requires an instance of NSData and to know the mime-type of the file you are uploading. If you have a file named `testFile.txt` in your main bundle, uploading a file would look like this

	NSString *path = [[NSBundle mainBundle] pathForResource:@"testFile" ofType:@"txt"];
    NSData *data = [NSData dataWithContentsOfFile:path];
	[CatalyzeFileManager uploadFileToUser:data phi:NO mimeType:@"text/plain" success:^(NSDictionary *result) {
        NSString *filesId = [result valueForKey:@"filesId"];
        //store the filesId somewhere
    } failure:^(NSDictionary *result, int status, NSError *error) {
        //something went wrong, check the result dictionary
    }];
    
If you want to upload a file for another user you must first know their usersId

	NSString *path = [[NSBundle mainBundle] pathForResource:@"testFile" ofType:@"txt"];
    NSData *data = [NSData dataWithContentsOfFile:path];
	[CatalyzeFileManager uploadFileToOtherUser:data usersId:@"{usersId}" phi:NO mimeType:@"text/plain" success:^(NSDictionary *result) {
        NSString *filesId = [result valueForKey:@"filesId"];
        //store the filesId somewhere
    } failure:^(NSDictionary *result, int status, NSError *error) {
        //something went wrong, check the result dictionary
    }];

Downloading Files
-----------------
After we have uploaded a file, remember to store the filesId. The filesId is what you use to download a file. It uniquely identifies the file

	[CatalyzeFileManager retrieveFile:filesId success:^(NSData *result) {
        //save the data to disk, construct an image, etc.
    } failure:^(NSDictionary *result, int status, NSError *error) {
        //something went wrong, check the result dictionary
    }];
    
Similarly if you uploaded a file for another user, you can download that file **with the appropriate permissions** like this

	[CatalyzeFileManager retrieveFileFromUser:filesId usersId:@"{usersId}" success:^(NSData *result) {
        //save the data to disk, construct an image, etc.
    } failure:^(NSDictionary *result, int status, NSError *error) {
        //something went wrong, check the result dictionary
    }];

Listing Files
-------------
If you don't save your filesId or you just want to give your user a list of all the files they have and let them choose which one they want, you can list all the files that belong to the currently logged in user

	[CatalyzeFileManager listFiles:^(NSArray *result) {
        for (NSDictionary *dict in result) {
            [dict valueForKey:@"filesId"];
        }
    } failure:^(NSDictionary *result, int status, NSError *error) {
        //something went wrong, check the result dictionary
    }];
    
Similarly for another user, you can list their files as well **with the appropriate permissions**

	[CatalyzeFileManager listFilesForUser:@"{usersId}" success:^(NSArray *result) {
        for (NSDictionary *dict in result) {
            [dict valueForKey:@"filesId"];
        }
    } failure:^(NSDictionary *result, int status, NSError *error) {
        //something went wrong, check the result dictionary
    }];

Deleting Files
--------------
Deleting a file is straightforward and follows the same pattern as the other file management routes. If you know the filesId you can delete a file like this

	[CatalyzeFileManager deleteFile:filesId success:^(id result) {
        //the files has been deleted
    } failure:^(NSDictionary *result, int status, NSError *error) {
        //something went wrong, check the result dictionary
    }];

Similarly for another user, you can delete one of their files **with the appropriate permissions** like this

	[CatalyzeFileManager deleteFileFromUser:filesId usersId:@"{usersId}" success:^(id result) {
        //the files has been deleted
    } failure:^(NSDictionary *result, int status, NSError *error) {
        //something went wrong, check the result dictionary
    }];

License
=======

    Copyright 2014 catalyze.io, Inc.

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
