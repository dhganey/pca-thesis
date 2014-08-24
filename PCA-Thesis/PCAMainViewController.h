//
//  PCAMainViewController.h
//  PCA-Thesis
//
//  Created by David Ganey on 7/21/14.
//  Copyright (c) 2014 dhganey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PCAMainViewController : UIViewController <UIAlertViewDelegate>

- (IBAction)logoutPressed:(id)sender;

@property int currentSymptom;

@end
