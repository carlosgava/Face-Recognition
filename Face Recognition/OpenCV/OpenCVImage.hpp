//
//  OpenCVImage.h
//  Face Recognition
//
//  Created by Carlos Henrique Gava on 16/04/24.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <opencv2/imgproc/imgproc.hpp>

NS_ASSUME_NONNULL_BEGIN

@interface OpenCVImage : NSObject

+(NSString *) versionNumber;
+(UIImage *) convertToGrayscale: (UIImage *) image;
+(UIImage *) classifyImage: (UIImage *) image;
+(UIImage *) imageFromCVMat:(cv::Mat) mat;

@end

NS_ASSUME_NONNULL_END
