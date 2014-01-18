//
//  FavouriteViewController.m
//  iOS7Fonts
//
//  Created by Milan Kumar Panchal on 17/01/14.
//  Copyright (c) 2014 Pantech. All rights reserved.
//

#import "FavouriteViewController.h"
#import "AppDelegate.h"

@interface FavouriteViewController () {

    AppDelegate *appDelegate ;
    NSArray *favouriteFonts ;
    UIBarButtonItem *barButton;
}

@end

@implementation FavouriteViewController

#pragma mark - UIView life cycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        // set tab title
        self.title = @"Favorite";
        
        // Set different title for navigation controller
        // Note: self.title will reset Nav Title. Use it first if you want different titles

        self.navigationItem.title = @"Favorite Fonts";
        [self.tabBarItem setImage:[[UIImage imageNamed:@"favorite_star_30"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];


    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    appDelegate     = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [self addnavigationBarRightButton];

}

-(void)viewWillAppear:(BOOL)animated {
    
    favouriteFonts  = [appDelegate getAllFavouriteFonts];
    [_tblView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableView DataSource/Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if ([favouriteFonts count] > 0) {
        barButton.enabled = YES ;
    }else{
        barButton.enabled = NO;
    }
        
    return [favouriteFonts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    cell.textLabel.text = [favouriteFonts objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont fontWithName:[favouriteFonts objectAtIndex:indexPath.row] size:12.00f];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Favorite Fonts";
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {

    if ([favouriteFonts count] > 0) {
        return [NSString stringWithFormat:@"Total Fonts : %lu",(unsigned long)[favouriteFonts count]];

    }
    return nil;
    
}

//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
//    return YES;
//}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [appDelegate removeFontFromFavourite:cell.textLabel.text];
        
        favouriteFonts  = [appDelegate getAllFavouriteFonts];
        [_tblView reloadData];

    }
}


#pragma mark - User defined methods

- (void)addnavigationBarRightButton {
    
    barButton = [[UIBarButtonItem alloc]
                               initWithTitle:@"Clear All" style:UIBarButtonItemStyleDone target:self action:@selector(clearAllConfirmationAlert)];
    self.navigationItem.rightBarButtonItem = barButton;
}



- (void)clearAllConfirmationAlert {

    UIAlertView *confirmationDialog = [[UIAlertView alloc] initWithTitle:@"Clear Favorite Font List"
                                                                 message:@"Are you sure you want to clear your favorite font list?"
                                                                delegate:self
                                                       cancelButtonTitle:@"No"
                                                       otherButtonTitles:@"Yes", nil];
    [confirmationDialog show];
}

- (void)clearAll {
    [appDelegate removeAllFontsFromFavourite];
    favouriteFonts = nil;
    [_tblView reloadData];
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

    if (alertView.firstOtherButtonIndex != buttonIndex) {
        return;
    }
    [self clearAll];
}

@end
