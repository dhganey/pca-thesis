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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
