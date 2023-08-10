//
//  CoreDataManager.m
//  MockProjectObjectiveC
//
//  Created by Chung on 13/07/2023.
//

#import <Foundation/Foundation.h>
#import "CoreDataManager.h"

@interface CoreDataManager()
@property (nonatomic, strong) NSManagedObjectContext *context;

@property (nonatomic) NSMutableArray<Result *> *favoriteArr;

@end

@implementation CoreDataManager

+ (instancetype)sharedInstance {
    static CoreDataManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[CoreDataManager alloc] init];
        // Declare Context
        sharedInstance.context = [(AppDelegate *)[UIApplication sharedApplication].delegate persistentContainer].viewContext;
    });
    return sharedInstance;
}

#pragma mark - Favorites Movies
- (void)createFavorites:(Result *)result {
    Favorites *newItem = (Favorites *)[NSEntityDescription insertNewObjectForEntityForName:@"Favorites" inManagedObjectContext:self.context];
    newItem.title = result.title;
    newItem.rating = [result.rating floatValue];
    newItem.releaseDate = result.releaseDate;
    newItem.imgUrl = result.imgURL;
    newItem.overview = result.overView;
    newItem.iD = [result.iD integerValue];
    NSError *error = nil;
    if (![self.context save:&error]) {
        NSLog(@"Lỗi khi lưu dữ liệu: %@", error);
    } else {
    }
}

- (void)getAllFavorites:(void (^)(NSArray<Favorites *> *items))completion {
    NSFetchRequest *fetchRequest = [Favorites fetchRequest];
    NSError *error = nil;
    
    NSArray *fetchedItems = [self.context executeFetchRequest:fetchRequest error:&error];
    
    if (error) {
        NSLog(@"Lỗi khi lấy dữ liệu: %@", error);
        if (completion) {
            completion(nil);
        }
    } else {
        completion(fetchedItems);
    }
}

- (void)removeFavorites:(Result *)result {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Favorites"];
    NSError *error = nil;
    NSArray *results = [self.context executeFetchRequest:fetchRequest error:&error];
    
    for (NSManagedObject *object in results) {
        NSNumber *iD = [object valueForKey:@"iD"];
        if ([result.iD isEqualToNumber:iD]) {
            [self.context deleteObject:object];
        }
    }
    NSError *saveError = nil;
    if (![self.context save:&saveError]) {
        NSLog(@"Lỗi khi xóa dữ liệu: %@", saveError);
    }
}

- (BOOL)interateFavorites:(NSNumber *) idResult {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Favorites"];
    NSError *error = nil;
    NSArray *results = [self.context executeFetchRequest:fetchRequest error:&error];
    
    if (![self.context save:&error]) {
        return NO;
    } else {
        for (NSManagedObject *object in results) {
            NSNumber *iD = [object valueForKey:@"iD"];
            if([iD compare:idResult] == NSOrderedSame) {
                return YES;
            }
        }
    }
    return NO;
}

- (void)getIDFavorites {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Favorites"];
    NSError *error = nil;
    NSArray *results = [self.context executeFetchRequest:fetchRequest error:&error];
    
    if (![self.context save:&error]) {
    } else {
        for (NSManagedObject *object in results) {
            NSNumber *iD = [object valueForKey:@"iD"];
            NSLog(@"Favorite ID: %@", iD);
        }
    }
}

- (void)removeAllFavorites {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Favorites"];
    [fetchRequest setIncludesPropertyValues:NO]; //only fetch the managedObjectID
    
    NSError *error;
    NSArray *fetchedObjects = [self.context executeFetchRequest:fetchRequest error:&error];
    for (NSManagedObject *object in fetchedObjects)
    {
        [self.context deleteObject:object];
    }
    
    error = nil;
    [self.context save:&error];
}

#pragma mark - Reminder
- (void)createReminder:(Result *)result withReminderTime:(NSDate *)reminderTime {
    Reminders *newItem = (Reminders *)[NSEntityDescription insertNewObjectForEntityForName:@"Reminders" inManagedObjectContext:self.context];
    newItem.title = result.title;
    newItem.rating = [result.rating floatValue];
    newItem.releaseDate = result.releaseDate;
    newItem.imgUrl = result.imgURL;
    newItem.overview = result.overView;
    newItem.iD = [result.iD integerValue];
    newItem.reminderTime = reminderTime;
    NSError *error = nil;
    if (![self.context save:&error]) {
        NSLog(@"Lỗi khi lưu dữ liệu: %@", error);
    } else {
    }
}

- (void)getAllReminders:(void (^)(NSArray<Reminders *> *items))completion {
    NSFetchRequest *fetchRequest = [Reminders fetchRequest];
    NSError *error = nil;
    
    NSArray<Reminders *> *fetchedItems = [self.context executeFetchRequest:fetchRequest error:&error];
    
    if (error) {
        NSLog(@"Lỗi khi lấy dữ liệu: %@", error);
        if (completion) {
            completion(nil);
        }
    } else {
        completion(fetchedItems);
    }
}

- (void)removeAllReminders {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"Reminders"];
    [fetchRequest setIncludesPropertyValues:NO];
    
    NSError *error;
    NSArray *fetchedObjects = [self.context executeFetchRequest:fetchRequest error:&error];
    for (NSManagedObject *object in fetchedObjects)
    {
        [self.context deleteObject:object];
    }
    
    error = nil;
    [self.context save:&error];
}

- (void)checkReminders:(NSDate *)currentTime {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Reminders"];
    NSError *error = nil;
    NSArray *reminders = [self.context executeFetchRequest:fetchRequest error:&error];
    NSError *saveError = nil;
    if (![self.context save:&saveError]) {
        NSLog(@"Lỗi khi xóa dữ liệu: %@", saveError);
    } else {
        for (NSManagedObject *object in reminders) {
            NSDate *reminder = [object valueForKey:@"reminderTime"];
            NSLog(@"%@curent reminder Time:", currentTime);
            BOOL compareTime = [[NSCalendar currentCalendar] isDate:currentTime equalToDate:reminder toUnitGranularity:NSCalendarUnitMinute];
            if (compareTime) {
                [self.context deleteObject:object];
            }
        }
    }
}


- (BOOL)interateReminders:(NSNumber *)iD {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Reminders"];
    NSError *error = nil;
    NSArray *reminders = [self.context executeFetchRequest:fetchRequest error:&error];
    
    if (![self.context save:&error]) {
        return NO;
    } else {
        for (NSManagedObject *object in reminders) {
            NSNumber *iDReminders = [object valueForKey:@"iD"];
            if ([iDReminders isEqualToNumber:iD]) {
                return YES;
            }
        }
    }
    return NO;
}

- (NSDate *)getReminderDate:(NSNumber *)iD {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Reminders"];
    NSError *error = nil;
    NSArray *reminders = [self.context executeFetchRequest:fetchRequest error:&error];
    
    if (![self.context save:&error]) {
    } else {
        for (NSManagedObject *object in reminders) {
            NSNumber *iD = [object valueForKey:@"iD"];
            if ([iD isEqualToNumber:iD]) {
                return [object valueForKey:@"reminderTime"];
            }
        }
    }
    return nil;
}

- (void)removeReminder:(NSNumber *)resultId {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Reminders"];
    NSError *error = nil;
    NSArray *results = [self.context executeFetchRequest:fetchRequest error:&error];
    
    for (NSManagedObject *object in results) {
        NSNumber *iD = [object valueForKey:@"iD"];
        if ([resultId isEqualToNumber:iD]) {
            [self.context deleteObject:object];
        }
    }
    NSError *saveError = nil;
    if (![self.context save:&saveError]) {
        NSLog(@"Lỗi khi xóa dữ liệu: %@", saveError);
    }
}

- (void)updateReminderDate:(NSNumber *)resultId withDate:(NSDate *)date {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Reminders"];
    NSError *error = nil;
    NSArray *results = [self.context executeFetchRequest:fetchRequest error:&error];
    for (NSManagedObject *object in results) {
        NSNumber *iD = [object valueForKey:@"iD"];
        if ([resultId isEqualToNumber:iD]) {
            [object setValue:date forKey:@"reminderTime"];
        }
    }
    NSError *saveError = nil;
    if (![self.context save:&saveError]) {
        NSLog(@"Lỗi khi lưu thay đổi: %@", saveError);
    }
    
}

- (BOOL)isExistReminder {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Reminders"];
    NSError *error = nil;
    NSInteger count = [self.context countForFetchRequest:fetchRequest error:&error];
    if (![self.context save:&error]) {
        return NO;
    } else {
        if(count != 0) {
            return YES;
        }
    }
    return NO;
}
@end
