//
//  Day.h
//  CleanUrLungs
//
//  Created by Thomas Prezioso on 1/25/16.
//  Copyright © 2016 Thomas Prezioso. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Day : NSObject

@property (strong, nonatomic) NSString *date;
@property (strong, nonatomic) NSString *smokeValue;
@property (strong, nonatomic) NSString *craveTotal;
@property (strong, nonatomic) NSString *dailyGoal;
- (instancetype)initWithDate:(NSString *)date smokeValue:(NSString *)smokeValue dailyGoal:(NSString *)dailyGoal;
- (void)saveDate:(NSString *)dateToSave smokeSaved:(NSString *)smokeSaved dailyGoalSaved:(NSString *)dailyGoalSaved;
- (Day *)retriveDate;
- (NSMutableArray *)retriveDates;

@end
