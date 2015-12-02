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
    self.cravingLabel.text = @"0";
    self.smokedLabel.text = @"0";
    self.dailyGoalLabel.text = @"0";
    self.smokedLabel.textColor = [UIColor greenColor];

    if (self.smokedLabel.text > self.dailyGoalLabel.text) {
        self.smokedLabel.textColor = [UIColor redColor];
    }
    
    if ([self isFirstTimeInApp]) {
        [self setUpAlert];
        NSDate *startDate = [NSDate date];
        [[NSUserDefaults standardUserDefaults] setObject:startDate forKey:@"startDate"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        [self savedValues];
    }
    [self oneDayLater];
    [self weekLaterReduceDailyCig];
    NSString *cavedNumberToSave = self.cravingLabel.text;
    [[NSUserDefaults standardUserDefaults] setObject:cavedNumberToSave forKey:@"cravedSaved"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSString *smokedNumberToSave = self.smokedLabel.text;
    [[NSUserDefaults standardUserDefaults] setObject:smokedNumberToSave forKey:@"cigSmokedValue"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)savedValues
{
    NSString *savedCigValue = [[NSUserDefaults standardUserDefaults] stringForKey:@"cigValueToSave"];
    self.dailyGoalLabel.text = savedCigValue;
    NSString *savedCigSmokedValue = [[NSUserDefaults standardUserDefaults] stringForKey:@"cigSmokedValue"];
    self.smokedLabel.text = savedCigSmokedValue;
    NSString *savedCravedValue = [[NSUserDefaults standardUserDefaults] stringForKey:@"cravedSaved"];
    self.cravingLabel.text = savedCravedValue;
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
    UIAlertController *firstTimeAlert = [UIAlertController alertControllerWithTitle:@"Welcome to CleanUrLungs" message:@"Lets get started by Finding out how many Cigarttees you smoke" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *firstTimeAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.dailyGoalLabel.text = self.alertTextField.text;
        NSString *cigValueToSave = self.dailyGoalLabel.text;
        [[NSUserDefaults standardUserDefaults] setObject:cigValueToSave forKey:@"cigValueToSave"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }];
    
    [firstTimeAlert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        self.alertTextField = textField;
        NSLog(@".....%@", textField);
    }];
    [firstTimeAlert addAction:firstTimeAction];
    [self presentViewController:firstTimeAlert animated:YES completion:nil];

}

- (void)oneDayLater
{
    NSDate *currentDate = [NSDate date];
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setDay:+1];
    NSDate *beginningDate = [[NSDate alloc] init];
    NSDate *afterOneDays = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:currentDate options:0];
    NSLog(@"beginningDay: %@", beginningDate);
    NSLog(@"afterSevenDays: %@", afterOneDays);

    if ([afterOneDays isEqualToDate:currentDate]) {
        self.cravingLabel.text = @"0";
        self.smokedLabel.text = @"0";
    }
}

- (void)weekLaterReduceDailyCig
{
    NSDate *currentDate = [NSDate date];
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    [dateComponents setDay:+7];
    NSDate *beginningDate = [[NSDate alloc] init];
    [[NSUserDefaults standardUserDefaults] setObject:beginningDate forKey:@"startDate"];
    NSDate *afterSevenDays = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:beginningDate options:0];
    NSLog(@"beginningDay: %@", beginningDate);
    NSLog(@"afterSevenDays: %@", afterSevenDays);
    
    if (afterSevenDays == currentDate) {
      self.dailyGoalLabel.text = [NSString stringWithFormat:@"%d", [self.dailyGoalLabel.text intValue]-2] ;
    }
}

- (IBAction)cravingButton:(id)sender
{
    self.cravingLabel.text = [NSString stringWithFormat:@"%d", [self.cravingLabel.text intValue]+1];
    NSString *cavedNumberToSave = self.cravingLabel.text;
    [[NSUserDefaults standardUserDefaults] setObject:cavedNumberToSave forKey:@"cravedSaved"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)smokedButton:(id)sender
{
    self.smokedLabel.text = [NSString stringWithFormat:@"%d", [self.smokedLabel.text intValue]+1];
    if ([self.smokedLabel.text isEqualToString:self.dailyGoalLabel.text]) {
        self.smokedLabel.textColor = [UIColor redColor];
    }
    [UIApplication sharedApplication].applicationIconBadgeNumber = [self.smokedLabel.text intValue];
    NSString *smokedNumberToSave = self.smokedLabel.text;
    [[NSUserDefaults standardUserDefaults] setObject:smokedNumberToSave forKey:@"cigSmokedValue"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end
