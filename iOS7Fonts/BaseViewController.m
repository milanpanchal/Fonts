//
//  BaseViewController.m
//  iOS7Fonts
//
//  Created by MilanPanchal on 21/01/15.
//  Copyright (c) 2015 Pantech. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController () {

    
}
@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:IMG_BG]]];

    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
        self.edgesForExtendedLayout = UIRectEdgeNone;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
