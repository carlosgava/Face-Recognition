//
//  UIImageView.h
//  Face Recognition
//
//  Created by Carlos Henrique Gava on 17/04/24.
//

#import <opencv2/imgproc/imgproc.hpp>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface UIImage (OpenCV)

+ (UIImage *)imageFromCVMat:(cv::Mat)mat;
- (cv::Mat)cvMatRepresentationColor;
- (cv::Mat)cvMatRepresentationGray;


@end

NS_ASSUME_NONNULL_END
