//
//  SLLeftMenuViewController.h
//  MockProjectObjectiveC
//
//  Created by Chung on 26/06/2023.
//

#import <UIKit/UIKit.h>
#import "SLBaseViewController.h"
#import "SLEditProfileViewController.h"
#import "SLRemindersCollectionViewCell.h"
#import "Reminders+CoreDataClass.h"
#import "Reminders+CoreDataProperties.h"
#import "CoreDataManager.h"

NS_ASSUME_NONNULL_BEGIN
@protocol SLLeftMenuViewControllerDelegate <NSObject>
- (void)showAllButtonClicked;
@end

@interface SLLeftMenuViewController : SLBaseViewController <SLEditProfileViewControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, weak) id<SLLeftMenuViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
