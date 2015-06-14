//
//  ViewController.m
//  SampleCodeForImageHandling
//
//  Created by hothead on 2015. 6. 13..
//  Copyright (c) 2015년 hothead. All rights reserved.
//

#import "ViewController.h"
#import <Photos/Photos.h>

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}

- (void)viewDidAppear:(BOOL)animated
{
    PHFetchOptions *fetchOptions = [PHFetchOptions new];
    fetchOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    fetchOptions.includeHiddenAssets = NO;
    fetchOptions.predicate = [NSPredicate predicateWithFormat:@"(mediaSubtype & %d) != 0 || (mediaSubtype & %d) != 0", PHAssetMediaSubtypePhotoPanorama, PHAssetMediaSubtypeVideoHighFrameRate];
    
    PHFetchResult *assetsInfo = [PHAsset fetchAssetsWithOptions:fetchOptions];
    
    PHImageRequestOptions *requestOptions = [PHImageRequestOptions new];
    requestOptions.version = PHImageRequestOptionsVersionCurrent;
//    requestOptions.deliveryMode = PHImageRequestOptionsDeliveryModeFastFormat;
    requestOptions.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    requestOptions.resizeMode = PHImageRequestOptionsResizeModeExact;
    
    [assetsInfo enumerateObjectsUsingBlock:^(PHAsset *obj, NSUInteger idx, BOOL *stop) {
        NSLog(@"Asset Info : %@",
              [@{@"localIdentifier" :obj.localIdentifier,
                 @"mediaType":@(obj.mediaType)
                 ,@"mediaSubtype":@(obj.mediaSubtypes)
                 ,@"pixelWidth":@(obj.pixelWidth)
                 ,@"pixelHeight":@(obj.pixelHeight)
                 } description]);
        
        CGFloat suggestedImageWidth = MIN(1024, obj.pixelWidth);
        CGFloat suggestedImageHeight = obj.pixelHeight * suggestedImageWidth / obj.pixelWidth;
        
        [[PHImageManager defaultManager] requestImageForAsset:obj
                                                   targetSize:CGSizeMake(suggestedImageWidth, suggestedImageHeight)
                                                  contentMode:PHImageContentModeDefault
                                                      options:requestOptions
                                                resultHandler:^(UIImage *result, NSDictionary *info) {
                                                    if (result) {
                                                        // galleryButton is just a UIButton in the view
                                                        self.imageView.image = result;
                                                        NSLog(@"image : %@", result);
                                                        NSLog(@"info : %@", info);
                                                        //                                                    [galleryButton setImage:result forState:UIControlStateNormal];
                                                    }
                                                }];

    }];
    // obj.pixelWidth : obj.pixelHeight =  suggestedImageWidth : x
    // suggestedImageHeight = pixelHeight * suggestedImageWidth / obj.pixelWidth
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
