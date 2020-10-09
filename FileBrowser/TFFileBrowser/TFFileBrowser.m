//
//  TFFileBrowser.m
//  FileBrowser
//
//  Created by Twisted Fate on 2020/10/9.
//

#import "TFFileBrowser.h"

@interface TFFileBrowser ()<UIPageViewControllerDataSource, UIPageViewControllerDelegate>

@property (nonatomic, strong) UIPageViewController *pageViewController;

@property (nonatomic, strong) NSMutableArray *viewControllers;

@end

@implementation TFFileBrowser

+ (TFFileBrowser *)browserWithUrl:(NSString *)fileUrl {
    
    return [[self alloc] init];
}

/// 通过本地文件
- (void)createPDF:(NSString *)filPath {
    
    CFStringRef path = CFStringCreateWithCString(NULL, filPath.UTF8String, kCFStringEncodingUTF8);
    CFURLRef url = CFURLCreateWithFileSystemPath(NULL, path, kCFURLPOSIXPathStyle, NO);
    CGPDFDocumentRef document = CGPDFDocumentCreateWithURL(url);
    
    CFRelease(path);
    CFRelease(url);
}

/// 使用网络PDF
- (void)createNetworkPDF:(NSString *)urlString {
    
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
    CFDataRef dataRef = CFBridgingRetain(data);
    CGDataProviderRef providerRef = CGDataProviderCreateWithCFData(dataRef);
    CGPDFDocumentRef document = CGPDFDocumentCreateWithProvider(providerRef);
    CFRelease(dataRef);
    CGDataProviderRelease(providerRef);
    
}

#pragma mark -- UIPageViewControllerDataSource

/// 返回前一个页面
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSInteger index = [self.viewControllers indexOfObject:viewController];
    if (index) {
        return self.viewControllers[index--];
    } else {
        return nil;
    }
}

/// 返回后一个页面
- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSInteger index = [self.viewControllers indexOfObject:viewController];
    if (index == NSNotFound || index == self.viewControllers.count - 1) {
        return nil;
    }
    return self.viewControllers[index++];
}

#pragma mark -- UIPageViewControllerDelegate


#pragma mark -- Getter

- (UIPageViewController *)pageViewController {
    
    if (!_pageViewController) {
        /**
         *  UIPageViewControllerTransitionStyle: 翻页的过渡样式
         *  UIPageViewControllerTransitionStylePageCurl 卷曲样式的翻页效果
         *  UIPageViewControllerTransitionStyleScroll 类似ScrollView的滚动效果
         *
         * options:字典类型 参数配置key为UIPageViewControllerOptionSpineLocationKey和UIPageViewControllerOptionInterPageSpacingKey
         * UIPageViewControllerOptionSpineLocationKey定义的是书脊的位置,值对应着UIPageViewControllerSpineLocation这个枚举项 这个key只有在style是翻书效果UIPageViewControllerTransitionStylePageCurl的时候才有作用,
         * UIPageViewControllerOptionInterPageSpacingKey它定义的是两个页面之间的间距(默认间距是0),这个key只有在style是UIScrollView滚动效果UIPageViewControllerTransitionStyleScroll的时候才有作用,
         */
        NSDictionary *optins = @{UIPageViewControllerOptionInterPageSpacingKey : @(UIPageViewControllerSpineLocationMin)};
        _pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:optins];
        _pageViewController.delegate = self;
        _pageViewController.dataSource = self;
    }
    return _pageViewController;
    
}

@end
