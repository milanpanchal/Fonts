//
//  BarcodeViewController.m
//  iOS7Fonts
//
//  Created by Milan Kumar Panchal on 27/01/14.
//  Copyright (c) 2014 Pantech. All rights reserved.
//

#import "BarcodeViewController.h"
#import "Barcode.h"

@interface BarcodeViewController () {

    AVCaptureSession            *_captureSession;
    AVCaptureDevice             *_videoDevice;
    AVCaptureDeviceInput        *_videoInput;
    AVCaptureMetadataOutput     *_metadataOutput;
    AVCaptureVideoPreviewLayer  *_previewLayer;
    
    UIView *_previewView;

    BOOL _running;
    CGRect highlightViewRect;
}

@end


/**
Supported Barcodes: Total-11
 
 UPC-A, UPC-E, Code 39, Code 39 mod 43, Code 93, Code 128, EAN-8, EAN-13, Aztec, PDF417,  QR
 
 */

@implementation BarcodeViewController

#pragma mark - View life cycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.navigationItem.title = @"Barcode Scanning";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];


    _previewView = [[UIView alloc] initWithFrame:CGRectZero];
    _previewView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin;
    _previewView.layer.borderColor = [UIColor greenColor].CGColor;
    _previewView.layer.borderWidth = 3;
    [self.view addSubview:_previewView];
    
    [self setupCaptureSession];


    // listen for going into the background and stop the session
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];


}

- (void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];
    [self startRunning];

    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self stopRunning];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - AV capture methods

- (void)setupCaptureSession {

    if (_captureSession) return;
   
    
    _videoDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (!_videoDevice) {
        NSLog(@"No video camera on this device!");
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"No Camera Found!"
                                                          message:@"No video camera on this device!"
                                                         delegate:nil
                                                cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        
        [message show];
        return;
    }

    _captureSession = [[AVCaptureSession alloc] init];

    NSError *error = nil;
    _videoInput = [[AVCaptureDeviceInput alloc] initWithDevice:_videoDevice error:nil];
    if ([_captureSession canAddInput:_videoInput]) {
        [_captureSession addInput:_videoInput];
    }else{
        NSLog(@"Error: %@", error);
    }

    
    _previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
    _previewLayer.videoGravity =  AVLayerVideoGravityResizeAspectFill;
    _previewLayer.frame = self.view.bounds;
//    [self.view.layer addSublayer:_previewLayer];
    [self.view.layer insertSublayer:_previewLayer atIndex:0];

    
    // capture and process the metadata
    _metadataOutput = [[AVCaptureMetadataOutput alloc] init];
//    [_metadataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
 
    
     dispatch_queue_t metadataQueue = dispatch_queue_create("com.1337labz.featurebuild.metadata", DISPATCH_QUEUE_SERIAL);
     [_metadataOutput setMetadataObjectsDelegate:self queue:metadataQueue];
    

    if ([_captureSession canAddOutput:_metadataOutput]) {
        [_captureSession addOutput:_metadataOutput];
    }
    

}

- (void)startRunning {
    if (_running) return;

    [_captureSession startRunning];
    _metadataOutput.metadataObjectTypes = _metadataOutput.availableMetadataObjectTypes;
    _running = YES;
    
    [self.view bringSubviewToFront:_previewView];

}
- (void)stopRunning {
    if (!_running) return;
    [_captureSession stopRunning];
    _running = NO;
}

#pragma mark - Delegate functions

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    NSLog(@"Method Called");
    
    NSArray *barCodeTypes = @[AVMetadataObjectTypeUPCECode, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode39Mod43Code,
                              AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeCode128Code,
                              AVMetadataObjectTypePDF417Code, AVMetadataObjectTypeQRCode, AVMetadataObjectTypeAztecCode];

    
    for (AVMetadataObject *obj in metadataObjects) {
       
        if ([obj isKindOfClass:[AVMetadataMachineReadableCodeObject class]]) {

             AVMetadataMachineReadableCodeObject *code = (AVMetadataMachineReadableCodeObject*) [_previewLayer transformedMetadataObjectForMetadataObject:obj];
             Barcode * barcode = [Barcode processMetadataObject:code];

             for(NSString * str in barCodeTypes) {
                 if([barcode.getBarcodeType isEqualToString:str]){
                     highlightViewRect = code.bounds;
                     
                     [self validBarcodeFound:barcode];
                     return;
                 }
             }
         }

    }
    _previewView.frame = highlightViewRect;
    [_previewView setNeedsDisplay];

    
}

- (void) validBarcodeFound:(Barcode *)barcode{
    [self stopRunning];
    [self showBarcodeAlert:barcode];
}

#pragma mark - UIAlertView methods

- (void) showBarcodeAlert:(Barcode *)barcode{

    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // Code to do in background processing
        [barcode printBarcodeData];
        NSString * alertMessage = [NSString stringWithFormat:@"You found a barcode with type %@ and data %@",[barcode getBarcodeType],[barcode getBarcodeData]];
        
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Barcode Found!"
                                                          message:alertMessage
                                                         delegate:self
                                                cancelButtonTitle:@"Done"
                                                otherButtonTitles:@"Scan again",nil];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // Code to update the UI/send notifications based on the results of the background processing
            [message show];
            
        });
    });
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex == 0){
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    if(buttonIndex == 1){
        //Code for Scan more button
        [self startRunning];
    }
}

#pragma mark - NSNotification handler

- (void)applicationWillEnterForeground:(NSNotification*)note {
    [self startRunning];

}


- (void)applicationDidEnterBackground:(NSNotification*)note {
    [self stopRunning];
}

@end
