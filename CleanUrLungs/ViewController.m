//
//  ViewController.m
//  CleanUrLungs
//
//  Created by Thomas Prezioso on 11/16/15.
//  Copyright © 2015 Thomas Prezioso. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (strong, nonatomic) IBOutlet UILabel *cravingLabel;
@property (strong, nonatomic) IBOutlet UILabel *smokedLabel;
@property (strong, nonatomic) IBOutlet UILabel *inspiringQuote;
@property (strong, nonatomic) IBOutlet UILabel *dailyGoalLabel;
@property (strong, nonatomic) UITextField *alertTextField;
- (IBAction)cravingButton:(id)sender;
- (IBAction)smokedButton:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupLabels];
    if ([self isFirstTimeInApp]) {
        [self setUpAlert];
        NSDate *startDate = [NSDate date];
        [[NSUserDefaults standardUserDefaults] setObject:startDate forKey:@"startDate"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        [self savedValues];
        NSDate *savedDate = [[NSDate alloc] init];
        [[NSUserDefaults standardUserDefaults] setObject:savedDate forKey:@"startDate"];
        NSDate *today = [NSDate new];
        if ([savedDate isEqualToDate:today]) {
            [self timeChanged];
        }
    }
    NSDate *open = [[NSUserDefaults standardUserDefaults] objectForKey:@"openDate"];
    NSDate *close = [[NSUserDefaults standardUserDefaults] objectForKey:@"closeDate"];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSString *openString = [dateFormat stringFromDate:open];
    NSString *closeString = [dateFormat stringFromDate:close];
    if (![openString isEqualToString:closeString]) {
        [self timeChanged];
    }
    if (self.smokedLabel.text > self.dailyGoalLabel.text) {
        self.smokedLabel.textColor = [UIColor redColor];
    } else {
        self.smokedLabel.textColor = [UIColor greenColor];
    }
    [self weekLaterReduceDailyCig];
    [self setupTomorrowDate];
    [[NSNotificationCenter defaultCenter] addObserverForName:NSCalendarDayChangedNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        [self timeChanged];
    }];
}

- (void)setupTomorrowDate
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *todayComponents = [calendar components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
    NSDate *today = [calendar dateFromComponents:todayComponents];
    NSDateComponents *oneDay = [[NSDateComponents alloc] init];
    oneDay.day = 1;
    NSDate *tomorrow = [calendar dateByAddingComponents:oneDay toDate:today options:0];
    NSTimer *timer = [[NSTimer alloc] initWithFireDate:tomorrow interval:0 target:self selector:@selector(tomorrowTimerDidFire:) userInfo:nil repeats:NO];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)tomorrowTimerDidFire:(NSTimer *)timer
{
    [self timeChanged];
}

- (void)timeChanged
{
    NSString *savedCigSmokedValue = [[NSUserDefaults standardUserDefaults] stringForKey:@"cigSmokedValue"];
    savedCigSmokedValue = @"0";
    [[NSUserDefaults standardUserDefaults] setObject:savedCigSmokedValue forKey:@"cigSmokedValue"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    self.smokedLabel.text = savedCigSmokedValue;

    NSString *savedCravedValue = [[NSUserDefaults standardUserDefaults] stringForKey:@"cravedSaved"];
    savedCravedValue = @"0";
    [[NSUserDefaults standardUserDefaults] setObject:savedCravedValue forKey:@"cravedSaved"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    self.cravingLabel.text = savedCravedValue;
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
    UIAlertAction *firstTimeAction = [UIAlertAction actionWithTitle:@"Ok"
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
    NSDate *currentDate = [NSDate date];
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setDay:+7];
    NSDate *beginningDate = [[NSDate alloc] init];
    [[NSUserDefaults standardUserDefaults] setObject:beginningDate forKey:@"startDate"];
    NSDate *afterSevenDays = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents
                                                                           toDate:beginningDate
                                                                          options:0];
    if (afterSevenDays == currentDate) {
      self.dailyGoalLabel.text = [NSString stringWithFormat:@"%d", [self.dailyGoalLabel.text intValue] -2];
    }
    
    if ([self.dailyGoalLabel.text isEqualToString:@"0"]) {
        self.dailyGoalLabel.text = @"0";
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
    if ([self.smokedLabel.text isEqualToString:self.dailyGoalLabel.text]) {
        self.smokedLabel.textColor = [UIColor redColor];
    }
   
    [UIApplication sharedApplication].applicationIconBadgeNumber = [self.smokedLabel.text intValue];
    NSString *smokedNumberToSave = self.smokedLabel.text;
    [[NSUserDefaults standardUserDefaults] setObject:smokedNumberToSave forKey:@"cigSmokedValue"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
