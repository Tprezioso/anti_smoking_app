//
//  CalendarViewController.m
//  CleanUrLungs
//
//  Created by Thomas Prezioso on 11/17/15.
//  Copyright © 2015 Thomas Prezioso. All rights reserved.
//

#import "CalendarViewController.h"
#import "Day.h"

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
    Day *calenderDays = [Day new];
    calenderDays = [calenderDays retriveDate];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd-yyyy"];
    NSString *stringDate = [[NSString alloc] init];
    stringDate = [dateFormatter stringFromDate:date];
    if ([stringDate isEqualToString:calenderDays.date]) {
        if (calenderDays.smokeValue >= calenderDays.dailyGoal) {
            self.calendar.appearance.eventColor = [UIColor redColor];
        }
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
