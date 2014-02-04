//
//  FilterViewController.h
//  iOS7Fonts
//
//  Created by Milan Kumar Panchal on 04/02/14.
//  Copyright (c) 2014 Pantech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilterViewController : UIViewController<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property(nonatomic, weak) IBOutlet UIImageView *selectedImageView;
@property(nonatomic, weak) IBOutlet UIBarButtonItem *filterButton;
@property(nonatomic, strong) UIBarButtonItem *saveButton;

@end
