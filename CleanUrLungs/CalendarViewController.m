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
    [super viewWillAppear:animated];
    NSString *savedCigValue = [[NSUserDefaults standardUserDefaults] stringForKey:@"cigValueToSave"];
    NSString *savedCigSmokedValue = [[NSUserDefaults standardUserDefaults] stringForKey:@"cigSmokedValue"];
    if (savedCigSmokedValue >= savedCigValue) {
        self.calendar.appearance.eventColor = [UIColor redColor];
    }
}

- (BOOL)calendar:(FSCalendar *)calendar hasEventForDate:(NSDate *)date
{
    Day *calenderDays = [Day new];
    NSMutableArray *daysSavedArray = [[NSMutableArray alloc] init];
    daysSavedArray = [calenderDays retriveDates];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd-yyyy"];
    for (NSInteger i = 0; i < [daysSavedArray count]; i++) {
        NSDate *newdate = [[NSDate alloc] init];
        calenderDays.date = [daysSavedArray[i] valueForKey:@"dateSaved"];
        calenderDays.smokeValue = [daysSavedArray[i] valueForKey:@"smokedValue"];
        calenderDays.dailyGoal = [daysSavedArray[i] valueForKey:@"dailyGoal"];
        newdate = [dateFormatter dateFromString:calenderDays.date];
        NSDate *reworkedDate = [NSDate new];
        reworkedDate = [self dateWithOutTime:newdate];
        NSDate *currentCalendarDate = [NSDate new];
        currentCalendarDate = [self dateWithOutTime:currentCalendarDate];
        if ([reworkedDate isEqualToDate:date]) {
            if (calenderDays.smokeValue >= calenderDays.dailyGoal) {
                self.calendar.appearance.eventColor = [UIColor redColor];
            } else {
                self.calendar.appearance.eventColor = [UIColor greenColor];
            }
            return YES;
        }
    }
    return NO;
}

# pragma mark Helper Method(s)
- (NSDate *)dateWithOutTime:(NSDate *)datDate
{
    if (datDate == nil) {
        datDate = [NSDate date];
    }
    NSDateComponents* comps = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond fromDate:datDate];
    [comps setHour:00];
    [comps setMinute:00];
    [comps setSecond:00];
    [comps setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    return [[NSCalendar currentCalendar] dateFromComponents:comps];
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
