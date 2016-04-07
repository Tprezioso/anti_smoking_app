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

@end

@implementation SettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
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

}

@end
