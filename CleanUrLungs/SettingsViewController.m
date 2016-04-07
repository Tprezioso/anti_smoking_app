//
//  SettingsViewController.m
//  
//
//  Created by Thomas Prezioso on 4/5/16.
//
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

- (IBAction)dataClearButton:(id)sender;
- (IBAction)mondaySwitch:(id)sender;
@property (strong, nonatomic) IBOutlet UISwitch *switchControl;
@property (nonatomic) BOOL isSwitchON;

@end

@implementation SettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupSettings];
}

- (void)setupSettings
{
    BOOL isSwitchOnOrOff= [[NSUserDefaults standardUserDefaults] boolForKey:@"switch"];
    if (isSwitchOnOrOff) {
        [self.switchControl setOn:isSwitchOnOrOff animated:YES];
    }
    self.title = @"Settings";
    self.navigationController.navigationBar.tintColor = [UIColor orangeColor];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (IBAction)dataClearButton:(id)sender
{

}

- (IBAction)mondaySwitch:(id)sender
{
    UISwitch *mySwitch = (UISwitch *)sender;
    if ([mySwitch isOn]) {
        self.isSwitchON = YES;
        [[NSUserDefaults standardUserDefaults] setBool:self.isSwitchON forKey:@"switch"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        self.isSwitchON = NO;
        [[NSUserDefaults standardUserDefaults] setBool:self.isSwitchON forKey:@"switch"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

@end
