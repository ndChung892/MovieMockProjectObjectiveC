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

#ifndef CoreDataManager_h
#define CoreDataManager_h


#endif /* CoreDataManager_h */

@interface CoreDataManager: NSObject
+ (instancetype)sharedInstance;

- (void)createItem:(Result *)result;
- (void)getAllItems:(void (^)(NSArray<Favorites *> *items))completion;
- (void)removeItem:(Result *)result;
- (BOOL)interateItem:(NSNumber *) idResult;
- (void)removeAllItem;
@end
