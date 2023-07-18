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
        // Khởi tạo và gán giá trị cho context
        sharedInstance.context = [(AppDelegate *)[UIApplication sharedApplication].delegate persistentContainer].viewContext;
    });
    return sharedInstance;
}

- (void)createItem:(Result *)result {
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

- (void)getAllItems:(void (^)(NSArray<Favorites *> *items))completion {
    NSFetchRequest *fetchRequest = [Favorites fetchRequest];
    NSError *error = nil;
    
    NSArray<Favorites *> *fetchedItems = [self.context executeFetchRequest:fetchRequest error:&error];
    
    if (error) {
        NSLog(@"Lỗi khi lấy dữ liệu: %@", error);
        if (completion) {
            completion(nil);
        }
    } else {
        completion(fetchedItems);
    }
}

- (void)removeItem:(Result *)result {
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

- (BOOL)interateItem:(NSNumber *) idResult {
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Favorites"];
    NSError *error = nil;
    NSArray *results = [self.context executeFetchRequest:fetchRequest error:&error];
    
    if (![self.context save:&error]) {
        return NO;
    } else {
        for (NSManagedObject *object in results) {
            NSNumber *iD = [object valueForKey:@"iD"];
            if(idResult == iD) {
                return YES;
            }
        }
    }
    return NO;
}

- (void)removeAllItem {
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
@end
