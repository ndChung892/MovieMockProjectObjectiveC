//
//  SLLeftMenuViewController.m
//  MockProjectObjectiveC
//
//  Created by Chung on 26/06/2023.
//

#import "SLLeftMenuViewController.h"

#pragma mark - SLLeftMenuViewController
@interface SLLeftMenuViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imgProfile;
@property (weak, nonatomic) IBOutlet UILabel *lblName;

@end

@implementation SLLeftMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imgProfile.layer.cornerRadius = self.imgProfile.frame.size.height/2;
    self.imgProfile.clipsToBounds = YES;
    self.imgProfile.image = [UIImage imageNamed:@"img_profile"];
    self.lblName.text = @"Nguyen Dac Chung";
}

@end
