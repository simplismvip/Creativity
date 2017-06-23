//
//  JMMediaHelper.h
//  Creativity
//
//  Created by JM Zhao on 2017/6/16.
//  Copyright © 2017年 JMZhao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^SaveVideoCompleted)(NSString *filePath);
typedef void(^SaveVideoFailed)(NSError *error);

@interface JMMediaHelper : NSObject

/**
 *
 *  将图片数组合成GIF
 *
 *  @param path    路径的数组
 *  @param images   完成的回调
 *  @param delayTime  失败的回调
 */

+ (NSURL *)makeAnimatedGIF:(NSString *)path images:(NSArray *)images delayTime:(CGFloat)delayTime;
+(void)saveImagesToVideoWithImages:(NSArray *)images fps:(NSInteger)fps andVideoPath:(NSString *)videoPath completed:(SaveVideoCompleted)completed andFailed:(SaveVideoFailed)failedBlock;

/**
 *
 *  将图片数组合成一段视频
 *
 *  @param images    照片数组
 *  @param inputPath   写入视频路径
 *  @param fps    视频时长
 *  @param block     完成的回调
 */
+ (void)compressImages:(NSArray <UIImage *> *)images inputPath:(NSString *)inputPath fps:(CGFloat)fps completion:(void(^)(NSURL *outurl))block;

/**
 *
 *  将图片数组合成一段视频
 *
 *  @param paths       路径的数组
 *  @param completed   完成的回调
 *  @param failedBlock 失败的回调
 */
+(void)saveImagesToVideoWithImages:(NSArray *)paths
                         completed:(SaveVideoCompleted)completed
                         andFailed:(SaveVideoFailed)failedBlock;

/**
 *
 *  将图片和声音合成一段视频
 *
 *  @param paths       保存图片路径的数组
 *  @param audioPath   声音的路径
 *  @param completed   完成的回调
 *  @param failedBlock 失败的回调
 */
+(void)saveImagesToVideoWithImages:(NSArray *)paths
                      andAudioPath:(NSString *)audioPath
                         completed:(SaveVideoCompleted)completed
                         andFailed:(SaveVideoFailed)failedBlock;
/**
 *
 *  压缩图片到适合上传的大小,默认为150K左右
 *
 *  @param image 图片对象
 *
 *  @return 压缩后的图片二进制数据
 */
+(NSData *)dataFromImageForUpload:(UIImage *)image;

/**
 *  @author Henry
 *
 *  转换图片的大小size
 *
 *  @param image   UIImage原图对象
 *  @param newSize 新的大小size
 *
 *  @return 处理后的UIImage对象
 */
+(UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize;

/**
 *
 *  通过#RRGGBBAA这样的格式获取颜色
 *
 *  @param colorString #RRGGBBAA
 *
 *  @return UIColor
 */
+(UIColor *)getColorFromString:(NSString *)colorString;

//周均按周日第一天开始算，如果有需要自行添加一天到周一至周日
//获取本周第一天
+(NSDate *)getFirstDayOFcurrentWeek;

//获取本周最后一天
+(NSDate *)getLastDayOfCurrentWeek;

/**
 *
 *  将视频裁剪为正方形区域显示
 *
 *  @param videoPath  原视频路径
 *  @param outputPath 输出视频路径
 *  @param type       裁剪方式  0:裁剪取上半部分  1.裁剪后取中间部分  2.裁剪后取下部分
 *
 *  @param completion 完成回调
 */
+(void)converVideoDimissionWithFilePath:(NSString *)videoPath
                          andOutputPath:(NSString *)outputPath
                                cutType:(int)type
                         withCompletion:(void(^)(void))completion;
@end
