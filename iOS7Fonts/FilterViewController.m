//
//  FilterViewController.m
//  iOS7Fonts
//
//  Created by Milan Kumar Panchal on 04/02/14.
//  Copyright (c) 2014 Pantech. All rights reserved.
//

#import "FilterViewController.h"
#import "GPUImage.h"

@interface FilterViewController () {

    UIImage *originalImage;

}

@end

@implementation FilterViewController

#pragma mark - View life cycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.navigationItem.title = @"Image Filter";
        self.saveButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(saveImageToAlbum)];
        self.navigationItem.rightBarButtonItem = self.saveButton;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    originalImage = [UIImage imageNamed:@"sam.jpg"];
    
    [self.selectedImageView setImage:originalImage];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)applyImageFilter:(id)sender {
    UIActionSheet *filterActionSheet = [[UIActionSheet alloc] initWithTitle:@"Select Filter"
                                                                   delegate:self
                                                          cancelButtonTitle:@"Cancel"
                                                     destructiveButtonTitle:nil
                                                          otherButtonTitles:@"Grayscale", @"Sepia", @"Sketch", @"Pixellate", @"Color Invert", @"Toon", @"Pinch Distort", @"None", nil];
    
    [filterActionSheet showFromBarButtonItem:sender animated:YES];
}


#pragma mark - IBAction Methods

- (IBAction)photoFromAlbum {
    UIImagePickerController *photoPicker = [[UIImagePickerController alloc] init];
    photoPicker.delegate = self;
    photoPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:photoPicker animated:YES completion:nil];
}

- (IBAction)photoFromCamera {
    UIImagePickerController *photoPicker = [[UIImagePickerController alloc] init];
    photoPicker.delegate = self;
    photoPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    [self presentViewController:photoPicker animated:YES completion:nil];
}

- (void)saveImageToAlbum {
    UIImageWriteToSavedPhotosAlbum(self.selectedImageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
}


#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    GPUImageFilter *selectedFilter;
    
    switch (buttonIndex) {
        case 0:
            selectedFilter = [[GPUImageGrayscaleFilter alloc] init];
            break;
        case 1:
            selectedFilter = [[GPUImageSepiaFilter alloc] init];
            break;
        case 2:
            selectedFilter = [[GPUImageSketchFilter alloc] init];
            break;
        case 3:
            selectedFilter = [[GPUImagePixellateFilter alloc] init];
            break;
        case 4:
            selectedFilter = [[GPUImageColorInvertFilter alloc] init];
            break;
        case 5:
            selectedFilter = [[GPUImageToonFilter alloc] init];
            break;
        case 6:
            selectedFilter = [[GPUImagePinchDistortionFilter alloc] init];
            break;
        case 7:
            selectedFilter = [[GPUImageFilter alloc] init];
            break;
        default:
            break;
    }
    
    UIImage *filteredImage = [selectedFilter imageByFilteringImage:originalImage];
    [self.selectedImageView setImage:filteredImage];
}

#pragma mark -
#pragma mark UIImagePickerController


- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSString *alertTitle;
    NSString *alertMessage;
    
    if(!error)
    {
        alertTitle   = @"Image Saved";
        alertMessage = @"Image saved to photo album successfully.";
    }
    else
    {
        alertTitle   = @"Error";
        alertMessage = @"Unable to save to photo album.";
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:alertTitle
                                                    message:alertMessage
                                                   delegate:self
                                          cancelButtonTitle:@"Okay"
                                          otherButtonTitles:nil];
    [alert show];
}

#pragma mark -
#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)photoPicker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    self.saveButton.enabled = YES;
    self.filterButton.enabled = YES;
    
    originalImage = [info valueForKey:UIImagePickerControllerOriginalImage];
    
    [self.selectedImageView setImage:originalImage];
    
    [photoPicker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)photoPicker {
    [photoPicker dismissViewControllerAnimated:YES completion:nil] ;
}

@end
