//
//  SLAboutViewController.m
//  MockProjectObjectiveC
//
//  Created by Chung on 21/06/2023.
//

#import "SLAboutViewController.h"
#import "MockProjectObjectiveC-Bridging-Header.h"
#import "Configuration.h"

#pragma mark - SLAboutViewController
@interface SLAboutViewController ()
@property (weak, nonatomic) IBOutlet WKWebView *webview;

@end

@implementation SLAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"About"];
    // Do any additional setup after loading the view from its nib.
    NSURL *targetURL = [NSURL URLWithString:aboutURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:targetURL];
    [self.webview loadRequest:request];
}


@end
