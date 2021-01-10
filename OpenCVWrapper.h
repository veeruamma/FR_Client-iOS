//
//  OpenCVWrapper.h
//  VeerFRiOS
//
//  Created by Veeresh Ittangihal on 08/01/21.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface OpenCVWrapper : NSObject

+(NSString *) opencvVersion;

+(NSString *) getRows:(UIImage *) image;
+(NSString *) getCols:(UIImage *) image;

+(UIImage *) makeGrayScaleImage:(UIImage *) image;

+(NSData *) makeImageToMat:(UIImage *) image;

@end


