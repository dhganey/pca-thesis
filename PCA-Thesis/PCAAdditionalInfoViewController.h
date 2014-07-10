//
//  PCAAdditionalInfoViewController.h
//  PCA-Thesis
//
//  Created by David Ganey on 7/9/14.
//  Copyright (c) 2014 dhganey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PCAAdditionalInfoViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *doctorNameField;
@property (weak, nonatomic) IBOutlet UISwitch *painSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *nauseaSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *tirednessSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *appetiteSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *breathSwitch;

- (IBAction)submitPressed:(id)sender;

@end
