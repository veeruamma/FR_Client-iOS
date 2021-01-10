//
//  OpenCVWrapper.m
//  VeerFRiOS
//
//  Created by Veeresh Ittangihal on 08/01/21.
//

#import "OpenCVWrapper.h"

#import <opencv2/opencv.hpp>
#import <opencv2/imgcodecs/ios.h>

@implementation OpenCVWrapper

+(NSString *) opencvVersion
{
    return [NSString stringWithFormat:@"%s", CV_VERSION];
}

+(NSString *) getRows:(UIImage *) image
{
    cv::Mat imageMat;
    UIImageToMat(image, imageMat);
    cv::cvtColor(imageMat, imageMat, CV_BGR2RGB);
    return [NSString stringWithFormat:@"%d",imageMat.rows];
}

+(NSString *) getCols:(UIImage *) image
{
    cv::Mat imageMat;
    UIImageToMat(image, imageMat);
    cv::cvtColor(imageMat, imageMat, CV_BGR2RGB);
    return [NSString stringWithFormat:@"%d",imageMat.cols];
}



// method to convert an RGB to Grayscale image
+(UIImage *) makeGrayScaleImage:(UIImage *) image{
    cv::Mat imageMat;
    bool alphaExist = false;
    UIImageToMat(image, imageMat, alphaExist);
    
    if(imageMat.channels() == 1) return image;
    
    cv::Mat grayMat;
    cv::cvtColor(imageMat, grayMat, CV_BGR2GRAY);
    
    return MatToUIImage(grayMat);
}


// method to convert an RGB to cvMat
+(NSData *) makeImageToMat:(UIImage *)image{
//    typedef unsigned char byte;
    
    cv::Mat imageMat;
    UIImageToMat(image, imageMat);
    
    cv::cvtColor(imageMat, imageMat, CV_BGR2RGB);
    
    NSData *data = [NSData dataWithBytes:imageMat.data length:imageMat.elemSize()*imageMat.total()];
    
    return data;
}

+(NSData *) matToData:(cv::Mat)cvMat
{
    NSData *data = [NSData dataWithBytes:cvMat.data length:cvMat.elemSize()*cvMat.total()];
    
    return data;
}



+ (cv::Mat)cvMatWithImage:(UIImage *)image
{
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(image.CGImage);
    size_t numberOfComponents = CGColorSpaceGetNumberOfComponents(colorSpace);
    CGFloat cols = image.size.width;
    CGFloat rows = image.size.height;

    cv::Mat cvMat(rows, cols, CV_8UC4); // 8 bits per component, 4 channels
    CGBitmapInfo bitmapInfo = kCGImageAlphaNoneSkipLast | kCGBitmapByteOrderDefault;

    // check whether the UIImage is greyscale already
    if (numberOfComponents == 1){
        cvMat = cv::Mat(rows, cols, CV_8UC1); // 8 bits per component, 1 channels
        bitmapInfo = kCGImageAlphaNone | kCGBitmapByteOrderDefault;
    }

    CGContextRef contextRef = CGBitmapContextCreate(cvMat.data,   // Pointer to backing
                                                    cols,         // Width of bitmap
                                                    rows,       // Height of bitmap
                                                    8,        // Bits per component
                                                    cvMat.step[0], // Bytes per row
                                                    colorSpace,   // Colorspace
                                                    bitmapInfo);  // Bitmap info flags

    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), image.CGImage);
    CGContextRelease(contextRef);

    return cvMat;
}

@end
