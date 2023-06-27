//
//  SLBaseViewController.m
//  MockProjectObjectiveC
//
//  Created by Chung on 27/06/2023.
//

#import "SLBaseViewController.h"
#import <SWRevealViewController.h>

#pragma mark - SLBaseViewController
@interface SLBaseViewController ()

@end

@implementation SLBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIBarButtonItem *menuButon = [[UIBarButtonItem alloc]
                                  initWithImage:[UIImage systemImageNamed:@"text.justify"]
                                  style:UIBarButtonItemStylePlain
                                  target:self.revealViewController
                                  action:@selector(revealToggle:)];
    
    self.navigationItem.leftBarButtonItem = menuButon;
    self.revealViewController.rearViewRevealWidth = (int)[[UIScreen mainScreen]bounds].size.width / 1.3;
    self.revealViewController.rearViewRevealOverdraw = 0;
    self.revealViewController.rearViewRevealDisplacement = 0;
    
}

@end
