//
//  SettingsViewController.m
//
//
//  Created by Thomas Prezioso on 4/5/16.
//
//

#import "SettingsViewController.h"
#import "Day.h"

@interface SettingsViewController ()

@property (strong, nonatomic) IBOutlet UISwitch *switchControl;
@property (strong, nonatomic) IBOutlet UISwitch *dailyGoalSwitch;
@property (nonatomic) BOOL isSwitchON;
@property (nonatomic) BOOL isDailyGoalSwitchON;
@property (strong, nonatomic) UITextField *alertTextField;
- (IBAction)dataClearButton:(id)sender;
- (IBAction)mondaySwitch:(id)sender;
- (IBAction)changeDailyGoalButton:(id)sender;
- (IBAction)dailyGoalSwitchAction:(id)sender;

@end

@implementation SettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupSettings];
}

- (void)setupSettings
{
    BOOL isSwitchOnOrOff = [[NSUserDefaults standardUserDefaults] boolForKey:@"switch"];
    if (isSwitchOnOrOff) {
        [self.switchControl setOn:isSwitchOnOrOff animated:YES];
    }
    BOOL isDGSwitchOnorOFF = [[NSUserDefaults standardUserDefaults] boolForKey:@"DGswitch"];
    if (isDGSwitchOnorOFF) {
        [self.dailyGoalSwitch setOn:isDGSwitchOnorOFF animated:YES];
    }
    self.title = @"Settings";
    self.navigationController.navigationBar.tintColor = [UIColor orangeColor];
}

- (void)clearAllData
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"clearLabels" object:nil];
    Day *clearDays = [[Day alloc] init];
    [clearDays deleteAllDatesFromCoreData];
}

- (void)changeDailyGoalCheck
{
    if ([self.alertTextField.text isEqualToString:@"0"]) {
        UIAlertController *alertController = [UIAlertController
                                              alertControllerWithTitle:@"Error"
                                              message:@"This Is An Invaild Input, Please Try Again"
                                              preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                                   style:UIAlertActionStyleDefault
                                   handler:nil];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:self.alertTextField.text forKey:@"cigValueToSave"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"updateDaily" object:nil];
    }
}

- (IBAction)dataClearButton:(id)sender
{
    NSString *alertTitle = @"Clear All Data";
    NSString *alertMessage = @"Are You Sure You Want To Clear All Data";
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:alertTitle
                                          message:alertMessage
                                          preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel action")
                                   style:UIAlertActionStyleCancel
                                   handler:nil];
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   [self clearAllData];
                               }];
    [alertController addAction:cancelAction];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
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

- (IBAction)changeDailyGoalButton:(id)sender
{
    UIAlertController *firstTimeAlert = [UIAlertController alertControllerWithTitle:@"Edit Daily Goal"
                                                                            message:@"Lets Change That Daily Goal. Enter In The Textfield Below What You Want You New Goal To Be"
                                                                     preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *firstTimeAction = [UIAlertAction actionWithTitle:@"OK"
                                                              style:UIAlertActionStyleDefault
                                                            handler:^(UIAlertAction * _Nonnull action)
                                                            {
                                                                [self changeDailyGoalCheck];
                                                            }];
    [firstTimeAlert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        self.alertTextField = textField;
        textField.keyboardType = UIKeyboardTypeNumberPad;
    }];
    [firstTimeAlert addAction:firstTimeAction];
    [self presentViewController:firstTimeAlert animated:YES completion:nil];
}

- (IBAction)dailyGoalSwitchAction:(id)sender
{
    UISwitch *mySwitch = (UISwitch *)sender;
    if ([mySwitch isOn]) {
        self.isDailyGoalSwitchON = YES;
        [[NSUserDefaults standardUserDefaults] setBool:self.isDailyGoalSwitchON forKey:@"DGswitch"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } else {
        self.isDailyGoalSwitchON = NO;
        [[NSUserDefaults standardUserDefaults] setBool:self.isDailyGoalSwitchON forKey:@"DGswitch"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
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
