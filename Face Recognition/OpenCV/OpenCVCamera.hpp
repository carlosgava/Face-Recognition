//
//  OpenCVCamera.h
//  Face Recognition
//
//  Created by Carlos Henrique Gava on 16/04/24.
//

#import <opencv2/videoio/cap_ios.h>
#import <opencv2/imgcodecs/imgcodecs.hpp>
#import <opencv2/imgproc/imgproc.hpp>
#import <opencv2/face/facerec.hpp>

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OpenCVCamera : NSObject

-(id)initWithImageView:(UIImageView*)iv;
-(void)startCamera;
-(void)stopCamera;
-(NSArray *)detectedFaces;
-(UIImage *)faceWithIndex:(NSInteger)idx;
+(OpenCVCamera *)faceRecognizerWithFile:(NSString *)path;
-(BOOL)serializeFaceRecognizerParamatersToFile:(NSString *)path;
-(NSString *)predict:(UIImage*)img confidence:(double *)confidence;
-(void)updateWithFace:(UIImage *)img name:(NSString *)name;
-(NSArray *)labels;

@end

NS_ASSUME_NONNULL_END
