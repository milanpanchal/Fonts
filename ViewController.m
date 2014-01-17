//
//  ViewController.m
//  iOS7Fonts
//
//  Created by Milan Kumar Panchal on 14/01/14.
//  Copyright (c) 2014 Pantech. All rights reserved.
//

#import "ViewController.h"
#import "FontDetailViewController.h"

@interface ViewController () {
    NSArray *fontFamilyNames;
}

@end

@implementation ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

        // set tab title
        self.title = @"All Fonts";
        
        // Set different title for navigation controller
        // Note: self.title will reset Nav Title. Use it first if you want different titles
        
        self.navigationItem.title = @"Available All Fonts on iPhone";
        [self.tabBarItem setImage:[[UIImage imageNamed:@"all_30"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    fontFamilyNames = [[UIFont familyNames] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
}

-(void)viewWillAppear:(BOOL)animated {
    
    if ([_tblView indexPathForSelectedRow]) {
        [_tblView deselectRowAtIndexPath:[_tblView indexPathForSelectedRow] animated:YES];
    }

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableView DataSource/Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return [fontFamilyNames count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section; {
    NSArray *fontNames = [UIFont fontNamesForFamilyName:[fontFamilyNames objectAtIndex:section]];
    return [fontNames count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }

    NSArray *fontNames = [UIFont fontNamesForFamilyName:[fontFamilyNames objectAtIndex:indexPath.section]];

    cell.textLabel.text = [fontNames objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont fontWithName:[fontFamilyNames objectAtIndex:indexPath.section] size:12.00f];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [fontFamilyNames objectAtIndex:section];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    FontDetailViewController *fontDetailVC = [[FontDetailViewController alloc] initWithNibName:@"FontDetailViewController" bundle:nil];
    
    [self.navigationController pushViewController:fontDetailVC animated:YES];
    
    fontDetailVC.fontFamilyNameString   = [fontFamilyNames objectAtIndex:indexPath.section];
    fontDetailVC.fontNameString         = [[cell textLabel] text];
}

//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
//
//    return [[UILocalizedIndexedCollation currentCollation] sectionIndexTitles];
//}
//
//- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
//
//    //sectionForSectionIndexTitleAtIndex: is a bit buggy, but is still useable
//    return [[UILocalizedIndexedCollation currentCollation] sectionForSectionIndexTitleAtIndex:index];
//}

@end
