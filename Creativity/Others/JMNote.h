//
//  JMNote.h
//  Creativity
//
//  Created by JM Zhao on 2017/7/6.
//  Copyright © 2017年 JMZhao. All rights reserved.
//

#ifndef JMNote_h
#define JMNote_h
/*
 关于帧率 首先以下几个概念必须弄清楚
 
 1.一个帧就是一个画面
 
 
 
 2.视频有无数个帧组成
 
 
 
 3.表达时间的量  CMTime 的定义：
 
 typedef struct { CMTimeValue value; CMTimeScale timescale; CMTimeFlags flags; CMTimeEpoch epoch; } CMTime;
 
 
 
 
 CMTimeMake(value, timeScale)    //value当前第几帧, timeScale每秒钟多少帧.当前播放时间value/timeScale
 
 CMTimeMakeWithSeconds(a,b)    //a当前时间,b每秒钟多少帧.
 
 
 4.每帧图片所占时间  = 粒度 = 帧率   =  1/timeScale
 
 
 
 5.时间粒度 = 帧率（Frames per Second, FPS）
 
 转换成绝对时间可以用value/timescale = seconds这个公式来计算
 
 
 
 6. 每秒钟多少帧  也就是多少个画面  = timeScale
 
 
 
 
 
 
 
 
 
 先贴如何获取第一帧的代码：
 
 1
 2
 3
 4
 5
 6
 7
 8
 9
 10
 11
 12
 13
 14
 15
 - (UIImage*) getVideoPreViewImage
 {
 AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoPath options:nil];
 AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
 [asset release];
 gen.appliesPreferredTrackTransform = YES;
 CMTime time = CMTimeMakeWithSeconds(0.0, 600);
 NSError *error = nil;
 CMTime actualTime;
 CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
 UIImage *img = [[[UIImage alloc] initWithCGImage:image] autorelease];
 CGImageRelease(image);
 [gen release];
 return img;
 }
 这是很不求甚解的做法，有好多问题都没有考虑到。
 
 一般来说，如果我们打算求第x秒 看如上代码，想都不用想的就去把
 
 1
 CMTime time = CMTimeMakeWithSeconds(0.0, 600);
 改成想要的时间了，但是，跑一下就会发现差强人意。
 
 为什么呢？
 
 我们先要说CMTime 是什么东西。
 
 CMTime
 
 CMTime 是一个用来描述视频时间的结构体。
 
 他有两个构造函数： * CMTimeMake * CMTimeMakeWithSeconds
 
 这两个的区别是 * CMTimeMake(a,b) a当前第几帧, b每秒钟多少帧.当前播放时间a/b * CMTimeMakeWithSeconds(a,b) a当前时间,b每秒钟多少帧.
 
 我们引用例子来说明它：
 
 CMTimeMakeWithSeconds
 1
 2
 3
 4
 Float64 seconds = 5;
 int32_t preferredTimeScale = 600;
 CMTime inTime = CMTimeMakeWithSeconds(seconds, preferredTimeScale);
 CMTimeShow(inTime);
 OUTPUT: {3000/600 = 5.000}
 
 代表当前时间为5s，视频一共有3000帧，一秒钟600帧
 
 CMTimeMake
 1
 2
 3
 4
 int64_t value = 10000;
 int32_t preferredTimeScale = 600;
 CMTime inTime = CMTimeMake(value, preferredTimeScale);
 CMTimeShow(inTime);
 OUTPUT: {10000/600 = 16.667}
 
 代表时间为16.667s, 视频一共1000帧，每秒600帧
 
 其实，在我们这里，我们关心的只有最后那个总时间。 换句话说，我们把那个(0, 600)换成(x, 600) 是没问题的… = =!
 
 requestedTimeTolerance
 
 那么为什么，效果差了这么多呢？ 我们可以把
 
 1
 2
 3
 CGImageRef image = [gen copyCGImageAtTime:time
 actualTime:&actualTime
 error:&error];
 返回的 actualTime 输出一下
 
 1
 CMTimeShow(actualTime)
 就会发现时间差的很远。 这是为什么呢。
 
 首先他的 actualTime 使用的 fps * 1000 当每秒的帧率。 顺路普及下fps的获取方法
 
 1
 float fps = [[[asset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0] nominalFrameRate];
 然后我们来思考为什么要有 requestTime 和 actualTime 呢？ 开始我对这个api 很困惑: 为什么我request的时间 不等于 actual
 
 后来查了一下文档。
 
 当你想要一个时间点的某一帧的时候，他会在一个范围内找，如果有缓存，或者有在索引内的关键帧，就直接返回，从而优化性能。
 
 这个定义范围的API就是 requestedTimeToleranceAfter 和 requestedTimeToleranceBefore
 
 如果我们要精确时间，那么只需要
 
 1
 2
 gen.requestedTimeToleranceAfter = kCMTimeZero;
 gen.requestedTimeToleranceBefore = kCMTimeZero;
 
 
 
 
 
 
 
 
 大家都知道一段视频是有无数个帧组成的，一个帧也就是一个画面。我们利用AVFoundation中的AVAssetWriter合成一段视频，而手中的素材可以是一些图片也可以是实时摄像头截取的照片，怎么把这些图片输出成为视频？视频的长度多少？每个图片所占的时间多长？都要通过CMTime这个结构体设置的参数来确定。
 
 从名字可以推测CMTime是个表达时间的量，它的定义为
 
 1
 typedef struct { CMTimeValue value; CMTimeScale timescale; CMTimeFlags flags; CMTimeEpoch epoch; } CMTime;
 我们需要关心的是前两个成员，value,timescale。第一个是数值，第二个是数值的范围。还是从视频的角度来理解吧，假设现在有一个画面，它出现在第二秒，那么我们即可以用value=2,timescale=1来表达也可以用value=1,timescale=2来表达，区别是第一种情况表示的时间粒度是1秒，而后者是两秒。时间粒度就是我们所说的帧率（Frames per Second, FPS）。要转换成绝对时间可以用value/timescale = seconds这个公式来计算。CMTime有如下两个快捷生成方法：
 
 1
 2
 3
 CMTimeMake(a,b)    //a当前第几帧, b每秒钟多少帧.当前播放时间a/b
 
 CMTimeMakeWithSeconds(a,b)    //a当前时间,b每秒钟多少帧.
 那么如何利用这个参数来定义一个视频的画面？其实第一次使用这个参数，我是错误的。在往下继续探讨之前，先介绍个方法。
 
 1
 - (BOOL)appendPixelBuffer:(CVPixelBufferRef)pixelBuffer withPresentationTime:(CMTime)presentationTime
 简单来说这个方法把图片的像素缓冲输入给视频合成工具AssetWriter中，而该缓冲在视频中出现的时间由(CMTime)presentationTime这个参数设定。
 
 先说个最简单的例子，我有5张图片，现在我要生成5秒视频，那么很容易推导出每个图片所占的粒度也就是帧率为1秒，那么
 
 1
 CMTime presentationTime=CMTimeMake(i,1);
 i分别从0到4生成presentationTime再调用appendPixelBuffer就可以实现我们的例子。这个是最简单的。来个稍微有点挑战性的，现在有2张图片，要合成3秒视频，要求是每张图片在视频中出现的时间等长，那怎么办？
 
 咋看不算难，但是我们注意到，CMTimeMake中两个参数都是整型的，不可能出现2/3这样的分数或者小数形式的值。
 
 1
 2
 3
 4
 CMTime CMTimeMake (
 int64_t value,
 int32_t timescale
 );
 解决方法相信都能想到就是把时间粒度做得更细，假设帧率是2，那么第一张图片就从CMTimeMake(0,2)持续到CMTimeMake(2,2)。第二张图片从CMTimeMake(3,2)持续到CMTimeMake(5,2)。如图1：
 
 
 
 那么实际当中，我们要把这两张图生成三秒的视频，是不是就要把3秒里的6个粒度都填满图片像素？答案是否定的！这个问题非常tricky。假设我们用appendPixelBuffer方法填充了第一个时间粒度CMTimeMake(0,2)，一般理解也就是第一个时间粒度被填满了。这样理解即正确也不正确，第一个粒度确实被填满了，但是后面的粒度也有可能被这个buffer所覆盖，假设我们的第二个像素缓冲填到CMTimeMake(3,2)，那么前面的(1,2),(2,2)两个粒度就不是空的了，而是被第一个buffer覆盖。如图2：
 
 
 
 但是这种粒度扩展的情况也只是存在于后面有新的buffer进行补充，如果到后面视频就结束了，那么该buffer还是只维持在当前的一个粒度里。所以我们调用- (void)endSessionAtSourceTime:(CMTime)endTime这个方法来结束视频时，即使endTime=CMTimeMake(1000,2)，生成的视频也不会是500秒，但是也不是3秒！而是两秒！正如我前面的解释，视频停留在CMTimeMake(3,2)这个粒度就结束了。取巧的办法就是追加最后一个粒度，也就是CMTimeMake(5,2)，那么CMTimeMake(4,2)也就被自动填充了。
 
 另外，还有个特点就是这个粒度其实是可以变的，也就是第二张图片插入时timescale可以不是2。利用这个特点，我们可以轻松实现任何两个图片的过度效果。只需要在两个图片之间以更细化的粒度插入经过处理的过度图片。实现代码如下：
 
 1
 2
 3
 4
 5
 6
 7
 8
 9
 10
 11
 12
 13
 14
 15
 16
 17
 18
 19
 20
 21
 22
 //1
 CMTime fadeTime = CMTimeMake(1, fps*TransitionFrameCount);
 //2
 for (int b = 0; b &amp;lt; FramesToWaitBeforeTransition; b++) {
 presentTime = CMTimeAdd(presentTime, fadeTime);
 }
 //3
 NSInteger framesToFadeCount = TransitionFrameCount - FramesToWaitBeforeTransition;
 for (double j = 1; j &amp;lt; framesToFadeCount; j++) {
 buffer = [self crossFadeImage:[array[i] CGImage]
 toImage:[array[i + 1] CGImage]
 atSize:CGSizeMake(480, 320)
 withAlpha:j/framesToFadeCount];
 
 BOOL appendSuccess = [self appendToAdapter:adaptor
 pixelBuffer:buffer
 atTime:presentTime
 withInput:writerInput];
 presentTime = CMTimeAdd(presentTime, fadeTime);
 
 NSAssert(appendSuccess, @&amp;quot;Failed to append&amp;quot;);
 }
 简单解释一下，第一步计算出过度效果的粒度。
 第二步，得到过度效果开始的时间，其中CMTimeAdd为把当前时间和过度效果的粒度时间相加，注意到相加的两个CMTime的时间粒度是不一样的，出来的结果的timescale为二者粒度的最小公倍数。
 最后，循环增加逐渐过度的效果图片，这里我演示的是通过改变alpha实现的渐变过度。代码很简单：
 
 1
 2
 3
 4
 5
 CGContextDrawImage(context, drawRect, firstImage);
 CGContextBeginTransparencyLayer(context, nil);
 CGContextSetAlpha( context, alpha );
 CGContextDrawImage(context, drawRect, secondImage);
 CGContextEndTransparencyLayer(context);
 把firstImage画到context上，然后覆盖一个透明层，不断调整alpha值把secondImage画上去。
 */

#endif /* JMNote_h */
