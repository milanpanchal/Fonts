//
//  FavouriteViewController.h
//  iOS7Fonts
//
//  Created by Milan Kumar Panchal on 17/01/14.
//  Copyright (c) 2014 Pantech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FavouriteViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tblView;

@end
