//
//  UnicodeCollecViewController.m
//  iOS7Fonts
//
//  Created by Milan Kumar Panchal on 04/02/14.
//  Copyright (c) 2014 Pantech. All rights reserved.
//

#import "UnicodeCollecViewController.h"
#import "MyCollectionViewCell.h"
#import "Constants.h"

#define kFontName           @"AmericanTypewriter"

@interface UnicodeCollecViewController (){
    
    NSMutableArray *unicodes;
    NSArray *hexArray;
}


@end

static NSString *kCollectionViewCellIdentifier = @"Cells";
const NSTimeInterval kAnimationDuration = 0.2;


@implementation UnicodeCollecViewController


#pragma mark - View life cycle methods


- (void)viewDidLoad {
    [super viewDidLoad];

    // set tab title
    self.title = @"Unicodes";
    
    // Set different title for navigation controller
    // Note: self.title will reset Nav Title. Use it first if you want different titles
    
    self.navigationItem.title = @"Unicodes";
    [self.tabBarItem setImage:[[UIImage imageNamed:@"Unicode"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];

    
    [self.collectionView setBackgroundColor:[UIColor clearColor]];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:IMG_BG]]];

    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UICollectionView methods

- (instancetype) initWithCollectionViewLayout:(UICollectionViewLayout *)layout{
    self = [super initWithCollectionViewLayout:layout];
    
    if (self != nil){
        UINib *nib = [UINib nibWithNibName:
                      NSStringFromClass([MyCollectionViewCell class])
                                    bundle:[NSBundle mainBundle]];
        [self.collectionView registerNib:nib forCellWithReuseIdentifier:kCollectionViewCellIdentifier];
    }
    return self;
}


- (NSInteger)numberOfSectionsInCollectionView :(UICollectionView *)collectionView{
    return 1;
    
}

/* For now, we won't return any sections */
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return unicodes.count;
}


/* We don't yet know how we can return cells to the collection view so
 let's return nil for now */
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    MyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCollectionViewCellIdentifier
                                                                           forIndexPath:indexPath];
    
    NSString *unicodeString = unicodes[indexPath.row];
    
    NSString *unicodeChar = [NSString stringWithFormat:@"\\u%@",unicodeString];
    NSData *data = [unicodeChar dataUsingEncoding:NSASCIIStringEncoding];
    NSString *converted = [[NSString alloc] initWithData:data encoding:NSNonLossyASCIIStringEncoding];
    

    cell.unicode.text   = converted;
    cell.hexString.text = unicodeString;
    cell.unicode.font   = [UIFont fontWithName:kFontName size:20];
    cell.hexString.font = [UIFont fontWithName:kFontName size:12];
    
    cell.layer.borderWidth = 2.0f;
    cell.layer.borderColor = [[UIColor grayColor] CGColor];

    return cell;
}


- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *selectedCell = [collectionView cellForItemAtIndexPath:indexPath];

    [UIView animateWithDuration:kAnimationDuration animations:^{
        selectedCell.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:kAnimationDuration animations:^{
            selectedCell.alpha = 1.0f;
        }];
    }];
}

//- (void) collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath{
//    UICollectionViewCell *selectedCell = [collectionView cellForItemAtIndexPath:indexPath];
//    [UIView animateWithDuration:kAnimationDuration animations:^{
//        selectedCell.transform = CGAffineTransformMakeScale(2.0f, 2.0f);
//    }];
//
//}
//- (void) collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath{
//    UICollectionViewCell *selectedCell = [collectionView cellForItemAtIndexPath:indexPath];
//
//    [UIView animateWithDuration:kAnimationDuration animations:^{
//        selectedCell.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
//    }];
//}

- (BOOL) collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath{
    return YES;
    
}

- (BOOL) collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender{
    
    if (action == @selector(copy:)){
        return YES;
    }
    
    return NO;
}

- (void) collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
    
    if (action == @selector(copy:)){
        MyCollectionViewCell *cell = (MyCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        
        [[UIPasteboard generalPasteboard] setString:[NSString stringWithFormat:@"%@[%@]",cell.unicode.text,cell.hexString.text]];
    }
}


@end
