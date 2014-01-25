//
//  Person.h
//  iOS7Fonts
//
//  Created by Milan Kumar Panchal on 25/01/14.
//  Copyright (c) 2014 Pantech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject

@property (strong, nonatomic) NSString *firstName ;
@property (strong, nonatomic) NSString *lastName ;
@property (strong, nonatomic) NSString *nickName ;
@property (strong, nonatomic) NSString *organizationName ;

@property (strong, nonatomic) UIImage *displayPic ;

@property (strong, nonatomic) NSString *skypeId ;
@property (strong, nonatomic) NSString *facebookId ;
@property (strong, nonatomic) NSString *linkedinId ;
@property (strong, nonatomic) NSString *twitterId ;

@property (strong, nonatomic) NSArray *emailAddresses ;
@property (strong, nonatomic) NSArray *blogUrls ;



@end
