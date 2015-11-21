//
//  ViewController.m
//  CleanUrLungs
//
//  Created by Thomas Prezioso on 11/16/15.
//  Copyright © 2015 Thomas Prezioso. All rights reserved.
//

#import "ViewController.h"
#import <CoreData/CoreData.h>

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
    self.smokedLabel.textColor = [UIColor greenColor];
    if ([self isFirstTimeInApp]) {
        [self setUpAlert];
        //[self saveCig];
      
    }
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Tally"];
   
    NSMutableArray *dailyGoalDic = [[NSMutableArray alloc] init];
    NSString *savedCigs = @"";
    dailyGoalDic = [[context executeFetchRequest:fetchRequest error:nil] mutableCopy];
    for (NSInteger i = 0; i < [dailyGoalDic count]; i++) {
        self.dailyGoalLabel.text = dailyGoalDic[i];
    }
    //self.dailyGoalLabel.text = savedCigs;

}

- (BOOL)isFirstTimeInApp
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"isFirstRun"])
    {
        return NO;
    }
    [defaults setObject:[NSDate date] forKey:@"isFirstRun"];
    [[NSUserDefaults standardUserDefaults] synchronize];
   
    return YES;
}

- (void)setUpAlert
{
    UIAlertController *firstTimeAlert = [UIAlertController alertControllerWithTitle:@"Welcome to CleanUrLungs" message:@"Lets get started by Finding out how many Cigarttees you smoke" preferredStyle:UIAlertControllerStyleAlert];
//    //dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        UIAlertAction *firstTimeAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            //self.dailyGoalLabel.text = self.alertTextField.text;
//            NSManagedObjectContext *context = [self managedObjectContext];
//            NSManagedObject *newDevice = [NSEntityDescription insertNewObjectForEntityForName:@"Tally" inManagedObjectContext:context];
//            [newDevice setValue:self.alertTextField.text forKey:@"smokeCount"];
//            
//            //NSManagedObjectContext *context = [self managedObjectContext];
//            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Tally"];
//            NSMutableArray *dailyGoalDic = [[NSMutableArray alloc] init];
//            
//            dailyGoalDic = [[context executeFetchRequest:fetchRequest error:nil] mutableCopy];
//            for (NSInteger i = 0; i < [dailyGoalDic count]; i++) {
//                [dailyGoalDic[i] setValue:self.dailyGoalLabel.text forKey:@"smokeCount"];
//            }
//
//            
//            NSError *error = nil;
//            if (![context save:&error]) {
//                NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
//            }
//            
//        }];
//        
//        [firstTimeAlert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
//            self.alertTextField = textField;
//            NSLog(@"%@", textField);
//        }];
//
//        [firstTimeAlert addAction:firstTimeAction];
//
//        
    
    //});
    UIAlertAction *firstTimeAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.dailyGoalLabel.text = self.alertTextField.text;
        [self saveCig];
    }];
    
    [firstTimeAlert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        self.alertTextField = textField;
        NSLog(@"%@", textField);
    }];
    [firstTimeAlert addAction:firstTimeAction];
    [self presentViewController:firstTimeAlert animated:YES completion:nil];

}

- (void)saveCig
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSManagedObject *newDevice = [NSEntityDescription insertNewObjectForEntityForName:@"Tally" inManagedObjectContext:context];
   // NSString *toSaveCig = self.dailyGoalLabel.text;
    [newDevice setValue:self.alertTextField.text forKey:@"smokeCount"];
    
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }

}

- (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (IBAction)cravingButton:(id)sender
{
    self.cravingLabel.text = [NSString stringWithFormat:@"%d", [self.cravingLabel.text intValue]+1];
}

- (IBAction)smokedButton:(id)sender
{
    self.smokedLabel.text = [NSString stringWithFormat:@"%d", [self.smokedLabel.text intValue]+1];
    if ([self.smokedLabel.text isEqualToString:self.dailyGoalLabel.text]) {
        self.smokedLabel.textColor = [UIColor redColor];
    }
    [UIApplication sharedApplication].applicationIconBadgeNumber = [self.smokedLabel.text intValue];
}

@end
