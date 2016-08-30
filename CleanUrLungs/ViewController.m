//
//  ViewController.m
//  CleanUrLungs
//
//  Created by Thomas Prezioso on 11/16/15.
//  Copyright © 2015 Thomas Prezioso. All rights reserved.
//

#import "ViewController.h"
#import "Day.h"
#import "CalendarViewController.h"
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
    [self setupUIElements];
    [self setDateTimeLabel];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetLabel) name:@"clearLabels" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(savedValues) name:@"updateDaily" object:nil];
    [[NSNotificationCenter defaultCenter] addObserverForName:NSCalendarDayChangedNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        [self timeChanged];
    }];
}

- (void)setupUIElements
{
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
    NSInteger counter = 1;
    if (![openString isEqualToString:closeString]) {
        [self timeChanged];
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
        self.isNewDay = YES;
    }
    if (self.isNewDay) {
        counter++;
        [[NSUserDefaults standardUserDefaults] setInteger:counter forKey:@"counter"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    NSInteger savedCounter = [[NSUserDefaults standardUserDefaults] integerForKey:@"counter"];
    BOOL isDGswitchON = [[NSUserDefaults standardUserDefaults] boolForKey:@"DGswitch"];
    if (isDGswitchON) {
        if (savedCounter == 7) {
            [self weekLaterReduceDailyCig];
            counter = 0;
            [[NSUserDefaults standardUserDefaults] setInteger:counter forKey:@"counter"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
}

- (void)timeChanged
{
    self.smokedLabel.text = @"0";
    self.cravingLabel.text = @"0";
}

- (void)resetLabel
{
    self.smokedLabel.text = @"0";
    self.cravingLabel.text = @"0";
    [[NSUserDefaults standardUserDefaults] setObject:self.smokedLabel.text forKey:@"cigSmokedValue"];
    [[NSUserDefaults standardUserDefaults] setObject:self.cravingLabel.text forKey:@"cravedSaved"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)setupLabels
{
    self.cravingLabel.text = @"0";
    self.smokedLabel.text = @"0";
    self.dailyGoalLabel.text = @"0";
}

- (void)checkIfValuesAreNil
{
    if (self.dailyGoalLabel.text == nil) {
        self.dailyGoalLabel.text = @"0";
    }
    if (self.smokedLabel.text == nil) {
        self.smokedLabel.text = @"0";
    }
    if (self.cravingLabel.text == nil) {
        self.cravingLabel.text = @"0";
    }
}

- (void)savedValues
{
    self.dailyGoalLabel.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"cigValueToSave"];
    self.smokedLabel.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"cigSmokedValue"];
    self.cravingLabel.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"cravedSaved"];
    [self checkIfValuesAreNil];
    [self checkIfOverDailyGoal];
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

- (void)dailyGoalCheck
{
    if ([self.alertTextField.text isEqualToString:@"0"]) {
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"Error"
                                              message:@"This Is An Invaild Input, Please Try Again"
                                              preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       [self setUpAlert];
                                   }];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:self.alertTextField.text forKey:@"cigValueToSave"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateDaily" object:nil];
    }
}


- (void)setUpAlert
{
    UIAlertController *firstTimeAlert = [UIAlertController alertControllerWithTitle:@"Welcome to CleanUrLungs"
                                                                            message:@"Lets get started by Finding out how many Cigarttees you smoke a Day"
                                                                     preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *firstTimeAction = [UIAlertAction actionWithTitle:@"OK"
                                                              style:UIAlertActionStyleDefault
                                                            handler:^(UIAlertAction * _Nonnull action)
                                                            {
                                                                [self dailyGoalCheck];
                                                            }];
    [firstTimeAlert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        self.alertTextField = textField;
        textField.keyboardType = UIKeyboardTypeNumberPad;
    }];
    [firstTimeAlert addAction:firstTimeAction];
    [self presentViewController:firstTimeAlert animated:YES completion:nil];
}

- (void)saveToUserDefault
{
    [[NSUserDefaults standardUserDefaults] setObject:self.dailyGoalLabel.text forKey:@"cigValueToSave"];
    [[NSUserDefaults standardUserDefaults] setObject:self.cravingLabel.text forKey:@"cravedSaved"];
    [[NSUserDefaults standardUserDefaults] setObject:self.smokedLabel.text forKey:@"cigSmokedValue"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)dayToSegue
{
    self.day = [[Day alloc] init];
    self.day.craveTotal = self.cravingLabel.text;
    self.day.smokeValue = self.smokedLabel.text;
    self.day.dailyGoal = self.dailyGoalLabel.text;
}

- (void)weekLaterReduceDailyCig
{
    self.day = [[Day alloc] init];
    if ([self.day checkForGoalsMet]) {
        self.dailyGoalLabel.text = [NSString stringWithFormat:@"%d", [self.dailyGoalLabel.text intValue] -2];
        [[NSUserDefaults standardUserDefaults] setObject:self.dailyGoalLabel.text forKey:@"cigValueToSave"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (IBAction)cravingButton:(id)sender
{
    self.cravingLabel.text = [NSString stringWithFormat:@"%d", [self.cravingLabel.text intValue] +1];
    [[NSUserDefaults standardUserDefaults] setObject:self.cravingLabel.text forKey:@"cravedSaved"];
    NSUserDefaults *extensionDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.CleanUrLungsTodayView"];
    [extensionDefaults setObject:self.cravingLabel.text forKey:@"cravedExtension"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)smokedButton:(id)sender
{
    [self.view shake];
    self.smokedLabel.text = [NSString stringWithFormat:@"%d", [self.smokedLabel.text intValue] +1];
    [UIApplication sharedApplication].applicationIconBadgeNumber = [self.smokedLabel.text intValue];
    if (self.smokedLabel.text > self.dailyGoalLabel.text) {
        self.smokedLabel.textColor = [UIColor redColor];
    }
    NSUserDefaults *extensionDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.CleanUrLungsTodayView"];
    [extensionDefaults setObject:self.smokedLabel.text forKey:@"smokeExtension"];
    [[NSUserDefaults standardUserDefaults] setObject:self.smokedLabel.text forKey:@"cigSmokedValue"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [self dayToSegue];
    if ([segue.identifier isEqualToString:@"calendar"]) {
        CalendarViewController *detailVC = segue.destinationViewController;
        [self saveToUserDefault];
        detailVC.currentDayData = self.day;
    }
}

@end
