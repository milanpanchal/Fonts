//
//  ViewController.m
//  iOS7Fonts
//
//  Created by Milan Kumar Panchal on 14/01/14.
//  Copyright (c) 2014 Pantech. All rights reserved.
//

#import "ViewController.h"
#import "FontDetailViewController.h"
#import "AppDelegate.h"


@interface ViewController () {
    NSArray *fontFamilyNames;
    AppDelegate *appDelegate;
}

@end



@implementation ViewController

#pragma mark - UIView life cycle

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
    appDelegate     = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
}

-(void)viewWillAppear:(BOOL)animated {
    
    if ([_tblView indexPathForSelectedRow]) {
        [_tblView deselectRowAtIndexPath:[_tblView indexPathForSelectedRow] animated:YES];
    }
    [_tblView reloadData];
    
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

    cell.imageView.userInteractionEnabled = YES;
    
    if ([appDelegate isFontPresentInFavList:cell.textLabel.text]) {
        cell.imageView.tag = 1;
        cell.imageView.image = [UIImage imageNamed:@"favorite_star_filled_30"];

    }else{
        cell.imageView.tag = 0;
        cell.imageView.image = [UIImage imageNamed:@"favorite_star_30"];

    }
    cell.contentMode = UIViewContentModeScaleAspectFit;
    
    UITapGestureRecognizer *tapped = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapOnFavouriteImage:)];
    tapped.numberOfTapsRequired = 1;
    [cell.imageView addGestureRecognizer:tapped];

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

#pragma mark - GestureRecognizer

-(void)tapOnFavouriteImage:(UITapGestureRecognizer *) gesture {
    
    //Check if gesture came from UIImageView Class or not
    if ([gesture.view isKindOfClass:[UIImageView class]]) {
        UIImageView *imageView = (UIImageView*)gesture.view;
       
        // Get ImageView Text
        if ([imageView.superview.superview.superview isKindOfClass:[UITableViewCell class]]) {
            UITableViewCell *cell = (UITableViewCell*)[[[imageView superview]superview]superview];
            
            if (imageView.tag) {
                imageView.image = [UIImage imageNamed:@"favorite_star_30"];
                imageView.tag = 0;
                [appDelegate removeFontFromFavourite:cell.textLabel.text];
            }else{
                imageView.image = [UIImage imageNamed:@"favorite_star_filled_30"];
                imageView.tag = 1;
                [appDelegate addFontToFavourite:cell.textLabel.text];
                
            }
            

        }
        
        
    }

    

}


@end
