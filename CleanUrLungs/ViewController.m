//
//  ViewController.m
//  CleanUrLungs
//
//  Created by Thomas Prezioso on 11/16/15.
//  Copyright © 2015 Thomas Prezioso. All rights reserved.
//

#import "ViewController.h"
#import "Day.h"
#import <CoreData/CoreData.h>
#import <UIView+Shake.h>

@interface ViewController ()

@property (strong, nonatomic) IBOutlet UILabel *cravingLabel;
@property (strong, nonatomic) IBOutlet UILabel *smokedLabel;
@property (strong, nonatomic) IBOutlet UILabel *inspiringQuote;
@property (strong, nonatomic) IBOutlet UILabel *dailyGoalLabel;
@property (strong, nonatomic) UITextField *alertTextField;
@property (nonatomic) BOOL isNewDay;
@property (nonatomic) NSInteger counter;
@property (strong, nonatomic) Day *day;
- (IBAction)cravingButton:(id)sender;
- (IBAction)smokedButton:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupLabels];
    [self checkIfFirstTimeInApp];
    [self checkIfDayChanged];
    [self checkIfOverDailyGoal];
    [self weekLaterReduceDailyCig];
    [self setupUIElements];
    [self setDateTimeLabel];
    [[NSNotificationCenter defaultCenter] addObserverForName:NSCalendarDayChangedNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        [self timeChanged];
    }];
}

- (void)setupUIElements
{
    self.view.backgroundColor = [UIColor orangeColor];
    self.cravingLabel.backgroundColor = [UIColor whiteColor];
    self.cravingLabel.textColor = [UIColor orangeColor];
    self.smokedLabel.backgroundColor = [UIColor whiteColor];
}

- (void)setDateTimeLabel
{
    NSDate *thisDay = [NSDate new];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateStyle:NSDateFormatterFullStyle];
    NSString *dateString = [dateFormat stringFromDate:thisDay];
    self.inspiringQuote.text = dateString;
}

- (void)checkIfFirstTimeInApp
{
    if ([self isFirstTimeInApp]) {
        [self setUpAlert];
        NSDate *startDate = [NSDate date];
        [[NSUserDefaults standardUserDefaults] setObject:startDate forKey:@"startDate"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        [self savedValues];
    }
}

- (void)checkIfOverDailyGoal
{
    if (self.smokedLabel.text > self.dailyGoalLabel.text) {
        self.smokedLabel.textColor = [UIColor redColor];
    } else {
        self.smokedLabel.textColor = [UIColor greenColor];
    }
}

- (void)checkIfDayChanged
{
    NSDate *open = [[NSUserDefaults standardUserDefaults] objectForKey:@"openDate"];
    NSDate *close = [[NSUserDefaults standardUserDefaults] objectForKey:@"closeDate"];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSString *openString = [dateFormat stringFromDate:open];
    NSString *closeString = [dateFormat stringFromDate:close];
    if (![openString isEqualToString:closeString]) {
        [self timeChanged];
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        self.isNewDay = YES;
    }
}

- (void)timeChanged
{
    self.smokedLabel.text = @"0";
    self.cravingLabel.text = @"0";
}

- (void)setupLabels
{
    self.cravingLabel.text = @"0";
    self.smokedLabel.text = @"0";
    self.dailyGoalLabel.text = @"0";
}

- (void)savedValues
{
    NSString *savedCigValue = [[NSUserDefaults standardUserDefaults] stringForKey:@"cigValueToSave"];
    self.dailyGoalLabel.text = savedCigValue;
    NSString *savedCigSmokedValue = [[NSUserDefaults standardUserDefaults] stringForKey:@"cigSmokedValue"];
    self.smokedLabel.text = savedCigSmokedValue;
    NSString *savedCravedValue = [[NSUserDefaults standardUserDefaults] stringForKey:@"cravedSaved"];
    self.cravingLabel.text = savedCravedValue;
    if (savedCigValue == nil) {
        savedCigValue = @"0";
        self.dailyGoalLabel.text = savedCigValue;
    }
    if (savedCigSmokedValue == nil) {
        savedCigSmokedValue = @"0";
        self.smokedLabel.text = savedCigSmokedValue;
    }
    if (savedCravedValue == nil) {
        savedCravedValue = @"0";
        self.cravingLabel.text = savedCravedValue;
    }
}

- (void)saveDate
{
    NSDate *dateNow = [NSDate new];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MM-dd-yyyy"];
    NSString *dateString = [dateFormat stringFromDate:dateNow];
    if (self.smokedLabel.text == nil) {
        self.smokedLabel.text = @"0";
    }
    if (self.cravingLabel.text == nil) {
        self.cravingLabel.text = @"0";
    }
    if (self.dailyGoalLabel.text == nil) {
        self.dailyGoalLabel.text = self.alertTextField.text;
    }
    NSString *dailyGoal = [[NSUserDefaults standardUserDefaults] stringForKey:@"cigValueToSave"];
    NSString *cigsSmoked = [[NSUserDefaults standardUserDefaults] stringForKey:@"cigSmokedValue"];
    self.day = [[Day alloc] initWithDate:dateString smokeValue:cigsSmoked dailyGoal:dailyGoal];
    [self.day checkToSeeIfDateIsSaved:self.day.date];
    [self.day saveDate:self.day.date smokeSaved:self.day.smokeValue dailyGoalSaved:self.day.dailyGoal];
}

- (BOOL)isFirstTimeInApp
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"isFirstRun"]) {
        return NO;
    }
    [defaults setObject:[NSDate date] forKey:@"isFirstRun"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    return YES;
}

- (void)setUpAlert
{
    UIAlertController *firstTimeAlert = [UIAlertController alertControllerWithTitle:@"Welcome to CleanUrLungs"
                                                                            message:@"Lets get started by Finding out how many Cigarttees you smoke"
                                                                     preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *firstTimeAction = [UIAlertAction actionWithTitle:@"OK"
                                                              style:UIAlertActionStyleDefault
                                                            handler:^(UIAlertAction * _Nonnull action) {
        self.dailyGoalLabel.text = self.alertTextField.text;
        NSString *cigValueToSave = self.dailyGoalLabel.text;
        [[NSUserDefaults standardUserDefaults] setObject:cigValueToSave forKey:@"cigValueToSave"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }];
    [firstTimeAlert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        self.alertTextField = textField;
        textField.keyboardType = UIKeyboardTypeNumberPad;
    }];
    [firstTimeAlert addAction:firstTimeAction];
    [self presentViewController:firstTimeAlert animated:YES completion:nil];
}

#pragma mark TEST THIS: needs to be tested if this actually work in reducing dailyGoal
- (void)weekLaterReduceDailyCig
{
    if ([self.day checkForGoalsMet]) {
        self.dailyGoalLabel.text = [NSString stringWithFormat:@"%d", [self.dailyGoalLabel.text intValue] -2];
        NSString *newDailyGoalSaved = self.dailyGoalLabel.text;
        [[NSUserDefaults standardUserDefaults] setObject:newDailyGoalSaved forKey:@"cigValueToSave"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (IBAction)cravingButton:(id)sender
{
    self.cravingLabel.text = [NSString stringWithFormat:@"%d", [self.cravingLabel.text intValue] +1];
    NSString *cavedNumberToSave = self.cravingLabel.text;
    [[NSUserDefaults standardUserDefaults] setObject:cavedNumberToSave forKey:@"cravedSaved"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)smokedButton:(id)sender
{
    [self.view shake];
    self.smokedLabel.text = [NSString stringWithFormat:@"%d", [self.smokedLabel.text intValue] +1];
    [UIApplication sharedApplication].applicationIconBadgeNumber = [self.smokedLabel.text intValue];
    NSString *smokedNumberToSave = self.smokedLabel.text;
    if (self.smokedLabel.text > self.dailyGoalLabel.text) {
        self.smokedLabel.textColor = [UIColor redColor];
    }
    [[NSUserDefaults standardUserDefaults] setObject:smokedNumberToSave forKey:@"cigSmokedValue"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
