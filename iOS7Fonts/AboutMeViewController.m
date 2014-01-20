//
//  AboutMeViewController.m
//  iOS7Fonts
//
//  Created by Milan Kumar Panchal on 20/01/14.
//  Copyright (c) 2014 Pantech. All rights reserved.
//

#import "AboutMeViewController.h"
#import <QuartzCore/QuartzCore.h>
//#import <ApplicationServices/ApplicationServices.h>


@interface AboutMeViewController ()

@end


@implementation AboutMeViewController

#pragma mark - View life cycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

        // set tab title
        self.title = @"About Me";
        
        // Set different title for navigation controller
        // Note: self.title will reset Nav Title. Use it first if you want different titles
        
        self.navigationItem.title = @"About Me";
        [self.tabBarItem setImage:[[UIImage imageNamed:@"AboutUs"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [_profilePic.layer setCornerRadius:CGRectGetWidth(_profilePic.frame)/2];
    [_profilePic setClipsToBounds:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
