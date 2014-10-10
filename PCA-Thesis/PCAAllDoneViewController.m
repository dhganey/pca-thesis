//
//  PCAAllDoneViewController.m
//  PCA-Thesis
//
//  Created by David Ganey on 9/21/14.
//  Copyright (c) 2014 dhganey. All rights reserved.
//

#import "PCAAllDoneViewController.h"

@interface PCAAllDoneViewController ()

@end

@implementation PCAAllDoneViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    if (self.doneType == NO_NEED)
    {
        
    }
    else if (self.doneType == DONE_ENTERING)
    {
        [self showUrgentSymptoms];
    }
    else
    {
        //todo
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) showUrgentSymptoms
{
    NSString* feedback = @"";
    int count = 0;
    
    for (NSString* key in self.urgentDictionary)
    {
        if ([[self.urgentDictionary valueForKey:key] intValue] > 0)
        {
            count++;
        }
    }
    count++; //for final line
    
    UILabel *feedLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 65, CGRectGetWidth(self.view.bounds), 100)]; //todo adjust magic nums
    feedLabel.lineBreakMode = NSLineBreakByCharWrapping;
    [feedLabel setNumberOfLines:count];
    feedLabel.font = [feedLabel.font fontWithSize:14];

    for (NSString* key in self.urgentDictionary)
    {
        if ([[self.urgentDictionary valueForKey:key] intValue] > 0)
        {
            if ([[self.urgentDictionary valueForKey:key] intValue] == 1)
            {
                NSString* tempString = [NSString stringWithFormat:@"Your %@ is a little high\n", key];
                feedback = [feedback stringByAppendingString:tempString];
            }
            else if ([[self.urgentDictionary valueForKey:key] intValue] == 2)
            {
                NSString* tempString = [NSString stringWithFormat:@"Your %@ is very high\n", key];
                feedback = [feedback stringByAppendingString:tempString];
            }
        }
    }
    feedback = [feedback stringByAppendingString:@"Your physician has been notified"];
    
    [feedLabel setText:feedback];
    [self.view addSubview:feedLabel];

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
