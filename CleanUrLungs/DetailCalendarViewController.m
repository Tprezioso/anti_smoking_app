//
//  DetailCalendarViewController.m
//  CleanUrLungs
//
//  Created by Thomas Prezioso on 3/8/16.
//  Copyright © 2016 Thomas Prezioso. All rights reserved.
//

#import "DetailCalendarViewController.h"
#import "Day.h"

@interface DetailCalendarViewController ()

@property (strong, nonatomic) IBOutlet UILabel *detailedDate;
@property (strong, nonatomic) IBOutlet UILabel *detailCrave;
@property (strong, nonatomic) IBOutlet UILabel *detailSmoke;

@end

@implementation DetailCalendarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.detailedDate.text = self.detailDay.date;
    self.detailCrave.text = self.detailDay.craveTotal;
    self.detailSmoke.text = self.detailDay.smokeValue;
    if (self.detailDay.craveTotal == nil) {
        self.detailCrave.text = @"0";
    }
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
