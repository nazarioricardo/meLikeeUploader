//
//  CocoaCreateProfile.m
//  meLikeeUploader
//
//  Created by Ricardo Nazario on 6/2/16.
//  Copyright © 2016 Ricardo Nazario. All rights reserved.
//

#import "CocoaCreateProfile.h"

@interface CocoaCreateProfile ()

@property (weak) IBOutlet NSTextField *IDTextField;
@property (weak) IBOutlet NSTextField *profileNameTextField;
@property (weak) IBOutlet NSSegmentedControl *genderSelect;

@property (nonatomic) NSURL *imageUrl;

@end

@implementation CocoaCreateProfile

- (IBAction)addImageButton:(id)sender {
}

- (IBAction)createProfileButton:(id)sender {
    
    NSString *selectedGender = [[NSString alloc] init];
    
    if (_genderSelect.selectedSegment == 0) {
        selectedGender = @"male";
    } else {
        selectedGender = @"female";
    }
    
    [Uploader createProfile:[_IDTextField stringValue]
                   withName:[_profileNameTextField stringValue]
               profileImage:_imageUrl
                  andGender:selectedGender];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
}

@end
