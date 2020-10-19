//
//  TFPDFBrowserView.m
//  FileBrowser
//
//  Created by Twisted Fate on 2020/10/19.
//

#import "TFPDFBrowserView.h"

@interface TFPDFBrowserView ()
{
    CGPDFDocumentRef document;
}
@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, assign) NSInteger totalPages;

@end

@implementation TFPDFBrowserView

- (instancetype)initWithFilePath:(NSString *)filePath {
    
    CGPDFDocumentRef documentRef = [self createPDFDocument:filePath];
    CGPDFPageRef pageRef = CGPDFDocumentGetPage(documentRef, 1);
    CGRect rect = CGPDFPageGetBoxRect(pageRef, kCGPDFMediaBox);
    
    self = [super initWithFrame:rect];
    if (self) {
        document = documentRef;
        _currentPage = 1;
        _totalPages = CGPDFDocumentGetNumberOfPages(document);
    }
    return self;
}

- (void)dealloc {
    CGPDFDocumentRelease(document);
}

- (void)drawRect:(CGRect)rect {
    
    /// 获取上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    /// 设置白色
    [[UIColor whiteColor] set];
    /// 填充颜色
    CGContextFillRect(context, rect);

    /// Quartz坐标系与UIView的坐标系相反
    
    /// 平移坐标系
    CGContextTranslateCTM(context, 0.0, rect.size.height);
    /// 缩放
    CGContextScaleCTM(context, 1.0, -1.0);
    CGPDFPageRef page = CGPDFDocumentGetPage(document, _currentPage);
    CGAffineTransform transform = CGPDFPageGetDrawingTransform(page, kCGPDFCropBox, rect, 0, true);
    /// 使用 transform 变换矩阵对 CGContextRef 的坐标系统执行变换
    CGContextConcatCTM(context, transform);
    
    /// 绘制
    CGContextDrawPDFPage(context, page);
}

#pragma mark -- Private Methods

- (CGPDFDocumentRef)createPDFDocument:(NSString *)filePath {
    
    CFStringRef path = CFStringCreateWithCString(NULL,filePath.UTF8String, kCFStringEncodingUTF8);
    CFURLRef url = CFURLCreateWithFileSystemPath(NULL, path, kCFURLPOSIXPathStyle, NO);
    CFRelease(path);
    CGPDFDocumentRef documentRef = CGPDFDocumentCreateWithURL(url);
    CFRelease(url);
    return documentRef;
}

- (void)reloadBrowser {
    [self setNeedsDisplay];
}

#pragma mark -- Public Methods

- (void)lastPage {
    
    if (self.currentPage == 1) {
        return;
    }
    self.currentPage--;
    [self transitionWithType:@"pageUnCurl" subtype:kCATransitionFromRight];
    [self reloadBrowser];
}

- (void)nextPage {
    
    if (self.currentPage == self.totalPages) {
        return;
    }
    self.currentPage++;
    [self reloadBrowser];
    [self transitionWithType:@"pageCurl" subtype:kCATransitionFromRight];

}

- (void)transitionWithType:(NSString *)type subtype:(CATransitionSubtype)subType {

    CATransition *animation = [CATransition animation];
    /// 设置动画时长
    animation.duration = 0.8;
    /// 设置动画样式
    /***
     使用CATransitionType
     kCATransitionPush 推入效果
     kCATransitionMoveIn 移入效果
     kCATransitionReveal 截开效果
     kCATransitionFade 渐入渐出效果
     或者直接使用以下字符串:
     cube 方块
     suckEffect 三角
     rippleEffect 水波抖动
     pageCurl 上翻页
     pageUnCurl 下翻页
     oglFlip 上下翻转
     cameraIrisHollowOpen 镜头快门开
     cameraIrisHollowClose 镜头快门开
    */
    animation.type = type;
    
    /// 设置动画方向
    /**
     kCATransitionFromRight     从右边
     kCATransitionFromLeft      从左边
     kCATransitionFromTop       从上面
     kCATransitionFromBottom    从下面
     */
    if (subType) {
        animation.subtype = subType;
    }
    /// 动画的速度
    /** CAMediaTimingFunction:
        kCAMediaTimingFunctionLinear 匀速
        kCAMediaTimingFunctionEaseIn 慢进快出
        kCAMediaTimingFunctionEaseOut 快进慢出
        kCAMediaTimingFunctionEaseInEaseOut 慢进慢出 中间加速
        kCAMediaTimingFunctionDefault 默认
     */
    animation.timingFunction = [CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseIn];
    [self.layer addAnimation:animation forKey:@"animation"];
}

@end
