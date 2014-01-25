//
//  Person.m
//  iOS7Fonts
//
//  Created by Milan Kumar Panchal on 25/01/14.
//  Copyright (c) 2014 Pantech. All rights reserved.
//

#import "Person.h"

@implementation Person

- (id)init {
    self = [super init];
    if (self) {
        

        self.firstName          = @"Milan";
        self.lastName           = @"Panchal";
        self.nickName           = @"SAM";
        self.organizationName   = @"Pantech";
        
        self.displayPic         = [UIImage imageNamed:@"sam.jpg"];
        
        self.skypeId            = @"milan_panchal24";
        self.twitterId          = @"milan_panchal24";
        self.facebookId         = @"MilanPantech";
        self.linkedinId         = @"milanpanchal";
        
        self.emailAddresses     = @[@"sam07it22@gmail.com"];
        self.blogUrls           = @[@"http://www.techfuzionwithsam.wordpress.com",@"http://www.mypoemswithsam.wordpress.com"];
        
        
    }
    return self;
}
@end
