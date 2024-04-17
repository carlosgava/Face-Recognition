//
//  OpenCVImage.m
//  Face Recognition
//
//  Created by Carlos Henrique Gava on 16/04/24.
//

#import <opencv2/opencv.hpp>
#import <opencv2/imgcodecs/ios.h>
#import "OpenCVImage.hpp"

@implementation OpenCVImage
#pragma mark - Show version Number
+(NSString *) versionNumber {
    return [NSString stringWithFormat:@"OpenCV %s", CV_VERSION];
}

#pragma mark - Convert to grayscale
+(UIImage *) convertToGrayscale: (UIImage *) image {
    cv::Mat imageMat;
    UIImageToMat(image, imageMat);

    if (imageMat.channels() == 1) return image;

    cv::Mat grayMat;
    cv::cvtColor(imageMat, grayMat, CV_BGR2GRAY);

    return MatToUIImage(grayMat);
}

#pragma mark - Classify Image
+(UIImage *) classifyImage: (UIImage *) image {
    cv::Mat colorMat;
    UIImageToMat(image, colorMat);

    cv::Mat grayMat;
    cv::cvtColor(colorMat, grayMat, CV_BGR2GRAY);

    cv::CascadeClassifier classifier;
    const NSString* cascadePath = [[NSBundle mainBundle]
                             pathForResource:@"haarcascade_frontalface_default"
                             ofType:@"xml"];
    classifier.load([cascadePath UTF8String]);

    std::vector<cv::Rect> detections;

    const double scalingFactor = 1.1;
    const int minNeighbors = 2;
    const int flags = 0;
    const cv::Size minimumSize(300, 300);

    classifier.detectMultiScale(
                                grayMat,
                                detections,
                                scalingFactor,
                                minNeighbors,
                                flags,
                                minimumSize
                                );

    if (detections.size() <= 0) {
        return nil;
    }

    for (auto &face : detections) {
        const cv::Point tl(face.x,face.y);
        const cv::Point br = tl + cv::Point(face.width, face.height);
        const cv::Scalar magenta = cv::Scalar(255, 0, 255);

        cv::rectangle(colorMat, tl, br, magenta, 4, 8, 0);
    }

    return MatToUIImage(colorMat);
}

+(UIImage *)imageFromCVMat:(cv::Mat) cvMat {
    NSData *data = [NSData dataWithBytes:cvMat.data length:cvMat.elemSize()*cvMat.total()];
    CGColorSpaceRef colorSpace;
    
    if (cvMat.elemSize() == 1) {
        colorSpace = CGColorSpaceCreateDeviceGray();
    } else {
        colorSpace = CGColorSpaceCreateDeviceRGB();
    }
    
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
    
    CGImageRef imageRef = CGImageCreate(cvMat.cols,                                 //width
                                        cvMat.rows,                                 //height
                                        8,                                          //bits per component
                                        8 * cvMat.elemSize(),                       //bits per pixel
                                        cvMat.step[0],                            //bytesPerRow
                                        colorSpace,                                 //colorspace
                                        kCGImageAlphaNone|kCGBitmapByteOrderDefault,// bitmap info
                                        provider,                                   //CGDataProviderRef
                                        NULL,                                       //decode
                                        false,                                      //should interpolate
                                        kCGRenderingIntentDefault                   //intent
                                        );
    
    
    UIImage *finalImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    CGDataProviderRelease(provider);
    CGColorSpaceRelease(colorSpace);
    
    return finalImage;
}


@end
