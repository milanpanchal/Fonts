//
//  FavouriteViewController.m
//  iOS7Fonts
//
//  Created by Milan Kumar Panchal on 17/01/14.
//  Copyright (c) 2014 Pantech. All rights reserved.
//

#import "FavouriteViewController.h"

@interface FavouriteViewController ()

@end

@implementation FavouriteViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        // set tab title
        self.title = @"Favourite";
        
        // Set different title for navigation controller
        // Note: self.title will reset Nav Title. Use it first if you want different titles

        self.navigationItem.title = @"Favourite Fonts";
        [self.tabBarItem setImage:[[UIImage imageNamed:@"favorite_star_30"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];


    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
