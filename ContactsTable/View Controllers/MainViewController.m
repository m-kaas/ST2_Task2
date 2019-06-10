//
//  MainViewController.m
//  ContactsTable
//
//  Created by Liubou Sakalouskaya on 6/10/19.
//  Copyright © 2019 Liubou Sakalouskaya. All rights reserved.
//

#import "MainViewController.h"
#import "UIColor+ColorFromHex.h"
#import "UIColor+OnePtImage.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.translucent = NO;
    self.navigationBar.barTintColor = [UIColor colorFromHex:0xFFFFFF];
    self.navigationBar.shadowImage = [[UIColor colorFromHex:0xE6E6E6] onePtImage];
    UIImage *arrowLeftImage = [[UIImage imageNamed:@"arrow_left"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationBar.backIndicatorImage = arrowLeftImage;
    self.navigationBar.backIndicatorTransitionMaskImage = arrowLeftImage;
    [self.navigationBar setTitleTextAttributes:@{
                                                NSForegroundColorAttributeName: [UIColor colorFromHex:0x000000],
                                                NSFontAttributeName: [UIFont systemFontOfSize:17 weight:UIFontWeightSemibold]
                                                }];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

@end
