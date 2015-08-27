//
//  UIImageResize+Rotate.h
//  ReKo SDK
//
//  Created by cys on 7/24/13.
//  Copyright (c) 2013 Orbeus Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

double degreesToRadians(double degrees);

@interface RekoImageToolbox : NSObject

// UIImage Transformation (for images created from CGImageRef):
+ (UIImage *)fixOrientation:(UIImage *)rawImage; // Rotate the image to its up un-mirrored position.
+ (UIImage *)cropImage:(UIImage *)image inRect:(CGRect)cropRect;
+ (UIImage *)resizeImage:(UIImage *)image newSize:(CGSize)size;
+ (UIImage *)rotateImage:(UIImage *)image angleCounterclockwise:(CGFloat)degrees;

// CIImage Transformation:
+ (CIImage *)cropCIImage:(CIImage *)ciImage inRect:(CGRect)rect;
+ (CIImage *)resizeCIImage:(CIImage *)ciImage newSize:(CGSize)size andRotateCounterclockwise:(CGFloat)degrees;

+ (void)saveImageToAlbum:(UIImage *)image;
+ (CGRect)transferCGRectBetweenCGAndCICoordinates:(CGRect)cgRect imageHeight:(CGFloat)height;
@end