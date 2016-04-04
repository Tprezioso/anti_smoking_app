//
//  CalendarViewController.h
//  CleanUrLungs
//
//  Created by Thomas Prezioso on 11/17/15.
//  Copyright © 2015 Thomas Prezioso. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Day.h"
#import <FSCalendar/FSCalendar.h>

@interface CalendarViewController : UIViewController 

@property (strong, nonatomic)Day *currentDayData;

@end
