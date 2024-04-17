//
//  UIImageView.m
//  Face Recognition
//
//  Created by Carlos Henrique Gava on 17/04/24.
//

#import "UIImage.hpp"

using namespace cv;

@implementation UIImage (OpenCV)

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

-(cv::Mat)cvMatRepresentationColor
{
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(self.CGImage);
    CGFloat cols = self.size.width;
    CGFloat rows = self.size.height;
    
    cv::Mat color(rows, cols, CV_8UC4);
    
    CGContextRef contextRef = CGBitmapContextCreate(color.data,
                                                    cols,
                                                    rows,
                                                    8,
                                                    color.step[0],
                                                    colorSpace,
                                                    kCGImageAlphaNoneSkipLast | kCGBitmapByteOrderDefault);
    
    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), self.CGImage);
    CGContextRelease(contextRef);
    
    return color;
}


-(cv::Mat)cvMatRepresentationGray
{
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(self.CGImage);
    int cols = self.size.width;
    int rows = self.size.height;
    
    Mat gray(rows, cols, CV_8UC1);
    
    NSLog(@"cols %d rows %d step %zu", cols, rows, gray.step[0]);
    CGContextRef contextRef = CGBitmapContextCreate(gray.data,
                                                    cols,
                                                    rows,
                                                    8,
                                                    gray.step[0],
                                                    colorSpace,
                                                    kCGBitmapByteOrderDefault);
    
    CGContextDrawImage(contextRef, CGRectMake(0, 0, cols, rows), self.CGImage);
    CGContextRelease(contextRef);
    
    return gray;
}

@end
