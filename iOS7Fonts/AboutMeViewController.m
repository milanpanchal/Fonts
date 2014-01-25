//
//  AboutMeViewController.m
//  iOS7Fonts
//
//  Created by Milan Kumar Panchal on 20/01/14.
//  Copyright (c) 2014 Pantech. All rights reserved.
//

#import "AboutMeViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "Constants.h"
#import <AddressBook/AddressBook.h>

@interface AboutMeViewController () {

    UIBarButtonItem *saveContactBtn;
}

@end


@implementation AboutMeViewController

#pragma mark - View life cycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

        // set tab title
        self.title = @"About Me";
        
        // Set different title for navigation controller
        // Note: self.title will reset Nav Title. Use it first if you want different titles
        
        self.navigationItem.title = @"About Me";
        [self.tabBarItem setImage:[[UIImage imageNamed:@"AboutUs"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];

    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [_profilePic.layer setCornerRadius:CGRectGetWidth(_profilePic.frame)/2];
    [_profilePic setClipsToBounds:YES];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:IMG_BG]]];

    
    [self addNavigationBarRightButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - user defined methods

- (void)addNavigationBarRightButton {
    
    saveContactBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(saveContactToAddressBook)];
    self.navigationItem.rightBarButtonItem = saveContactBtn;
    
}

- (IBAction)gotoUrl:(UIButton *)sender {
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@",sender.currentTitle]];
    BOOL canOpenUrl = [[UIApplication sharedApplication] canOpenURL:url];
    if (canOpenUrl) {
        [[UIApplication sharedApplication] openURL:url];
    }

}

- (void)saveContactToAddressBook {
    CFErrorRef error = NULL;

    ABAddressBookRef iPhoneAddressBook;
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"6.0")){
        iPhoneAddressBook = ABAddressBookCreateWithOptions(NULL, NULL);
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        ABAddressBookRequestAccessWithCompletion(iPhoneAddressBook,  ^(bool granted, CFErrorRef error){
                                                     dispatch_semaphore_signal(sema);
                                                 });
        
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        
    } else {
        iPhoneAddressBook = ABAddressBookCreate();
    }

    
    ABRecordRef newPerson = ABPersonCreate();

    // First Name - Last Name - Nickname - Company Name
    ABRecordSetValue(newPerson, kABPersonFirstNameProperty, CFSTR("Milan"), &error);
    ABRecordSetValue(newPerson, kABPersonLastNameProperty, CFSTR("Panchal"), &error);
    ABRecordSetValue(newPerson, kABPersonNicknameProperty, CFSTR("SAM"), &error);
    ABRecordSetValue(newPerson, kABPersonOrganizationProperty, CFSTR("Pantech"), &error);

    

    //  Add Emial addresses
    ABMutableMultiValueRef multiEmail = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    ABMultiValueAddValueAndLabel(multiEmail, @"sam07it22@gmail.com", kABHomeLabel, NULL);
    ABRecordSetValue(newPerson, kABPersonEmailProperty, multiEmail, &error);
    CFRelease(multiEmail);
    

    //  Adding social and Skype
    ABMultiValueRef social = ABMultiValueCreateMutable(kABMultiDictionaryPropertyType);
    
    ABMultiValueAddValueAndLabel(social, (__bridge CFTypeRef)([NSDictionary dictionaryWithObjectsAndKeys:
                                                               (NSString *)kABPersonSocialProfileServiceTwitter, kABPersonSocialProfileServiceKey,
                                                               @"milan_panchal24", kABPersonSocialProfileUsernameKey,
                                                               nil]), kABPersonSocialProfileServiceTwitter, NULL); // For Twitter
    
    ABMultiValueAddValueAndLabel(social, (__bridge CFTypeRef)([NSDictionary dictionaryWithObjectsAndKeys:
                                                               (NSString *)kABPersonSocialProfileServiceFacebook, kABPersonSocialProfileServiceKey,
                                                               @"https://www.fb.me/MilanPantech", kABPersonSocialProfileUsernameKey,
                                                               nil]), kABPersonSocialProfileServiceFacebook, NULL); // For Facebook
    
    ABMultiValueAddValueAndLabel(social, (__bridge CFTypeRef)([NSDictionary dictionaryWithObjectsAndKeys:
                                                               (NSString *)kABPersonSocialProfileServiceLinkedIn, kABPersonSocialProfileServiceKey,
                                                               @"/in/milanpanchal", kABPersonSocialProfileUsernameKey,
                                                               nil]), kABPersonSocialProfileServiceLinkedIn, NULL); // For LinkedIn

    ABMultiValueAddValueAndLabel(social, (__bridge CFTypeRef)([NSDictionary dictionaryWithObjectsAndKeys:
                                                               (NSString *)kABPersonInstantMessageServiceSkype, kABPersonInstantMessageServiceKey,
                                                               @"milan_panchal24", kABPersonInstantMessageUsernameKey,
                                                               nil]), kABPersonInstantMessageServiceSkype, NULL); // For Skype

    ABRecordSetValue(newPerson, kABPersonSocialProfileProperty, social, &error);

    
    // Add an image
    UIImage *im = [UIImage imageNamed:@"sam.jpg"];
    NSData *dataRef = UIImagePNGRepresentation(im);
    ABPersonSetImageData(newPerson, (__bridge CFDataRef)dataRef, &error);

    // URL
    ABMutableMultiValueRef urlMultiValue = ABMultiValueCreateMutable(kABStringPropertyType);
    ABMultiValueAddValueAndLabel(urlMultiValue, @"http://www.techfuzionwithsam.wordpress.com", kABPersonHomePageLabel, NULL);
    ABMultiValueAddValueAndLabel(urlMultiValue, @"http://www.mypoemswithsam.wordpress.com", kABPersonHomePageLabel, NULL);
    ABRecordSetValue(newPerson, kABPersonURLProperty, urlMultiValue, &error);
    CFRelease(urlMultiValue);


    ABAddressBookAddRecord(iPhoneAddressBook, newPerson, &error);
    ABAddressBookSave(iPhoneAddressBook, &error);

    if (error != NULL) {
        
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
														message:@"Could not create unknown user"
													   delegate:nil
											  cancelButtonTitle:@"Cancel"
											  otherButtonTitles:nil];
		[alert show];
	} else {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Add To Contacts"
														message:@"Milan was added to your contact successfully!"
													   delegate:nil
											  cancelButtonTitle:@"OK"
											  otherButtonTitles:nil];
		[alert show];
	}

    
    CFRelease(newPerson);
    CFRelease(iPhoneAddressBook);

}


@end
