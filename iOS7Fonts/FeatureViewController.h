//
//  FeatureViewController.h
//  iOS7Fonts
//
//  Created by Milan Kumar Panchal on 27/01/14.
//  Copyright (c) 2014 Pantech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeatureViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tblView;

@end
