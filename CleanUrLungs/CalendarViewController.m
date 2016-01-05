//
//  CalendarViewController.m
//  CleanUrLungs
//
//  Created by Thomas Prezioso on 11/17/15.
//  Copyright © 2015 Thomas Prezioso. All rights reserved.
//

#import "CalendarViewController.h"

@interface CalendarViewController () <FSCalendarDataSource, FSCalendarDelegate>

@property (strong, nonatomic) IBOutlet FSCalendar *calendar;

@end

@implementation CalendarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.calendar.dataSource = self;
    self.calendar.delegate = self;
    self.calendar.appearance.eventColor = [UIColor greenColor];
}

- (void)viewWillAppear:(BOOL)animated
{
    NSString *savedCigValue = [[NSUserDefaults standardUserDefaults] stringForKey:@"cigValueToSave"];
    NSString *savedCigSmokedValue = [[NSUserDefaults standardUserDefaults] stringForKey:@"cigSmokedValue"];

    if (savedCigSmokedValue >= savedCigValue) {
        self.calendar.appearance.eventColor = [UIColor redColor];
    }
}

- (BOOL)calendar:(FSCalendar *)calendar hasEventForDate:(NSDate *)date
{
    if ([date isEqualToDate:self.calendar.today]) {
        return YES;
    }
    return NO;
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
