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
    [[NSNotificationCenter defaultCenter] addObserverForName:NSCalendarDayChangedNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        [self timeChanged];
    }];
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
//    NSString *savedCigSmokedValue = [[NSUserDefaults standardUserDefaults] stringForKey:@"cigSmokedValue"];
//    savedCigSmokedValue = @"0";
//    [[NSUserDefaults standardUserDefaults] setObject:savedCigSmokedValue forKey:@"cigSmokedValue"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
    self.smokedLabel.text = @"0";

//    NSString *savedCravedValue = [[NSUserDefaults standardUserDefaults] stringForKey:@"cravedSaved"];
//    savedCravedValue = @"0";
//    [[NSUserDefaults standardUserDefaults] setObject:savedCravedValue forKey:@"cravedSaved"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
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
    NSLog(@"saved");
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

- (void)weekLaterReduceDailyCig
{
    self.counter = 1;
    if (self.isNewDay) {
        self.counter = [[NSUserDefaults standardUserDefaults] integerForKey:@"counter"];
        self.counter++;
        [[NSUserDefaults standardUserDefaults] setInteger:self.counter forKey:@"counter"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        if (self.counter == 7) {
            self.dailyGoalLabel.text = [NSString stringWithFormat:@"%d", [self.dailyGoalLabel.text intValue] -2];
            NSString *newDailyGoalSaved = self.dailyGoalLabel.text;
            [[NSUserDefaults standardUserDefaults] setObject:newDailyGoalSaved forKey:@"cigValueToSave"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            self.counter = 0;
            [[NSUserDefaults standardUserDefaults] setInteger:self.counter forKey:@"counter"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        } else {
            if ([self.dailyGoalLabel.text isEqualToString:@"0"]) {
                self.isNewDay = NO;
                NSString *dailyGoalLimit = self.dailyGoalLabel.text;
                [[NSUserDefaults standardUserDefaults] setObject:dailyGoalLimit forKey:@"cigValueToSave"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
        }
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
