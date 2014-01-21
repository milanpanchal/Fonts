//
//  UnicodeViewController.m
//  iOS7Fonts
//
//  Created by Milan Kumar Panchal on 21/01/14.
//  Copyright (c) 2014 Pantech. All rights reserved.
//

#import "UnicodeViewController.h"

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
    return [unicodes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    NSString *unicodeChar = [NSString stringWithFormat:@"\\u%@",unicodes[indexPath.row]];
    NSData *data = [unicodeChar dataUsingEncoding:NSASCIIStringEncoding]; //e.g. \u0021
    NSString *converted = [[NSString alloc] initWithData:data encoding:NSNonLossyASCIIStringEncoding];

    cell.textLabel.text = converted;
    cell.detailTextLabel.text = unicodes[indexPath.row];
    cell.textLabel.font = [UIFont fontWithName:@"AcademyEngravedLetPlain" size:16.00];
    return cell;
}


@end
