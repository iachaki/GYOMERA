//
//  UIImageResize+Rotate.m
//  ReKo SDK
//
//  Created by cys on 7/24/13.
//  Copyright (c) 2013 Orbeus Inc. All rights reserved.
//

#import "RekoImageToolbox.h"
#import <AssetsLibrary/AssetsLibrary.h>


double degreesToRadians(double degrees) { return degrees * M_PI / 180; }

@implementation RekoImageToolbox
+ (UIImage *)fixOrientation:(UIImage *)rawImage {
    // No-op if the orientation is already correct
    if (rawImage.imageOrientation == UIImageOrientationUp) return rawImage;
    
    NSLog(@"original orientation: %d", rawImage.imageOrientation);
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (rawImage.imageOrientation)
    {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, rawImage.size.width, rawImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, rawImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, rawImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
            
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (rawImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, rawImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, rawImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, rawImage.size.width, rawImage.size.height,
                                             CGImageGetBitsPerComponent(rawImage.CGImage), 0,
                                             CGImageGetColorSpace(rawImage.CGImage),
                                             CGImageGetBitmapInfo(rawImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (rawImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,rawImage.size.height,rawImage.size.width), rawImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,rawImage.size.width,rawImage.size.height), rawImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}


+ (UIImage *)cropImage:(UIImage *)image inRect:(CGRect)cropRect {
    CGImageRef imageRef = CGImageCreateWithImageInRect(image.CGImage, cropRect);
    image = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return image;
}


+ (UIImage *)resizeImage:(UIImage *)image newSize:(CGSize)size {
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


+ (UIImage *)rotateImage:(UIImage *)image angleCounterclockwise:(CGFloat)degrees {
    CGImageRef imageRef = image.CGImage;
    BOOL releaseCGImage = NO;
    if (!imageRef) {
        CIContext *context = [CIContext contextWithOptions:nil];
        imageRef = [context createCGImage:image.CIImage fromRect:image.CIImage.extent];
        releaseCGImage = YES;
    }
    
    CGFloat width = CGImageGetWidth(imageRef);
    CGFloat height = CGImageGetHeight(imageRef);
    
    CGRect imgRect = CGRectMake(0, 0,  width, height);
    
    // calculate the size of the rotated view's containing box for our drawing space
    UIView *rotatedViewBox = [[UIView alloc] initWithFrame:imgRect];
    CGAffineTransform t = CGAffineTransformMakeRotation(degreesToRadians(degrees));
    rotatedViewBox.transform = t;
    CGSize rotatedSize = rotatedViewBox.frame.size;
    
    // Create the bitmap context
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    
    // Move the origin to the middle of the image so we will rotate and scale around the center.
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    
    // Rotate the image context
    CGContextRotateCTM(bitmap, -degreesToRadians(degrees));
    
    // Now, draw the rotated/scaled image into the context
    CGContextScaleCTM(bitmap, 1.0, -1.0);
    CGContextDrawImage(bitmap, CGRectMake(-width/ 2, -height/ 2, width, height), imageRef);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    if (releaseCGImage) {
        CGImageRelease(imageRef);
    }
    return newImage;
}


//+ (UIImage *)resizeImage:(UIImage *)image newSize:(CGSize)size andRotateClockwise:(CGFloat)degrees {
//    UIGraphicsBeginImageContext(image.size);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGAffineTransform transform = CGAffineTransformIdentity;
//    transform = CGAffineTransformScale(transform, size.width / image.size.width, size.height / image.size.height);
//    transform = CGAffineTransformRotate(transform, degreesToRadians(degrees));
//    CGContextConcatCTM(context, transform);
//    [image drawAtPoint:CGPointZero];
//    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    return newImage;
//}


+ (CIImage *)cropCIImage:(CIImage *)ciImage inRect:(CGRect)rect {
    CGRect ciRect = [RekoImageToolbox transferCGRectBetweenCGAndCICoordinates:rect imageHeight:ciImage.extent.size.height];
    return [ciImage imageByCroppingToRect:ciRect];
}


+ (CIImage *)resizeCIImage:(CIImage *)ciImage newSize:(CGSize)size andRotateCounterclockwise:(CGFloat)degrees {
    CGAffineTransform transform = CGAffineTransformIdentity;
    transform = CGAffineTransformScale(transform, size.width / ciImage.extent.size.width, size.height / ciImage.extent.size.height);
    transform = CGAffineTransformRotate(transform, degreesToRadians(degrees));
    return [ciImage imageByApplyingTransform:transform];
}


+ (CGRect)transferCGRectBetweenCGAndCICoordinates:(CGRect)cgRect imageHeight:(CGFloat)height {
    return CGRectMake(cgRect.origin.x,
                      height - cgRect.origin.y - cgRect.size.height,
                      cgRect.size.width,
                      cgRect.size.height);
}


+ (void) saveImageToAlbum:(UIImage *)image {
    CGImageRef cgImage = image.CGImage;
    BOOL releaseCGImage = NO;
    if (!cgImage) {
        CIContext *context = [CIContext contextWithOptions:nil];
        cgImage = [context createCGImage:image.CIImage fromRect:image.CIImage.extent];
        releaseCGImage = YES;
    }
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    [library writeImageToSavedPhotosAlbum:cgImage
                              orientation:0
                          completionBlock:^(NSURL *assetURL, NSError *error) {
                              if (releaseCGImage) {
                                  CGImageRelease(cgImage);
                              }
                          }];
}


@end
