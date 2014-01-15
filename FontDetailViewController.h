//
//  FontDetailViewController.h
//  iOS7Fonts
//
//  Created by Milan Kumar Panchal on 14/01/14.
//  Copyright (c) 2014 Pantech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FontDetailViewController : UIViewController {

    IBOutlet UILabel *fontNameLabel;
    IBOutlet UILabel *fontFamilyNameLabel;
    IBOutlet UILabel *fontSizeLabel;
    IBOutlet UILabel *labelTextHeightWidth;

}

@property (strong, nonatomic) NSString *fontFamilyNameString;
@property (strong, nonatomic) NSString *fontNameString;



@property (strong, nonatomic) IBOutlet UISlider *fontSlider;

-(IBAction)changeSlider:(id)sender ;

@end
