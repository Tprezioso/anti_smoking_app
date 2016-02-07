//
//  Day.m
//  CleanUrLungs
//
//  Created by Thomas Prezioso on 1/25/16.
//  Copyright © 2016 Thomas Prezioso. All rights reserved.
//

#import "Day.h"
#import "AppDelegate.h"
#import <CoreData/CoreData.h>

@implementation Day

- (void)saveDate:(NSString *)dateToSave smokeSaved:(NSString *)smokeSaved dailyGoalSaved:(NSString *)dailyGoalSaved
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSManagedObject *newDevice = [NSEntityDescription insertNewObjectForEntityForName:@"Date" inManagedObjectContext:context];
    [newDevice setValue:dateToSave forKey:@"dateSaved"];
    [newDevice setValue:smokeSaved forKey:@"smokedNumber"];
    [newDevice setValue:dailyGoalSaved forKey:@"dailyGoal"];
    NSError *error = nil;

    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
    NSLog(@"DAY SAVED");
}

- (void)retriveDate
{
    NSMutableArray *days = [[NSMutableArray alloc] init];
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Date"];
    days = [[context executeFetchRequest:fetchRequest error:nil] mutableCopy];
    for (NSInteger i = 0; i < [days count]; i++) {
        Day *savedDay = [Day new];
        savedDay.date = [days[i] valueForKey:@"dateSaved"];
        savedDay.smokeTotal = [days[i] valueForKey:@"smokedNumber"];
        savedDay.dailyGoal = [days[i] valueForKey:@"dailyGoal"];
    }
    NSLog(@"DAY RETRIVED");
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

@end
