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

- (instancetype)initWithDate:(NSString *)date smokeValue:(NSString *)smokeValue dailyGoal:(NSString *)dailyGoal
{
    self = [super init];
    if (self) {
        _date = date;
        _smokeValue = smokeValue;
        _dailyGoal = dailyGoal;
    }
    return self;
}

- (void)saveDate:(NSString *)dateToSave smokeSaved:(NSString *)smokeSaved dailyGoalSaved:(NSString *)dailyGoalSaved
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSManagedObject *newDevice = [NSEntityDescription insertNewObjectForEntityForName:@"Date" inManagedObjectContext:context];
    [newDevice setValue:dateToSave forKey:@"dateSaved"];
    [newDevice setValue:smokeSaved forKey:@"smokedValue"];
    [newDevice setValue:dailyGoalSaved forKey:@"dailyGoal"];
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
}

- (Day *)retriveDate
{
    NSMutableArray *days = [[NSMutableArray alloc] init];
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Date"];
    days = [[context executeFetchRequest:fetchRequest error:nil] mutableCopy];
    Day *savedDay = [Day new];
    for (NSInteger i = 0; i < [days count]; i++) {
        savedDay.date = [days[i] valueForKey:@"dateSaved"];
        savedDay.smokeValue = [days[i] valueForKey:@"smokedValue"];
        savedDay.dailyGoal = [days[i] valueForKey:@"dailyGoal"];
    }
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
    Day *returnDay = savedDay;
    return returnDay;
}

- (NSMutableArray *)retriveDates
{
    NSMutableArray *days = [[NSMutableArray alloc] init];
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Date"];
    days = [[context executeFetchRequest:fetchRequest error:nil] mutableCopy];
    Day *savedDay = [Day new];
    for (NSInteger i = 0; i < [days count]; i++) {
        savedDay.date = [days[i] valueForKey:@"dateSaved"];
        savedDay.smokeValue = [days[i] valueForKey:@"smokedValue"];
        savedDay.dailyGoal = [days[i] valueForKey:@"dailyGoal"];
    }
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
    }
    return days;
}

// - (void)deleteAllDatesFromCoreData
// {
//     NSMutableArray *removedDaysArray = [[NSMutableArray alloc] init];
//     NSManagedObjectContext *context = [self managedObjectContext];
//     NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Date"];
//     removedDaysArray = [[context executeFetchRequest:fetchRequest error:nil] mutableCopy];
//     for (NSInteger i = 0; i < [removedDaysArray count]; i++) {
//         [context deleteObject:removedDaysArray[i]];
//     }
//     NSError *error = nil;
//     if (![context save:&error]) {
//         NSLog(@"Can't Save! %@ %@", error, [error localizedDescription]);
//     }
// }

- (void)checkToSeeIfDateIsSaved:(NSString *)dateInData
{
    NSMutableArray *daysArray = [[NSMutableArray alloc] init];
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Date"];
    daysArray = [[context executeFetchRequest:fetchRequest error:nil] mutableCopy];
    for (NSInteger i = 0; i < [daysArray count]; i++) {
        Day *savedDay = [Day new];
        savedDay.date = [daysArray[i] valueForKey:@"dateSaved"];
        if ([dateInData isEqualToString:savedDay.date]) {
            [context deleteObject:daysArray[i]];
        }
    }
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

@end
