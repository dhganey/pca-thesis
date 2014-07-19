//
//  PCASignupViewController.m
//  PCA-Thesis
//
//  Created by David Ganey on 7/8/14.
//  Copyright (c) 2014 dhganey. All rights reserved.
//

#import "PCASignupViewController.h"

@interface PCASignupViewController ()

@property (nonatomic, strong) UIImageView* fieldsBackground;

@end

@implementation PCASignupViewController

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

    [self.signUpView setLogo:nil]; //remove Parse logo for now
    [self.signUpView setBackgroundColor:[UIColor whiteColor]]; //background color
        
    // Remove text shadow
    CALayer *layer = self.signUpView.usernameField.layer;
    layer.shadowOpacity = 0.0;
    layer = self.signUpView.passwordField.layer;
    layer.shadowOpacity = 0.0;
    
    // Add signup field background
    fieldsBackground = [[UIImageView alloc] initWithImage:[self imageWithColor:[UIColor blackColor]]];
    [self.signUpView addSubview:self.fieldsBackground];
    [self.signUpView sendSubviewToBack:self.fieldsBackground];
    
    // Set field text color
    [self.signUpView.usernameField setTextColor:[UIColor colorWithRed:135.0f/255.0f green:118.0f/255.0f blue:92.0f/255.0f alpha:1.0]];
    [self.signUpView.passwordField setTextColor:[UIColor colorWithRed:135.0f/255.0f green:118.0f/255.0f blue:92.0f/255.0f alpha:1.0]];
    
    //Add additional fields
    [self.signUpView.additionalField setPlaceholder:@"Phone number"];
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
