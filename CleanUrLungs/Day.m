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

// Save to core Data
- (void)saveDate:(NSString *)dateToSave smokeSaved:(NSString *)smokeSaved dailyGoalSaved:(NSString *)dailyGoalSaved
{
    
}

// retrieve from core data
- (void)retriveDate
{   

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
