//
//  JMMediaHelper.m
//  Creativity
//
//  Created by JM Zhao on 2017/6/16.
//  Copyright © 2017年 JMZhao. All rights reserved.
//

#import "JMMediaHelper.h"
#import <ImageIO/ImageIO.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreVideo/CoreVideo.h>
#include <ifaddrs.h>
#include <arpa/inet.h>

#define MEGA_BYTE 100*1024

static OSType pixelFormatType = kCVPixelFormatType_32ARGB;

@implementation JMMediaHelper

// delayTime = duration/images.count --> fps = 1/delayTime *
+ (NSURL *)makeAnimatedGIF:(NSString *)path images:(NSArray *)images delayTime:(CGFloat)delayTime
{
//    CGFloat preCount = delayTime/images.count;
    
    NSUInteger const kFrameCount = images.count;
    NSDictionary *fileProperties = @{(__bridge id)kCGImagePropertyGIFDictionary:@{(__bridge id)kCGImagePropertyGIFLoopCount: @0,}};
    NSDictionary *frameProperties = @{(__bridge id)kCGImagePropertyGIFDictionary:@{(__bridge id)kCGImagePropertyGIFDelayTime: [NSNumber numberWithFloat:delayTime]}};
    
    NSURL *fileURL = [NSURL fileURLWithPath:path];
    CGImageDestinationRef destination = CGImageDestinationCreateWithURL((__bridge CFURLRef)fileURL, kUTTypeGIF, kFrameCount, NULL);
    CGImageDestinationSetProperties(destination, (__bridge CFDictionaryRef)fileProperties);
    
    for (UIImage *imagePath in images) {
        
        CGImageDestinationAddImage(destination, imagePath.CGImage, (__bridge CFDictionaryRef)frameProperties);
    }
    
    if (!CGImageDestinationFinalize(destination)) {
        
        NSLog(@"destination");
    }
    
    CFRelease(destination);
    return fileURL;
}

+ (UIImage *)croppedImage:(UIImage *)image bounds:(CGRect)bounds
{
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], bounds);
    UIImage *croppedImage = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return croppedImage;
}

+ (UIImage *)clipImage:(UIImage *)image ScaleWithsize:(CGSize)asize
{
    UIImage *newimage;
    if (nil == image) {
        newimage = nil;
    }
    else{
        CGSize oldsize = image.size;
        CGRect rect;
        if (asize.width/asize.height > oldsize.width/oldsize.height) {
            rect.size.width = asize.width;
            rect.size.height = asize.width*oldsize.height/oldsize.width;
            rect.origin.x = 0;
            rect.origin.y = (asize.height - rect.size.height)/2;
        }
        else{
            rect.size.width = asize.height*oldsize.width/oldsize.height;
            rect.size.height = asize.height;
            rect.origin.x = (asize.width - rect.size.width)/2;
            rect.origin.y = 0;
        }
        UIGraphicsBeginImageContext(asize);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextClipToRect(context, CGRectMake(0, 0, asize.width, asize.height));
        CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
        UIRectFill(CGRectMake(0, 0, asize.width, asize.height));//clear background
        [image drawInRect:rect];
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    return newimage;
}

+ (CVPixelBufferRef )pixelBufferFromCGImage:(CGImageRef)image size:(CGSize)size duration:(int)duration
{
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], kCVPixelBufferCGImageCompatibilityKey,
                             [NSNumber numberWithBool:YES], kCVPixelBufferCGBitmapContextCompatibilityKey, nil];
    CVPixelBufferRef pxbuffer = NULL;
    CVReturn status = CVPixelBufferCreate(kCFAllocatorDefault, size.width, size.height, kCVPixelFormatType_32ARGB, (__bridge CFDictionaryRef) options, &pxbuffer);
    
    NSParameterAssert(status == kCVReturnSuccess && pxbuffer != NULL);
    
    CVPixelBufferLockBaseAddress(pxbuffer, 0);
    void *pxdata = CVPixelBufferGetBaseAddress(pxbuffer);
    NSParameterAssert(pxdata != NULL);
    
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pxdata, size.width, size.height, 8, 4*size.width, rgbColorSpace, kCGImageAlphaPremultipliedFirst);
    NSParameterAssert(context);
    CGContextDrawImage(context, CGRectMake(0, 0, CGImageGetWidth(image), CGImageGetHeight(image)), image);
    CGColorSpaceRelease(rgbColorSpace);
    CGContextRelease(context);
    CVPixelBufferUnlockBaseAddress(pxbuffer, 0);
    
    return pxbuffer;
}


/*
 帧率  X 总照片数 = 总时间 = 每张照片时间 * 实际照片数
 
 每张照片时间 * 实际照片数 = 总时间
 
 总照片数 =  每张照片时间 * 实际照片数 / 帧率
 
 每样照片各几张 =  总照片数 / 实际照片数 = 每张照片时间 * 实际照片数 / 帧率 / 实际照片数 = 每张照片时间 * 帧率
 */

/**
 *  多张图片合成视频
 *
 */
+ (void)compressImages:(NSArray <UIImage *> *)images inputPath:(NSString *)inputPath fps:(CGFloat)fps completion:(void(^)(NSURL *outurl))block
{
    if (images.count<2) {return;}
    
    CGFloat duration;
    int framess;
    if (fps>0) {
        duration = images.count * fps;
        framess = 1/fps;
    }else {
        duration = images.count * 0.8;
        framess = (int)1/0.8;
    }
    
    
    //先裁剪图片
    NSMutableArray *imageArray = [NSMutableArray array];
    for (UIImage *image in images)
    {
        CGRect rect = CGRectMake(0, 0,image.size.width, image.size.height);
        if (rect.size.width < rect.size.height)
        {
            rect.origin.y = (rect.size.height - rect.size.width)/2;
            rect.size.height = rect.size.width;
        }else
        {
            rect.origin.x = (rect.size.width - rect.size.height)/2;
            rect.size.width = rect.size.height;
        }
        
        //裁剪
        UIImage *newImage = [self croppedImage:image bounds:rect];
        
        // 缩放
        UIImage *finalImage = [self clipImage:newImage ScaleWithsize:CGSizeMake(640, 640)];
        [imageArray addObject:finalImage];
    }
    
    NSURL *exportUrl = [NSURL fileURLWithPath:inputPath];
    CGSize size = CGSizeMake(640,640);//定义视频的大小
    __block AVAssetWriter *videoWriter = [[AVAssetWriter alloc] initWithURL:exportUrl fileType:AVFileTypeQuickTimeMovie error:nil];
    
    NSDictionary *videoSettings = [NSDictionary dictionaryWithObjectsAndKeys:AVVideoCodecH264, AVVideoCodecKey,
                                   [NSNumber numberWithInt:size.width], AVVideoWidthKey,
                                   [NSNumber numberWithInt:size.height], AVVideoHeightKey, nil];
    AVAssetWriterInput *writerInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeVideo outputSettings:videoSettings];
    
    NSDictionary *sourcePixelBufferAttributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:kCVPixelFormatType_32ARGB], kCVPixelBufferPixelFormatTypeKey, nil];
    
    AVAssetWriterInputPixelBufferAdaptor *adaptor = [AVAssetWriterInputPixelBufferAdaptor
                                                     assetWriterInputPixelBufferAdaptorWithAssetWriterInput:writerInput sourcePixelBufferAttributes:sourcePixelBufferAttributesDictionary];
    NSParameterAssert(writerInput);
    NSParameterAssert([videoWriter canAddInput:writerInput]);
    
    if ([videoWriter canAddInput:writerInput])
        NSLog(@"");
    else
        NSLog(@"");
    
    [videoWriter addInput:writerInput];
    [videoWriter startWriting];
    [videoWriter startSessionAtSourceTime:kCMTimeZero];
    
    //合成多张图片为一个视频文件
    dispatch_queue_t dispatchQueue = dispatch_queue_create("mediaInputQueue", NULL);
    
    int __block frame = 0;
    [writerInput requestMediaDataWhenReadyOnQueue:dispatchQueue usingBlock:^{
        while ([writerInput isReadyForMoreMediaData])
        {
            if(++frame > duration * framess)
            {
                [writerInput markAsFinished];
                if(videoWriter.status == AVAssetWriterStatusWriting){
                    NSCondition *cond = [[NSCondition alloc] init];
                    [cond lock];
                    [videoWriter finishWritingWithCompletionHandler:^{
                        [cond lock];
                        [cond signal];
                        [cond unlock];
                    }];
                    [cond wait];
                    [cond unlock];
                    !block?:block(exportUrl);
                }
                break;
            }
            CVPixelBufferRef buffer = NULL;
            
            int idx = (int)(frame/framess * images.count/duration);
            if (idx >= images.count) {
                idx = (int)(images.count - 1);
            }
            buffer = (CVPixelBufferRef)[self.class pixelBufferFromCGImage:[[imageArray objectAtIndex:idx] CGImage] size:size duration:duration];
            if (buffer)
            {
                if(![adaptor appendPixelBuffer:buffer withPresentationTime:CMTimeMake(frame, framess)])
                {
                    NSLog(@"fail");
                }else
                {
                    NSLog(@"success:%d",frame);
                }
                CFRelease(buffer);
            }
        }
    }];
    
}

+(void)saveImagesToVideoWithImages:(NSArray *)paths completed:(SaveVideoCompleted)completed andFailed:(SaveVideoFailed)failedBlock{
    [self saveImagesToVideoWithImages:paths
                         andAudioPath:nil
                            completed:completed
                            andFailed:failedBlock];
}

// fps = frame/s, duration = images.count/*fps

+(void)saveImagesToVideoWithImages:(NSArray *)images fps:(NSInteger)fps andVideoPath:(NSString *)videoPath completed:(SaveVideoCompleted)completed andFailed:(SaveVideoFailed)failedBlock
{
    //数据为空就不需要了
    if(!images && images.count == 0) return;
    unlink([videoPath UTF8String]);
    
    __block NSError *error = nil;
    UIImage *first = [images firstObject];
    CGSize frameSize = first.size;
    
    AVAssetWriter *videoWriter =[[AVAssetWriter alloc] initWithURL:[NSURL fileURLWithPath:videoPath] fileType:AVFileTypeQuickTimeMovie error:&error];
    NSParameterAssert(videoWriter);
    if(error) NSLog(@"error =%@", [error localizedDescription]);
    
    NSDictionary *videoSettings =[NSDictionary dictionaryWithObjectsAndKeys:AVVideoCodecH264,AVVideoCodecKey, [NSNumber numberWithInt:frameSize.width],AVVideoWidthKey,[NSNumber numberWithInt:frameSize.height],AVVideoHeightKey,nil];
    AVAssetWriterInput *writerInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeVideo outputSettings:videoSettings];
    
    NSDictionary*sourcePixelBufferAttributesDictionary =[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:kCVPixelFormatType_32ARGB],kCVPixelBufferPixelFormatTypeKey,nil];
    
    AVAssetWriterInputPixelBufferAdaptor __block *adaptor =[AVAssetWriterInputPixelBufferAdaptor assetWriterInputPixelBufferAdaptorWithAssetWriterInput:writerInput sourcePixelBufferAttributes:sourcePixelBufferAttributesDictionary];
    NSParameterAssert(writerInput);
    NSParameterAssert([videoWriter canAddInput:writerInput]);
    
    if ([videoWriter canAddInput:writerInput])
        [videoWriter addInput:writerInput];
    else
        NSLog(@"failed add input");
    
    [videoWriter startWriting];
    [videoWriter startSessionAtSourceTime:kCMTimeZero];
    
    //开始合成图片
    dispatch_queue_t dispatchQueue =dispatch_queue_create("mediaInputQueue",NULL);
    int __block frame =0;
    
    [writerInput requestMediaDataWhenReadyOnQueue:dispatchQueue usingBlock:^{
        while([writerInput isReadyForMoreMediaData]){
            if(++frame >= [images count] ){
                [writerInput markAsFinished];
                if(videoWriter.status == AVAssetWriterStatusWriting){
                    NSCondition *cond = [[NSCondition alloc] init];
                    [cond lock];
                    [videoWriter finishWritingWithCompletionHandler:^{
                        [cond lock];
                        [cond signal];
                        [cond unlock];
                    }];
                    [cond wait];
                    [cond unlock];
                    
                    !completed?:completed(videoPath);
                }
                break;
            }
            
            UIImage *info = [images objectAtIndex:frame];
            CVPixelBufferRef buffer = [self pixelBufferFromCGImage:info.CGImage size:frameSize];
            if (buffer){
                if(![adaptor appendPixelBuffer:buffer withPresentationTime:CMTimeMake(frame,(int)fps)]){
                    if(failedBlock)
                        failedBlock(error);
                    CFRelease(buffer);
                }
                CFRelease(buffer);
            }
            else{
                CFRelease(buffer);
            }
        }
    }];
}

+(void)saveImagesToVideoWithImages:(NSArray *)paths
                      andAudioPath:(NSString *)audioPath
                         completed:(SaveVideoCompleted)completed
                         andFailed:(SaveVideoFailed)failedBlock{
    //数据为空就不需要了
    if(!paths && paths.count == 0) return;
    
    long long timeString = [[NSDate date] timeIntervalSince1970];
    NSString *fileName = [NSString stringWithFormat:@"video%llu.mp4",timeString];
    NSString *videoPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:fileName];
    unlink([videoPath UTF8String]);
    
    __block NSError *error = nil;
    NSString *firstImage = [paths firstObject];
    
    //如果传的是相对的路径
    if(![firstImage hasPrefix:NSHomeDirectory()]){
        //自己处理，依据情况不同
    }
    UIImage *first = [UIImage imageWithContentsOfFile:firstImage];
    CGSize frameSize = first.size;
    
    AVAssetWriter *videoWriter =[[AVAssetWriter alloc]initWithURL:[NSURL fileURLWithPath:videoPath]
                                                         fileType:AVFileTypeQuickTimeMovie
                                                            error:&error];
    NSParameterAssert(videoWriter);
    if(error)
        NSLog(@"error =%@", [error localizedDescription]);
    
    NSDictionary *videoSettings =[NSDictionary dictionaryWithObjectsAndKeys:AVVideoCodecH264,AVVideoCodecKey,
                                  [NSNumber numberWithInt:frameSize.width],AVVideoWidthKey,
                                  [NSNumber numberWithInt:frameSize.height],AVVideoHeightKey, [NSNumber numberWithFloat:1.0],AVVideoMaxKeyFrameIntervalDurationKey,nil];
    AVAssetWriterInput *writerInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeVideo outputSettings:videoSettings];
    
    NSDictionary*sourcePixelBufferAttributesDictionary =[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:kCVPixelFormatType_32ARGB],kCVPixelBufferPixelFormatTypeKey,nil];
    
    AVAssetWriterInputPixelBufferAdaptor __block *adaptor =[AVAssetWriterInputPixelBufferAdaptor
                                                            assetWriterInputPixelBufferAdaptorWithAssetWriterInput:writerInput sourcePixelBufferAttributes:sourcePixelBufferAttributesDictionary];
    NSParameterAssert(writerInput);
    NSParameterAssert([videoWriter canAddInput:writerInput]);
    
    if ([videoWriter canAddInput:writerInput])
        [videoWriter addInput:writerInput];
    else
        NSLog(@"failed add input");
    
    [videoWriter startWriting];
    [videoWriter startSessionAtSourceTime:kCMTimeZero];
    
    //开始合成图片
    dispatch_queue_t dispatchQueue =dispatch_queue_create("mediaInputQueue",NULL);
    int __block frame =0;
    
    [writerInput requestMediaDataWhenReadyOnQueue:dispatchQueue usingBlock:^{
        while([writerInput isReadyForMoreMediaData]){
            if(++frame >= [paths count] ){
                [writerInput markAsFinished];
                [videoWriter finishWritingWithCompletionHandler:^{
                    [self addAudioToFileAtPath:videoPath andAudioPath:audioPath Success:^(NSString *filePath) {
                        if(completed){
                            completed(filePath);
                        }
                    } failed:^(NSError *error) {
                        if(failedBlock)
                            failedBlock(error);
                    }];
                }];
                break;
            }
            
            UIImage *info = [UIImage imageWithContentsOfFile:[paths objectAtIndex:frame]];
            CVPixelBufferRef buffer = [self pixelBufferFromCGImage:info.CGImage size:frameSize];
            if (buffer){
                if(![adaptor appendPixelBuffer:buffer withPresentationTime:CMTimeMake(frame,24)]){
                    if(failedBlock)
                        failedBlock(error);
                    CFRelease(buffer);
                }
                CFRelease(buffer);
            }
            else{
                CFRelease(buffer);
            }
        }
    }];
}

+(CVPixelBufferRef)pixelBufferFromCGImage:(CGImageRef)image size:(CGSize)size{
    CGSize frameSize = CGSizeMake(CGImageGetWidth(image), CGImageGetHeight(image));
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys: @YES, kCVPixelBufferCGImageCompatibilityKey, @YES, kCVPixelBufferCGBitmapContextCompatibilityKey, nil];
    CVPixelBufferRef pxbuffer = NULL;
    CVReturn status = CVPixelBufferCreate(kCFAllocatorDefault, frameSize.width, frameSize.height, pixelFormatType, (__bridge CFDictionaryRef)options, &pxbuffer);
    NSParameterAssert(status == kCVReturnSuccess && pxbuffer != NULL);
    
    CVPixelBufferLockBaseAddress(pxbuffer, 0);
    void *pxdata = CVPixelBufferGetBaseAddress(pxbuffer);
    
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    CGBitmapInfo bitmapInfo = kCGImageAlphaNoneSkipFirst & kCGBitmapAlphaInfoMask;
    
    //NSUInteger bytesPerRow = 4 * frameSize.width;
    NSUInteger bitsPerComponent = 8;
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(pxbuffer);
    
    CGContextRef context = CGBitmapContextCreate(pxdata, frameSize.width, frameSize.height, bitsPerComponent, bytesPerRow, rgbColorSpace, bitmapInfo);
    CGContextDrawImage(context, CGRectMake(0, 0, frameSize.width, frameSize.height), image);
    CGColorSpaceRelease(rgbColorSpace);
    CGContextRelease(context);
    CVPixelBufferUnlockBaseAddress(pxbuffer, 0);
    
    return pxbuffer;
}


//向无声视频文件中加入声音
+(void)addAudioToFileAtPath:(NSString *)vidoPath andAudioPath:(NSString *)audioPath Success:(SaveVideoCompleted)successBlock failed:(SaveVideoFailed)failedBlock{
    AVMutableComposition* mixComposition = [AVMutableComposition composition];
    
    NSURL* audio_inputFileUrl = [NSURL fileURLWithPath:audioPath];
    NSURL* video_inputFileUrl = [NSURL fileURLWithPath:vidoPath];
    
    NSArray *paths =NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *outputFilePath =[[paths objectAtIndex:0]stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.mov",@"testPlay"]];
    NSURL* outputFileUrl = [NSURL fileURLWithPath:outputFilePath];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:outputFilePath])
        [[NSFileManager defaultManager] removeItemAtPath:outputFilePath error:nil];
    
    AVURLAsset* audioAsset = [[AVURLAsset alloc]initWithURL:audio_inputFileUrl options:nil];
    CMTimeRange audio_timeRange = CMTimeRangeMake(kCMTimeZero, audioAsset.duration);
    AVMutableCompositionTrack *b_compositionAudioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
    [b_compositionAudioTrack insertTimeRange:audio_timeRange ofTrack:[[audioAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0] atTime:kCMTimeZero error:nil];
    
    
    AVURLAsset* videoAsset = [[AVURLAsset alloc]initWithURL:video_inputFileUrl options:nil];
    CMTimeRange video_timeRange = CMTimeRangeMake(kCMTimeZero,videoAsset.duration);
    AVMutableCompositionTrack *a_compositionVideoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
    if ([videoAsset tracksWithMediaType:AVMediaTypeVideo].count != 0) {
        [a_compositionVideoTrack insertTimeRange:video_timeRange ofTrack:[[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] atTime:kCMTimeZero error:nil];
    }
    
    audioAsset = nil;
    videoAsset = nil;
    
    AVAssetExportSession __block *  _assetExport = [[AVAssetExportSession alloc] initWithAsset:mixComposition presetName:AVAssetExportPresetHighestQuality];
    _assetExport.outputFileType = AVFileTypeQuickTimeMovie;
    _assetExport.outputURL = outputFileUrl;
    
    [_assetExport exportAsynchronouslyWithCompletionHandler:^(void ){
        switch (_assetExport.status){
            case AVAssetExportSessionStatusCompleted:{
                if(successBlock)
                    successBlock(outputFilePath);
                break;
            }
            case AVAssetExportSessionStatusFailed:{
                if(failedBlock)
                    failedBlock(_assetExport.error);
                break;
            }
            case AVAssetExportSessionStatusCancelled:{
                
                break;
            }
            case AVAssetExportSessionStatusExporting:{
            }
                break;
            case AVAssetExportSessionStatusUnknown:{
            }
                break;
            case AVAssetExportSessionStatusWaiting:{
            }
                break;
        }
        
        _assetExport=nil;
    }];
}

+(void)convertVideoToGifWithVideo:(NSString *)videoPath completed:(SaveVideoCompleted)completed andFailed:(SaveVideoFailed)failedBlock{
    NSString *dealPath = @"";
    __block NSError *error = nil;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        //暂未实现方法
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!error && completed) {
                completed(dealPath);
            }
            
            if(error && failedBlock){
                failedBlock(error);
            }
        });
    });
}

+(NSData *)dataFromImageForUpload:(UIImage *)image{
    NSData  *data = UIImageJPEGRepresentation(image, 1);
    double compressQuality = (double)MEGA_BYTE/(CGFloat)data.length;
    if(compressQuality < 0 ){
        data = UIImageJPEGRepresentation(image, compressQuality);
    }
    
    CGFloat screenWidth = 720;
    CGFloat imageWidth = MIN(image.size.width, image.size.height);
    CGFloat ratio = imageWidth / screenWidth;
    
    UIImage *dealImage = [UIImage imageWithData:data];
    if(ratio > 1){
        CGSize newSize = CGSizeMake(image.size.width / ratio, image.size.height / ratio);
        dealImage = [self imageWithImage:dealImage scaledToSize:newSize];
    }
    
    return UIImageJPEGRepresentation(dealImage, compressQuality>1?1:compressQuality*2);
}

+(UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize{
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

+(UIColor *)getColorFromString:(NSString *)colorString{
    long x;
    NSString *_str;
    //如果是八位
    if([colorString length] == 9){
        //取前两位alpha值
        NSString *alpha = [colorString substringToIndex:3];
        
        //取后面的几位颜色值
        NSString *color = [colorString substringFromIndex:3];
        const char *cStr = [color cStringUsingEncoding:NSASCIIStringEncoding];
        x = strtol(cStr+1, NULL, 16);
        //_str = [NSString stringWithFormat:@"#%@",color];
        
        return [self colorWithHex:(UInt32)x withAlpha:alpha];
    }
    //如果是6位的颜色
    else if([colorString length] == 7){
        const char *cStr = [colorString cStringUsingEncoding:NSASCIIStringEncoding];
        x = strtol(cStr+1, NULL, 16);
        _str = @"#FF";
    }
    //如果格式不对就直接返回黑色颜色
    else
        return [UIColor blackColor];
    return [self colorWithHex:(UInt32)x withAlpha:_str];
}

+(UIColor *)colorWithHex:(UInt32)col withAlpha:(NSString*)alphaStr
{
    unsigned int r, g, b;
    b = col & 0xFF;
    g = (col >> 8) & 0xFF;
    r = (col >> 16) & 0xFF;
    
    const char* aStr = [alphaStr cStringUsingEncoding:NSASCIIStringEncoding];
    long value = strtol(aStr+1, NULL, 16);
    CGFloat _alpha = (float)(value & 0xFF)/255.0f;
    
    return [UIColor colorWithRed:(float)r/255.0f green:(float)g/255.0f blue:(float)b/255.0f alpha:_alpha];
}

//获取本周第一天
+(NSDate *)getFirstDayOFcurrentWeek{
    NSDate *today = [NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *weekdayComponents =
    [gregorian components:(NSCalendarUnitDay | NSCalendarUnitWeekday) fromDate:today];
    NSInteger weekday = [weekdayComponents weekday];
    
    NSDate *firstDate = [today dateByAddingTimeInterval:60*60*24 * (-weekday+1)];
    
    return firstDate;
}

//获取本周最后一天
+(NSDate *)getLastDayOfCurrentWeek{
    NSDate *today = [NSDate date];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *weekdayComponents =
    [gregorian components:(NSCalendarUnitDay | NSCalendarUnitWeekday) fromDate:today];
    NSInteger weekday = [weekdayComponents weekday];
    
    NSDate *firstDate = [today dateByAddingTimeInterval:60*60*24 * (7-weekday)];
    
    return firstDate;
}

+(void)converVideoDimissionWithFilePath:(NSString *)videoPath
                          andOutputPath:(NSString *)outputPath
                                cutType:(int)type
                         withCompletion:(void (^)(void))completion{
    //获取原视频
    AVAsset *asset = [AVAsset assetWithURL:[NSURL fileURLWithPath:videoPath]];
    
    //创建视频轨道信息
    AVAssetTrack *clipVideoTrack = [[asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    
    //创建视频分辨率等一些设置
    AVMutableVideoComposition* videoComposition = [AVMutableVideoComposition videoComposition];
    videoComposition.frameDuration = CMTimeMake(1, 30);
    //设置渲染的宽高分辨率,均为视频的自然高度
    videoComposition.renderSize = CGSizeMake(clipVideoTrack.naturalSize.height, clipVideoTrack.naturalSize.height);
    
    //创建视频的构造信息
    AVMutableVideoCompositionInstruction *instruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    instruction.timeRange = CMTimeRangeMake(kCMTimeZero, CMTimeMakeWithSeconds(60, 30));
    
    AVMutableVideoCompositionLayerInstruction* transformer = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:clipVideoTrack];
    
    CGAffineTransform t1;
    switch (type) {
        case 0:{
            //将裁剪后保留的区域设置为视频顶部
            t1 = CGAffineTransformMakeTranslation(clipVideoTrack.naturalSize.height, 0 );
        }
            break;
        case 1:{
            //将裁剪后保留的区域设置为视频中间部分
            t1 = CGAffineTransformMakeTranslation(clipVideoTrack.naturalSize.height, -(clipVideoTrack.naturalSize.width - clipVideoTrack.naturalSize.height) /2 );
        }
            break;
        case 2:{
            //将裁剪后保留的区域设置为视频下面部分
            t1 = CGAffineTransformMakeTranslation(clipVideoTrack.naturalSize.height, (clipVideoTrack.naturalSize.width - clipVideoTrack.naturalSize.height) /2);
        }
            break;
        default:{
            //将裁剪后保留的区域设置为视频中间部分
            t1 = CGAffineTransformMakeTranslation(clipVideoTrack.naturalSize.height, -(clipVideoTrack.naturalSize.width - clipVideoTrack.naturalSize.height) /2 );
        }
            break;
    }
    
    //保证视频为垂直正确的方向
    CGAffineTransform t2 = CGAffineTransformRotate(t1, M_PI_2);
    
    CGAffineTransform finalTransform = t2;
    [transformer setTransform:finalTransform atTime:kCMTimeZero];
    
    //先添加tranform层的构造信息，再添加分辨率信息
    instruction.layerInstructions = [NSArray arrayWithObject:transformer];
    videoComposition.instructions = [NSArray arrayWithObject: instruction];
    
    //移除掉之前所存在的视频信息
    [[NSFileManager defaultManager]  removeItemAtURL:[NSURL fileURLWithPath:outputPath] error:nil];
    
    //开始进行导出视频
    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:asset presetName:AVAssetExportPresetHighestQuality] ;
    exporter.videoComposition = videoComposition;
    exporter.outputURL = [NSURL fileURLWithPath:outputPath];
    exporter.outputFileType = AVFileTypeQuickTimeMovie;
    
    [exporter exportAsynchronouslyWithCompletionHandler:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            //导出完成后执行回调
            if(completion)
                completion();
        });
    }];
}

@end
