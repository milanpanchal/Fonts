//
//  AboutMeViewController.m
//  iOS7Fonts
//
//  Created by Milan Kumar Panchal on 20/01/14.
//  Copyright (c) 2014 Pantech. All rights reserved.
//

#import "AboutMeViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <AddressBook/AddressBook.h>
#import "Person.h"

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

- (IBAction)saveContactToAddressBook {
    
    Person *person = [[Person alloc] init];
    
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

    if (![self doesPersonExistWithPerson:person inAddressBook:iPhoneAddressBook]) {
        
        ABRecordRef newPerson = ABPersonCreate();
        
        // First Name - Last Name - Nickname - Company Name
        ABRecordSetValue(newPerson, kABPersonFirstNameProperty, (__bridge CFTypeRef)(person.firstName), &error);
        ABRecordSetValue(newPerson, kABPersonLastNameProperty, (__bridge CFTypeRef)(person.lastName), &error);
        ABRecordSetValue(newPerson, kABPersonNicknameProperty, (__bridge CFTypeRef)(person.nickName), &error);
        ABRecordSetValue(newPerson, kABPersonOrganizationProperty, (__bridge CFTypeRef)(person.organizationName), &error);
        
        
        
        //  Add Emial addresses
        ABMutableMultiValueRef multiEmail = ABMultiValueCreateMutable(kABMultiStringPropertyType);
        for (NSString *email in person.emailAddresses) {
            ABMultiValueAddValueAndLabel(multiEmail, (__bridge CFTypeRef)(email), kABHomeLabel, NULL);
        }
        ABRecordSetValue(newPerson, kABPersonEmailProperty, multiEmail, &error);
        CFRelease(multiEmail);
        
        
        //  Adding social and Skype
        ABMultiValueRef social = ABMultiValueCreateMutable(kABMultiDictionaryPropertyType);
        
        ABMultiValueAddValueAndLabel(social, (__bridge CFTypeRef)([NSDictionary dictionaryWithObjectsAndKeys:
                                                                   (NSString *)kABPersonInstantMessageServiceSkype, kABPersonInstantMessageServiceKey,
                                                                   person.skypeId, kABPersonInstantMessageUsernameKey,
                                                                   nil]), kABPersonInstantMessageServiceSkype, NULL); // For Skype
        
        ABMultiValueAddValueAndLabel(social, (__bridge CFTypeRef)([NSDictionary dictionaryWithObjectsAndKeys:
                                                                   (NSString *)kABPersonSocialProfileServiceTwitter, kABPersonSocialProfileServiceKey,
                                                                   person.twitterId, kABPersonSocialProfileUsernameKey,
                                                                   nil]), kABPersonSocialProfileServiceTwitter, NULL); // For Twitter
        
        ABMultiValueAddValueAndLabel(social, (__bridge CFTypeRef)([NSDictionary dictionaryWithObjectsAndKeys:
                                                                   (NSString *)kABPersonSocialProfileServiceFacebook, kABPersonSocialProfileServiceKey,
                                                                   person.facebookId, kABPersonSocialProfileUsernameKey,
                                                                   nil]), kABPersonSocialProfileServiceFacebook, NULL); // For Facebook
        
        ABMultiValueAddValueAndLabel(social, (__bridge CFTypeRef)([NSDictionary dictionaryWithObjectsAndKeys:
                                                                   (NSString *)kABPersonSocialProfileServiceLinkedIn, kABPersonSocialProfileServiceKey,
                                                                   person.linkedinId, kABPersonSocialProfileUsernameKey,
                                                                   nil]), kABPersonSocialProfileServiceLinkedIn, NULL); // For LinkedIn
        
        
        ABRecordSetValue(newPerson, kABPersonSocialProfileProperty, social, &error);
        
        
        // Add an image
        NSData *dataRef = UIImagePNGRepresentation(person.displayPic);
        ABPersonSetImageData(newPerson, (__bridge CFDataRef)dataRef, &error);
        
        // URL
        ABMutableMultiValueRef urlMultiValue = ABMultiValueCreateMutable(kABStringPropertyType);
        for (NSString *blogUrl in person.blogUrls) {
            ABMultiValueAddValueAndLabel(urlMultiValue, (__bridge CFTypeRef)(blogUrl), kABPersonHomePageLabel, NULL);
        }
        
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
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Added Successfully!"
                                                            message:[NSString stringWithFormat:@"%@ %@ was added to your contact successfully.",person.firstName,person.lastName]
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
        
        
        CFRelease(newPerson);
        CFRelease(iPhoneAddressBook);

    }else {
    
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Already Exist!"
                                                        message:[NSString stringWithFormat:@"%@ %@ was already exist in your address book.",person.firstName,person.lastName]
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }

}

- (BOOL) doesPersonExistWithPerson:(Person *)personObj inAddressBook:(ABRecordRef)paramAddressBook {

    
    if (paramAddressBook == NULL){
        NSLog(@"The address book is null.");
        return NO;
    }
    
    
    NSArray *allPeople = (__bridge_transfer NSArray *) ABAddressBookCopyArrayOfAllPeople(paramAddressBook);

    NSUInteger peopleCounter = 0;

    for (peopleCounter = 0 ; peopleCounter < [allPeople count] ; peopleCounter++){
      
        ABRecordRef person = (__bridge ABRecordRef) [allPeople objectAtIndex:peopleCounter];

        NSString *firstName = (__bridge_transfer NSString *) ABRecordCopyValue(person, kABPersonFirstNameProperty);

        NSString *lastName  = (__bridge_transfer NSString *) ABRecordCopyValue(person, kABPersonLastNameProperty);

        NSString *nickName  = (__bridge_transfer NSString *) ABRecordCopyValue(person, kABPersonNicknameProperty);

        NSString *organizationName  = (__bridge_transfer NSString *) ABRecordCopyValue(person, kABPersonOrganizationProperty);
        
        
        if ([personObj.firstName isEqualToString:firstName] &&
            [personObj.lastName isEqualToString:lastName]  &&
            [personObj.nickName isEqualToString:nickName] &&
            [personObj.organizationName isEqualToString:organizationName]) {
    
            return YES;
        }

        
    }
    

    
    return NO;

}



@end
