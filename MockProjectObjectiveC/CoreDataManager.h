//
//  CoreDataManager.h
//  MockProjectObjectiveC
//
//  Created by Chung on 13/07/2023.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Result.h"
#import "Favorites+CoreDataClass.h"
#import "Favorites+CoreDataProperties.h"
#import "Reminders+CoreDataClass.h"
#import "Reminders+CoreDataProperties.h"

#ifndef CoreDataManager_h
#define CoreDataManager_h


#endif /* CoreDataManager_h */

@interface CoreDataManager: NSObject
+ (instancetype)sharedInstance;

#pragma mark -  Favorites Movies
- (void)createFavorites:(Result *)result;
- (void)getAllFavorites:(void (^)(NSArray<Favorites *> *items))completion;
- (void)removeFavorites:(Result *)result;
- (BOOL)interateFavorites:(NSNumber *) idResult;
- (void)removeAllFavorites;
- (void)getIDFavorites;

#pragma mark - Reminders
- (void)createReminder:(Result *)result withReminderTime:(NSDate *)reminderTime;
- (void)getAllReminders:(void (^)(NSArray<Reminders *> *items))completion;
- (void)removeAllReminders;
//- (void)removeReminders:(NSDate *)reminderTime withTitle:(NSString *)title;
- (BOOL)interateReminders:(NSNumber *)iD;
- (NSDate *)getReminderDate:(NSNumber *)iD;
- (void)checkReminders:(NSDate *)currentTime;
- (BOOL)isExistReminder;

@end
