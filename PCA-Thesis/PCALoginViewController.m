//
//  PCALoginViewController.m
//  PCA-Thesis
//
//  Created by David Ganey on 7/8/14.
//  Copyright (c) 2014 dhganey. All rights reserved.
//

#import "PCALoginViewController.h"

@interface PCALoginViewController ()

@property (nonatomic, strong) UIImageView* fieldsBackground;

@end

@implementation PCALoginViewController

@synthesize fieldsBackground;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.logInView setLogo:nil]; //remove Parse logo for now
    //[self.logInView setBackgroundColor:[UIColor whiteColor]]; //background color
    
    [self.logInView.dismissButton setImage:nil forState:UIControlStateNormal]; //hide dismiss button
    
//    // Remove text shadow
//    CALayer *layer = self.logInView.usernameField.layer;
//    layer.shadowOpacity = 0.0;
//    layer = self.logInView.passwordField.layer;
//    layer.shadowOpacity = 0.0;
    
    // Add login field background
//    fieldsBackground = [[UIImageView alloc] initWithImage:[self imageWithColor:[UIColor blueColor]]];
//    [self.logInView addSubview:self.fieldsBackground];
//    [self.logInView sendSubviewToBack:self.fieldsBackground];
    
    // Set field text color
//    [self.logInView.usernameField setTextColor:[UIColor colorWithRed:135.0f/255.0f green:118.0f/255.0f blue:92.0f/255.0f alpha:1.0]];
//    [self.logInView.passwordField setTextColor:[UIColor colorWithRed:135.0f/255.0f green:118.0f/255.0f blue:92.0f/255.0f alpha:1.0]];
    
}

//Creates a UI image using color
-(UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
