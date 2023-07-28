//
//  SLEditProfileViewController.h
//  MockProjectObjectiveC
//
//  Created by Chung on 25/07/2023.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class SLEditProfileViewController;
@protocol SLEditProfileViewControllerDelegate <NSObject>
- (void)editProfileViewControllerDidClose:(SLEditProfileViewController *)editVC;
@end

@interface SLEditProfileViewController : UIViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imgProfile;
@property (nonatomic, weak) id<SLEditProfileViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
