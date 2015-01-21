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

#define IMAGEVIEW_TAG 12321

@interface ViewController () {
    AppDelegate *appDelegate;
    NSMutableDictionary *fontDictonary;
    NSUInteger totalFonts, totalFilteredFonts;

    UISearchBar *fontSearchBar;
    NSMutableDictionary *filteredDictonary;
    
    BOOL keyboardVisible, iSFiltered;

    UIBarButtonItem *searchBarButton;
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

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    // register for keyboard notifications
    [_tblView reloadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
	keyboardVisible = iSFiltered = NO;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    appDelegate     = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    fontDictonary       = [[NSMutableDictionary alloc] init];
    filteredDictonary   = [[NSMutableDictionary alloc] init];

    [self setupFonts];
    
    fontSearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    fontSearchBar.delegate          = self;
    fontSearchBar.placeholder       = @"Search Fonts";
    fontSearchBar.showsCancelButton = NO;
    fontSearchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.tblView.tableHeaderView = fontSearchBar;
    
    [self addNavigationBarRightButton];
    
    [self.tblView setBackgroundColor:[UIColor clearColor]];
    

    
}

- (void)viewWillDisappear:(BOOL)animated {

    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Font Setup

- (void)setupFonts {

    NSArray *fontFamilies = [[UIFont familyNames] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];

    for (NSString *fontFamilyName in fontFamilies) {
        NSArray *fontNames = [UIFont fontNamesForFamilyName:fontFamilyName];
        [fontDictonary setObject:fontNames forKey:fontFamilyName];
        totalFonts += [fontNames count];
    }
}

#pragma mark - Navigation Setup

- (void)addNavigationBarRightButton {
    
    searchBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(searchBarClicked:)];
    self.navigationItem.rightBarButtonItem = searchBarButton;
    
}
- (void)searchBarClicked:(id)sender {
    
    [fontSearchBar becomeFirstResponder];
    [self.tblView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:YES];
    
}


#pragma mark - UITableView DataSource/Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (iSFiltered) {
        return [[filteredDictonary allKeys] count];
    }else {

        return [[fontDictonary allKeys] count];
    }
    

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSArray *fontNames;
    if (iSFiltered) {
        
        fontNames = [filteredDictonary objectForKey:[[[filteredDictonary allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:section]];

    } else {
        
        fontNames = [fontDictonary objectForKey:[[[fontDictonary allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:section]];
    }
    return [fontNames count];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.backgroundColor = [UIColor clearColor];
    }

    NSArray *fontNames;

    if (iSFiltered) {
        fontNames = [filteredDictonary objectForKey:[[[filteredDictonary allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:indexPath.section]];

    } else {
        fontNames = [fontDictonary objectForKey:[[[fontDictonary allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:indexPath.section]];
    }
    
    cell.textLabel.text = [fontNames objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont fontWithName:[fontNames objectAtIndex:indexPath.row] size:12.00f];

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
    
    if (iSFiltered) {
        return [[[filteredDictonary allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:section];
    }else {
        return [[[fontDictonary allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] objectAtIndex:section];

    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    FontDetailViewController *fontDetailVC = [[FontDetailViewController alloc] initWithNibName:@"FontDetailViewController" bundle:nil];
    [self.navigationController pushViewController:fontDetailVC animated:YES];
    
    fontDetailVC.fontNameString         = [[cell textLabel] text];

}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
    if (section == [tableView numberOfSections]-1) {
        return [NSString stringWithFormat:@"\t\t\tTotal Fonts : %lu", ([fontSearchBar isFirstResponder] ? (unsigned long)totalFilteredFonts :  (unsigned long)totalFonts)];
    }
    
    return nil;
    
}

#pragma mark - GestureRecognizer

-(void)tapOnFavouriteImage:(UITapGestureRecognizer *) gesture {
    
    //Check if gesture came from UIImageView Class or not
    if ([gesture.view isKindOfClass:[UIImageView class]]) {
        UIImageView *imageView = (UIImageView*)gesture.view;
       
        // Get ImageView Text
        UITableViewCell *cell;
        if ([imageView.superview.superview.superview isKindOfClass:[UITableViewCell class]]) {
            cell = (UITableViewCell*)[[[imageView superview]superview] superview];
      
        }else if ([imageView.superview.superview isKindOfClass:[UITableViewCell class]]) {
            cell = (UITableViewCell*)[[imageView superview]superview];
       
        }else {
            return;
        }

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



#pragma mark - UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    iSFiltered = YES;
    searchBar.showsCancelButton = YES;
    searchBar.text = nil;
    [filteredDictonary setDictionary:fontDictonary];
    totalFilteredFonts = totalFonts;

    [_tblView reloadData];
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *) searchBar {

    iSFiltered = NO;

    searchBar.showsCancelButton = NO;
    searchBar.text = nil;
    [searchBar resignFirstResponder];
    [_tblView reloadData];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
//    searchBar.showsCancelButton = NO;
//    searchBar.text = nil;
    iSFiltered = YES;
    [searchBar resignFirstResponder];

}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {

    // Reset Dictionary
    [filteredDictonary removeAllObjects];
    
    if (searchText == nil || [searchText isEqualToString:@""]) {
        [filteredDictonary setDictionary:fontDictonary];
        totalFilteredFonts = totalFonts;
        
    }else {

        totalFilteredFonts = 0;
        for (NSString *key in [fontDictonary allKeys]) {
            NSArray *fontsOfFamily = (NSArray*)[fontDictonary objectForKey:key];
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains[cd] %@",searchText];
            NSArray *array = [fontsOfFamily filteredArrayUsingPredicate:predicate];
            totalFilteredFonts += [array count];
            
            if ([array count]>0) {
                [filteredDictonary setObject:array forKey:key];
            }
            
        }
        
    
    }
    
    [_tblView reloadData];
}

#pragma mark - NSNotifications


-(void)keyboardWillShow:(NSNotification *)notification{
	
    NSLog(@"Keyboard is shown.");

	if (keyboardVisible) {
		return;
	}
	
    
    // Get the size of the keyboard from the userInfo dictionary.
    NSDictionary *keyboardInfo = [notification userInfo];
    CGSize keyboardSize = [[keyboardInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    
    self.constraintBottomScrollView.constant = keyboardSize.height - appDelegate.tabBarController.tabBar.frame.size.height;

    [self.view setNeedsUpdateConstraints];
    [UIView animateWithDuration:0.25f animations:^{
        [self.view layoutIfNeeded];
    }];

    
    keyboardVisible = YES;
    
}

-(void)keyboardWillHide:(NSNotification *)notification{
    
	if (!keyboardVisible) {
		return;
	}
    
    self.constraintBottomScrollView.constant = 0;

    [self.view setNeedsUpdateConstraints];
    [UIView animateWithDuration:0.25f animations:^{
        [self.view layoutIfNeeded];
    }];
    
	keyboardVisible = NO;
	
}



@end
