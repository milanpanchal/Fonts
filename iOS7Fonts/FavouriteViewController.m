//
//  FavouriteViewController.m
//  iOS7Fonts
//
//  Created by Milan Kumar Panchal on 17/01/14.
//  Copyright (c) 2014 Pantech. All rights reserved.
//

#import "FavouriteViewController.h"
#import "AppDelegate.h"
#import "Constants.h"

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

    [self.tblView setBackgroundColor:[UIColor clearColor]];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:IMG_BG]]];

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
        cell.backgroundColor = [UIColor clearColor];
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

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [appDelegate removeFontFromFavourite:cell.textLabel.text];
        
        favouriteFonts  = [appDelegate getAllFavouriteFonts];
        [_tblView reloadData];

    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //1. Setup the CATransform3D structure
    CATransform3D rotation;
    rotation = CATransform3DMakeRotation( (90.0*M_PI)/180, 0.0, 0.7, 0.4);
    rotation.m34 = 1.0/ -600;
    
    
    //2. Define the initial state (Before the animation)
    cell.layer.shadowColor = [[UIColor blackColor]CGColor];
    cell.layer.shadowOffset = CGSizeMake(10, 10);
    cell.alpha = 0;
    
    cell.layer.transform = rotation;
    cell.layer.anchorPoint = CGPointMake(0, 0.5);
    
    
    //3. Define the final state (After the animation) and commit the animation
    [UIView beginAnimations:@"rotation" context:NULL];
    [UIView setAnimationDuration:0.8];
    cell.layer.transform = CATransform3DIdentity;
    cell.alpha = 1;
    cell.layer.shadowOffset = CGSizeMake(0, 0);
    [UIView commitAnimations];
    
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
