//
//  FeatureViewController.m
//  iOS7Fonts
//
//  Created by Milan Kumar Panchal on 27/01/14.
//  Copyright (c) 2014 Pantech. All rights reserved.
//

#import "FeatureViewController.h"
#import "Constants.h"
#import "BarcodeViewController.h"
#import "FilterViewController.h"

@interface FeatureViewController () {

    NSArray *featureList;
}

@end

@implementation FeatureViewController

#pragma mark - View life cycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // set tab title
        self.title = @"Features";
        
        // Set different title for navigation controller
        // Note: self.title will reset Nav Title. Use it first if you want different titles
        
        self.navigationItem.title = @"Features";
        [self.tabBarItem setImage:[[UIImage imageNamed:@"Feature"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:IMG_BG]]];
    [self.tblView setBackgroundColor:[UIColor clearColor]];
    
    featureList = @[@"Barcode Scanning",@"Image Filtering"];
}

-(void)viewWillAppear:(BOOL)animated {
    
    if ([_tblView indexPathForSelectedRow] != nil) {
        NSIndexPath *indexPath = [_tblView indexPathForSelectedRow];
        [_tblView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView DataSource/Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [featureList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.backgroundColor = [UIColor clearColor];

    }
    
    
    cell.textLabel.text = [featureList objectAtIndex:indexPath.row];
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.row == 0) {
        BarcodeViewController *barCodeVC = [[BarcodeViewController alloc] initWithNibName:@"BarcodeViewController" bundle:nil];
        [self.navigationController pushViewController:barCodeVC animated:YES];
        
    }else if (indexPath.row == 1){
        FilterViewController *filterVC = [[FilterViewController alloc] initWithNibName:NSStringFromClass([FilterViewController class]) bundle:nil];
        [self.navigationController pushViewController:filterVC animated:YES];
    }
}


@end
