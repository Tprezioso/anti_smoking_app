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
    FSCalendar *calendar = [[FSCalendar alloc] init];
    self.calendar = calendar;
    NSDate *currentDay = [NSDate date];
    NSLog(@"Current Date In calendar %@",currentDay);
    [self calendar:self.calendar hasEventForDate:currentDay];
    self.calendar.appearance.eventColor = [UIColor greenColor];
    
}

- (BOOL)calendar:(FSCalendar *)calendar hasEventForDate:(NSDate *)date
{
    
    return YES;
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
