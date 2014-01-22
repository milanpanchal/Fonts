//
//  AppDelegate.h
//  iOS7Fonts
//
//  Created by Milan Kumar Panchal on 14/01/14.
//  Copyright (c) 2014 Pantech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "FavouriteViewController.h"
#import "AboutMeViewController.h"
#import "UnicodeViewController.h"

#define kFavourtiteFonts @"kFavouriteFonts"


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) ViewController *viewController;
@property (strong, nonatomic) FavouriteViewController *favViewController;
@property (strong, nonatomic) AboutMeViewController *aboutViewController;
@property (strong, nonatomic) UnicodeViewController *unicodeViewController;

@property (strong, nonatomic) UITabBarController *tabBarController ;

@property (strong, nonatomic) NSMutableArray *favouriteFontsArray;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

- (void)addFontToFavourite:(NSString *)name ;
- (void)removeFontFromFavourite:(NSString *)name ;
- (BOOL)isFontPresentInFavList:(NSString *)fontName ;
- (NSArray *)getAllFavouriteFonts ;
- (void)removeAllFontsFromFavourite ;

@end
