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
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *dailyGoalLabel;
@property (strong, nonatomic) IBOutlet UILabel *cravedLabel;
@property (strong, nonatomic) IBOutlet UILabel *smokedLabel;
@property (nonatomic) BOOL hasEvent;
@property (strong, nonatomic) Day *calendarDay;
@property (strong, nonatomic) NSDate *dateToPass;

@end

@implementation CalendarViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.calendar.dataSource = self;
    self.calendar.delegate = self;
    [self changeCalenderToStartOnMonday];
    [self setupCalendar];
    [self setupLabelsForCurrentDay];
    [self setNavigationController];
}

- (void)changeCalenderToStartOnMonday
{
    BOOL isSwitchedOn = [[NSUserDefaults standardUserDefaults] boolForKey:@"switch"];
    if (isSwitchedOn) {
        self.calendar.firstWeekday = 2;
    } else {
        self.calendar.firstWeekday = 1;
    }
}

- (void)setNavigationController
{
    self.navigationController.navigationBar.tintColor = [UIColor orangeColor];
    self.navigationController.navigationBar.backgroundColor = [UIColor orangeColor];
}

- (void)setupCalendar
{
    self.calendar.scrollDirection = FSCalendarScrollDirectionVertical;
    self.calendar.appearance.weekdayTextColor = [UIColor orangeColor];
    self.calendar.appearance.headerTitleColor = [UIColor orangeColor];
    self.calendar.appearance.todayColor = [UIColor orangeColor];
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
    Day *currentDay = [Day new];
    self.dateToPass = [NSDate new];
    self.dateToPass = date;
    NSMutableArray *daysToCheckArray = [[NSMutableArray alloc] init];
    daysToCheckArray = [calenderDays retriveDates];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd-yyyy"];
    NSDate *newDate = [NSDate new];
    for (NSInteger i = 0; i < [daysToCheckArray count]; i++) {
        calenderDays.date = [daysToCheckArray[i] valueForKey:@"dateSaved"];
        calenderDays.smokeValue = [daysToCheckArray[i] valueForKey:@"smokedValue"];
        calenderDays.dailyGoal = [daysToCheckArray[i] valueForKey:@"dailyGoal"];
        NSDate *coolDate = [self dateWithOutTime:date];
        newDate = [dateFormatter dateFromString:calenderDays.date];
        newDate = [self dateWithOutTime:newDate];
        if ([newDate isEqualToDate:coolDate]) {
            self.calendarDay = [[Day alloc] init];
            self.calendarDay = calenderDays;
            NSDate *calendarToday = [NSDate new];
            calendarToday = [self dateWithOutTime:self.calendar.today];
            if ([newDate isEqualToDate:calendarToday]) {
                currentDay.dailyGoal = [[NSUserDefaults standardUserDefaults] stringForKey:@"cigValueToSave"];
                currentDay.smokeValue = [[NSUserDefaults standardUserDefaults] stringForKey:@"cigSmokedValue"];
                currentDay.craveTotal = [[NSUserDefaults standardUserDefaults] stringForKey:@"cravedSaved"];
                self.calendarDay = currentDay;
            }
            break;
        }
        if (currentDay.date == nil) {
            NSString *dateString = [dateFormatter stringFromDate:date];
            currentDay.date = dateString;
            self.calendarDay = currentDay;
        }
    }
    [self setupDetailLabel];
}

- (void)checkIfValuesAreNil
{
    if (self.currentDayData.craveTotal == nil) {
        self.cravedLabel.text = @"Craved     0";
    }
    if (self.currentDayData.smokeValue == nil) {
        self.smokedLabel.text = @"Smoked     0";
    }
    if (self.currentDayData.dailyGoal == nil) {
        self.dailyGoalLabel.text =  @"Daily Goal     0";
    }
}

- (void)checkIfValuesAreNilSelectedDay
{
    if (self.calendarDay.craveTotal == nil) {
        self.cravedLabel.text = @"Craved     0";
    }
    if (self.calendarDay.smokeValue == nil) {
        self.smokedLabel.text = @"Smoked     0";
    }
    if (self.calendarDay.dailyGoal == nil) {
        self.dailyGoalLabel.text =  @"Daily Goal     0";
    }
}

- (void)setupLabelsForCurrentDay
{
    NSDate *anotherDate = [NSDate new];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateStyle:NSDateFormatterMediumStyle];
    NSString *dateString = [dateFormat stringFromDate:anotherDate];
    self.dateLabel.text = dateString;
    self.dailyGoalLabel.text = [NSString stringWithFormat:@"Daily Goal     %@", self.currentDayData.dailyGoal];
    self.cravedLabel.text = [NSString stringWithFormat:@"Craved     %@", self.currentDayData.craveTotal];
    self.smokedLabel.text = [NSString stringWithFormat:@"Smoked     %@", self.currentDayData.smokeValue];
    [self checkIfValuesAreNil];

}

- (void)setupDetailLabel
{
    self.dateLabel.text = [self convertDate];
    self.dailyGoalLabel.text = [NSString stringWithFormat:@"Daily Goal     %@", self.calendarDay.dailyGoal];
    self.cravedLabel.text = [NSString stringWithFormat:@"Craved     %@", self.calendarDay.craveTotal];
    self.smokedLabel.text = [NSString stringWithFormat:@"Smoked     %@", self.calendarDay.smokeValue];
    [self checkIfValuesAreNilSelectedDay];
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

- (NSString *)convertDate
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateStyle:NSDateFormatterMediumStyle];
    NSString *dateString = [dateFormat stringFromDate:self.dateToPass];
    return dateString;
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
