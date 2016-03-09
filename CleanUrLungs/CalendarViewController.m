//
//  CalendarViewController.m
//  CleanUrLungs
//
//  Created by Thomas Prezioso on 11/17/15.
//  Copyright © 2015 Thomas Prezioso. All rights reserved.
//

#import "CalendarViewController.h"
#import "Day.h"
#import "DetailCalendarViewController.h"

@interface CalendarViewController () <FSCalendarDataSource, FSCalendarDelegate>

@property (strong, nonatomic) IBOutlet FSCalendar *calendar;
@property (nonatomic)BOOL hasEvent;

@end

@implementation CalendarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.calendar.dataSource = self;
    self.calendar.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    NSString *savedCigValue = [[NSUserDefaults standardUserDefaults] stringForKey:@"cigValueToSave"];
//    NSString *savedCigSmokedValue = [[NSUserDefaults standardUserDefaults] stringForKey:@"cigSmokedValue"];
//    if (savedCigSmokedValue > savedCigValue) {
//        self.calendar.appearance.eventColor = [UIColor redColor];
//    }
//    if ([savedCigSmokedValue isEqualToString:@"0"]) {
//        self.calendar.appearance.eventColor = [UIColor greenColor];
//    }
}

- (NSInteger)calendar:(FSCalendar *)calendar numberOfEventsForDate:(NSDate *)date
{
    Day *calenderDays = [Day new];
    NSMutableArray *daysSavedArray = [[NSMutableArray alloc] init];
    daysSavedArray = [calenderDays retriveDates];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd-yyyy"];
    NSMutableArray *savedDatesArray = [NSMutableArray new];
    for (NSInteger i = 0; i < [daysSavedArray count]; i++) {
        calenderDays.date = [daysSavedArray[i] valueForKey:@"dateSaved"];
        calenderDays.smokeValue = [daysSavedArray[i] valueForKey:@"smokedValue"];
        calenderDays.dailyGoal = [daysSavedArray[i] valueForKey:@"dailyGoal"];
        [savedDatesArray addObject:calenderDays.date];
        self.hasEvent = YES;
    }
    return [savedDatesArray containsObject:[self.calendar stringFromDate:date format:@"MM-dd-yyyy"]];
}

- (void)calendar:(FSCalendar *)calendar didSelectDate:(NSDate *)date
{
    NSLog(@"DID SELECT DAY %@",date);
    Day *calenderDays = [Day new];
    NSMutableArray *daysToCheckArray = [[NSMutableArray alloc] init];
    daysToCheckArray = [calenderDays retriveDates];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd-yyyy"];
    NSMutableArray *savedDatesArray = [NSMutableArray new];
    for (NSInteger i = 0; i < [daysToCheckArray count]; i++) {
        calenderDays.date = [daysToCheckArray[i] valueForKey:@"dateSaved"];
        calenderDays.smokeValue = [daysToCheckArray[i] valueForKey:@"smokedValue"];
        calenderDays.dailyGoal = [daysToCheckArray[i] valueForKey:@"dailyGoal"];
        [savedDatesArray addObject:calenderDays.date];
        NSDate *newDate = [NSDate new];
        newDate = [dateFormatter dateFromString:calenderDays.date];
        if ([newDate isEqualToDate:date]) {
            [self performSegueWithIdentifier:@"detailCalendarVC" sender:self];
           
        }
    }
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

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"detailCalendarVC"]) {
        DetailCalendarViewController *detailVC = [[DetailCalendarViewController alloc] init];
        detailVC.detailDay = ;
    }
}
@end
