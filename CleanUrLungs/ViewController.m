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
// tommorrow the text should show 2 less
    self.cravingLabel.text = @"0";
    self.smokedLabel.text = @"0";
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
    [self weekLater];
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

- (void)weekLater
{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    //remember to switch back set day to 7 when done with test
    [dateComponents setDay:+1];
    NSDate *beginningDate = [[NSDate alloc] init];
    [[NSUserDefaults standardUserDefaults] setObject:beginningDate forKey:@"startDate"];
    NSDate *afterSevenDays = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:beginningDate options:0];
    NSLog(@"beginningDay: %@", beginningDate);
    NSLog(@"afterSevenDays: %@", afterSevenDays);
    if (afterSevenDays) {
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
