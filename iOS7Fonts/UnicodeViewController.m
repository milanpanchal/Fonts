//
//  UnicodeViewController.m
//  iOS7Fonts
//
//  Created by Milan Kumar Panchal on 21/01/14.
//  Copyright (c) 2014 Pantech. All rights reserved.
//

#import "UnicodeViewController.h"
#import "CustomUnicodeCell.h"
#import <QuartzCore/QuartzCore.h>

#define kMaxUnicodeInRow    7
#define kBorderWidth        2.0f
#define kBorderColor        [[UIColor grayColor] CGColor]
#define kFontName           @"AmericanTypewriter"
#define kFontSize           14.00f

@interface UnicodeViewController () {

    NSMutableArray *unicodes;
    NSArray *hexArray;
}

@end

@implementation UnicodeViewController



#pragma mark - UIView life cycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        // set tab title
        self.title = @"Unicodes";
        
        // Set different title for navigation controller
        // Note: self.title will reset Nav Title. Use it first if you want different titles
        
        self.navigationItem.title = @"Unicodes";
        [self.tabBarItem setImage:[[UIImage imageNamed:@"Unicode"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    unicodes = [[NSMutableArray alloc] init];
    hexArray = @[@"0",@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"A",@"B",@"C",@"D",@"E",@"F"];
    for (NSString *string1 in hexArray) {
        for (NSString *string2 in hexArray) {
            for (NSString *string3 in hexArray) {
                for (NSString *string4 in hexArray) {
                    NSString *unicodeChar = [NSString stringWithFormat:@"%@%@%@%@",string1,string2,string3,string4];
                    [unicodes addObject:unicodeChar];
                }
            }
        }

    }
    
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableView DataSource/Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [unicodes count]/kMaxUnicodeInRow;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CellIdentifier";
    CustomUnicodeCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        NSArray *nib        = [[NSBundle mainBundle] loadNibNamed:@"CustomUnicodeCell" owner:self options:nil];
        cell                = [nib objectAtIndex:0];
        cell.accessoryType  = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }

    for (int i = 1 ; i <= kMaxUnicodeInRow ; i++ ) {

        NSString *unicodeString = unicodes[(kMaxUnicodeInRow * indexPath.row) + i];
        
        NSString *unicodeChar = [NSString stringWithFormat:@"\\u%@\n\n%@",unicodeString,unicodeString];
        NSData *data = [unicodeChar dataUsingEncoding:NSASCIIStringEncoding];
        NSString *converted = [[NSString alloc] initWithData:data encoding:NSNonLossyASCIIStringEncoding];

        switch (i) {
            case 1:
                cell.unicode1.text = converted;
                cell.unicode1.font = [UIFont fontWithName:kFontName size:kFontSize];
                cell.unicode1.layer.borderColor = kBorderColor;
                cell.unicode1.layer.borderWidth = kBorderWidth;
            case 2:
                cell.unicode2.text = converted;
                cell.unicode2.font = [UIFont fontWithName:kFontName size:kFontSize];
                cell.unicode2.layer.borderColor = kBorderColor;
                cell.unicode2.layer.borderWidth = kBorderWidth;

                break;
            case 3:
                cell.unicode3.text = converted;
                cell.unicode3.font = [UIFont fontWithName:kFontName size:kFontSize];
                cell.unicode3.layer.borderColor = kBorderColor;
                cell.unicode3.layer.borderWidth = kBorderWidth;

                break;
            case 4:
                cell.unicode4.text = converted;
                cell.unicode4.font = [UIFont fontWithName:kFontName size:kFontSize];
                cell.unicode4.layer.borderColor = kBorderColor;
                cell.unicode4.layer.borderWidth = kBorderWidth;

                break;
            case 5:
                cell.unicode5.text = converted;
                cell.unicode5.font = [UIFont fontWithName:kFontName size:kFontSize];
                cell.unicode5.layer.borderColor = kBorderColor;
                cell.unicode5.layer.borderWidth = kBorderWidth;

            case 6:
                cell.unicode6.text = converted;
                cell.unicode6.font = [UIFont fontWithName:kFontName size:kFontSize];
                cell.unicode6.layer.borderColor = kBorderColor;
                cell.unicode6.layer.borderWidth = kBorderWidth;

            case 7:
                cell.unicode7.text = converted;
                cell.unicode7.font = [UIFont fontWithName:kFontName size:kFontSize];
                cell.unicode7.layer.borderColor = kBorderColor;
                cell.unicode7.layer.borderWidth = kBorderWidth;

                break;
        }

    }
    return cell;
}


@end
