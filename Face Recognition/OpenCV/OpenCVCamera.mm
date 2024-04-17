//
//  OpenCVCamera.m
//  Face Recognition
//
//  Created by Carlos Henrique Gava on 16/04/24.
//



#import "OpenCVCamera.hpp"
#import "OpenCVImage.hpp"
#import "UIImage.hpp"

using namespace cv;

@interface OpenCVCamera () <CvVideoCameraDelegate>
    @property (nonatomic, assign) CGFloat scale;
@end

@implementation OpenCVCamera
{
    CvVideoCamera * videoCamera;
    std::vector<cv::Mat> _faceImgs;
    std::vector<cv::Rect> _faceRects;
    cv::Ptr<OpenCVCamera> _faceClassifier;
}

-(id)initWithImageView:(UIImageView*)iv
{
    videoCamera = [[CvVideoCamera alloc] initWithParentView:iv];
    
    videoCamera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionFront;
    videoCamera.defaultAVCaptureSessionPreset = AVCaptureSessionPreset352x288;
    videoCamera.defaultAVCaptureVideoOrientation = AVCaptureVideoOrientationPortrait;
    videoCamera.defaultFPS = 30;
    videoCamera.grayscaleMode = NO;
    
    videoCamera.delegate = self;
    
    return self;
}

#ifdef __cplusplus
-(void)processImage:(Mat&)image
{
    Mat image_copy;
    cvtColor(image, image_copy, COLOR_BGRA2BGR);
    bitwise_not(image_copy, image_copy);
    cvtColor(image_copy, image, COLOR_BGR2BGRA);
}
#endif

-(void)startCamera
{
    [videoCamera start];
}

-(void)stopCamera
{
    [videoCamera stop];
}

-(NSArray *)detectedFaces {
    NSMutableArray *facesArray = [NSMutableArray array];
    for( std::vector<cv::Rect>::const_iterator r = _faceRects.begin(); r != _faceRects.end(); r++ ) {
        CGRect faceRect = CGRectMake(_scale*r->x/480., _scale*r->y/640., _scale*r->width/480., _scale*r->height/640.);
        [facesArray addObject:[NSValue valueWithCGRect:faceRect]];
    }
    return facesArray;
}

-(UIImage *)faceWithIndex:(NSInteger)idx {
    cv::Mat img = self->_faceImgs[idx];
    UIImage *ret = [UIImage imageFromCVMat: img];
    
    return ret;
}


@end
