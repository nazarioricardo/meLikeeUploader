//
//  CocoaUploadAudioViewController.m
//  meLikeeUploader
//
//  Created by Ricardo Nazario on 6/2/16.
//  Copyright © 2016 Ricardo Nazario. All rights reserved.
//

#import "CocoaUploadAudioViewController.h"

@interface CocoaUploadAudioViewController ()

@property (weak) IBOutlet NSTextField *ownerIDTextField;
@property (weak) IBOutlet NSTextField *levelTextField;
@property (weak) IBOutlet NSTextField *lineNumberTextField;

@property (weak) IBOutlet NSProgressIndicator *progressIndicator;

@end

@implementation CocoaUploadAudioViewController

- (IBAction)uploadSingleLine:(id)sender {
    [self uploadLine:NO];
}

- (IBAction)uploadBatch:(id)sender {
    [self uploadLine:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    self.progressIndicator.hidden = YES;
}

-(void)uploadLine:(BOOL)batch {
    
    [self shouldAnimateIndicator:YES];
    
    NSString *lineID = [NSString stringWithFormat:@"%@%@%@", [_ownerIDTextField stringValue], [_levelTextField stringValue], [_lineNumberTextField stringValue]];
    NSArray *desktops = NSSearchPathForDirectoriesInDomains(NSDesktopDirectory, NSUserDomainMask, YES);
    NSString *desktopPath = desktops[0];
    NSString *filePath = [NSString stringWithFormat:@"%@/PickUpLines/%@/", desktopPath, [_ownerIDTextField stringValue]];
    
    NSURL *audioURL = [[NSBundle bundleWithPath:filePath] URLForResource:lineID withExtension:@"mp3"];
    
    NSLog(@"%@", audioURL);
    
    if (audioURL) {
        
        [Uploader saveLine:lineID
                   profile:[_ownerIDTextField stringValue]
                     level:[_levelTextField stringValue]
                       url:audioURL
     withCompletionHandler:^(CKRecord *savedRecord, NSError *error) {
         
         if (!error) {
             NSLog(@"%@ saved succesfully", savedRecord.recordID);
             
             NSInteger ln = [[_lineNumberTextField stringValue] integerValue];
             ln++;
             
             NSString *lineNumberString = [_lineNumberTextField stringValue];
             lineNumberString = [NSString stringWithFormat:@"%ld", (long)ln];
             
             [_lineNumberTextField setStringValue:lineNumberString];
             
             if (batch) {
                 [self uploadLine:batch];
             } else {
                 [self shouldAnimateIndicator:NO];
             }
             
         } else {
             NSLog(@"%@", error);
             
             [self shouldAnimateIndicator:NO];
             
             if (CKErrorRequestRateLimited) {
                 
                 double retryAfterValue = [error.userInfo[CKErrorRetryAfterKey] doubleValue];
                 
                 //NSNumber *secondsToRetry = error.userInfo[CKErrorRetryAfterKey];
                 NSLog(@"Will retry to save %@ in %f seconds", lineID, retryAfterValue);
                 
                 if (retryAfterValue) {
                     //                             NSDate *retryAfterDate = [NSDate dateWithTimeIntervalSinceNow:retryAfterValue];
                     //                             NSDate *now = [NSDate date];
                     //                             NSTimeInterval timeInterval = [retryAfterDate timeIntervalSinceDate:now];
                     
                     __unused NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:retryAfterValue
                                                                                target:self
                                                                              selector:@selector(saveRecord:completionHandler:)                                                                                  userInfo:nil
                                                                               repeats:NO];
                 }
             }
         }
         
     }];
        
    } else {
        
        NSLog(@"Invalid URL");
        [self shouldAnimateIndicator:NO];
    }
}

- (void)shouldAnimateIndicator:(BOOL)animate {
    
    if (animate) {
        self.progressIndicator.hidden = NO;
        [self.progressIndicator startAnimation:self];
    } else {
        self.progressIndicator.hidden = YES;
        [self.progressIndicator stopAnimation:self];
    }
    
}

@end
