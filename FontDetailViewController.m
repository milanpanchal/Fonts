//
//  FontDetailViewController.m
//  iOS7Fonts
//
//  Created by Milan Kumar Panchal on 14/01/14.
//  Copyright (c) 2014 Pantech. All rights reserved.
//

#import "FontDetailViewController.h"

@interface FontDetailViewController ()

@end

@implementation FontDetailViewController

#pragma mark - UIViewLifeCycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = @"Font Detail";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    // Setup font lable
    fontNameLabel.text = _fontNameString;
    fontNameLabel.font = [UIFont fontWithName:_fontNameString size:(int)_fontSlider.minimumValue];
    fontNameLabel.backgroundColor = [UIColor whiteColor];
    fontNameLabel.textColor = [UIColor blackColor];
    fontNameLabel.numberOfLines = 0;
    fontNameLabel.layer.borderColor = [[UIColor colorWithWhite:0.3 alpha:1.0] CGColor];
    fontNameLabel.layer.borderWidth = 2.0f;

    // Setup font-family lable
    fontFamilyNameLabel.backgroundColor = [UIColor clearColor];
    fontFamilyNameLabel.textAlignment = NSTextAlignmentCenter;
    fontFamilyNameLabel.textColor = [UIColor blackColor];
    fontFamilyNameLabel.adjustsFontSizeToFitWidth = YES;
    fontFamilyNameLabel.minimumScaleFactor = 10.0/[UIFont labelFontSize];

    NSDictionary *underlineAttribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleDouble), NSUnderlineColorAttributeName:[UIColor whiteColor]};

    fontFamilyNameLabel.attributedText = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"Font Family : %@", _fontFamilyNameString]
                                                                         attributes:underlineAttribute];


    // Setup font-size lable
    fontSizeLabel.text = [NSString stringWithFormat:@"%d pt", (int)_fontSlider.value];
    fontSizeLabel.backgroundColor = [UIColor clearColor];
    fontSizeLabel.textColor = [UIColor blackColor];
    
    
    // Setup text height-width lable
    CGSize expectedLabelSize = [self getExpectedSizeForLabel:fontNameLabel];
    labelTextHeightWidth.text = [NSString stringWithFormat:@"Line: Height = %.1f, Width = %.1f px",expectedLabelSize.height,expectedLabelSize.width];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - User defined methods

-(IBAction)changeSlider:(id)sender {
    fontNameLabel.font= [fontNameLabel.font fontWithSize:(int)_fontSlider.value];
    fontSizeLabel.text = [NSString stringWithFormat:@"%d pt", (int)_fontSlider.value];

    CGSize expectedLabelSize = [self getExpectedSizeForLabel:fontNameLabel];
    labelTextHeightWidth.text = [NSString stringWithFormat:@"Line: Height = %.1f, Width = %.1f px",expectedLabelSize.height,expectedLabelSize.width];
}

- (CGSize)getExpectedSizeForLabel:(UILabel *)label {

    CGSize expectedLabelSize = [label
                                textRectForBounds:label.frame
                                limitedToNumberOfLines:label.numberOfLines].size;

    return expectedLabelSize;
}

@end
