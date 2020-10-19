//
//  TFPDFBrowserVC.m
//  FileBrowser
//
//  Created by Twisted Fate on 2020/10/19.
//

#import "TFPDFBrowserVC.h"
#import "TFPDFBrowserView.h"
@interface TFPDFBrowserVC ()<UIScrollViewDelegate>

@property (nonatomic, strong) NSString *filePath;

@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) TFPDFBrowserView *browserView;

@property (nonatomic, assign) CGFloat minZoomScale;

@property (nonatomic, assign) CGFloat maxZoomScale;

@end

@implementation TFPDFBrowserVC

- (instancetype)initWithFilePath:(NSString *)filePath {
    self = [super init];
    if (self) {
        _filePath = filePath;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupViews];
}

#pragma mark -- Private Methods

- (void)setupViews {
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.scrollView];
    
    [self.scrollView addSubview:self.browserView];
    
    /// 保证PDF文件居中显示
    
    /// 算出合适的frame
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = [UIScreen mainScreen].bounds.size.height;
    CGRect frame = self.browserView.frame;
    frame.size.width = frame.size.width > width ? width : frame.size.width;
    frame.size.height = frame.size.width /  self.browserView.frame.size.width * self.browserView.frame.size.height;
    /// 如果算出来的高度高于屏宽
    if (frame.size.height > height) {
        frame.size.height = height;
        frame.size.width = height * (self.browserView.frame.size.width / self.browserView.frame.size.height);
    }
    
    /// 调整缩放比例
    self.minZoomScale = frame.size.width / self.browserView.frame.size.width;
    self.maxZoomScale = 2;
    self.scrollView.minimumZoomScale = self.minZoomScale;
    self.scrollView.maximumZoomScale = self.maxZoomScale;
    self.scrollView.zoomScale = self.minZoomScale;
    
    //右滑手势
    UISwipeGestureRecognizer *rightSwip = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(nextPage)];
    rightSwip.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.scrollView addGestureRecognizer:rightSwip];
    
    //左滑手势
    UISwipeGestureRecognizer *leftSwip = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(lastPage)];
    leftSwip.direction = UISwipeGestureRecognizerDirectionRight;
    [self.scrollView addGestureRecognizer:leftSwip];
    
    //双击
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleClick)];
    doubleTap.numberOfTapsRequired = 2;
    [self.scrollView addGestureRecognizer:doubleTap];
    [doubleTap requireGestureRecognizerToFail:doubleTap];
}

- (void)doubleClick {
    
    CGFloat scale = self.scrollView.zoomScale;
    [UIView animateWithDuration:.5 animations:^{
        self.scrollView.zoomScale = (scale == self.minZoomScale) ? self.maxZoomScale : self.minZoomScale;
    }];
}

/// 上一页
- (void)lastPage {

    [self.browserView lastPage];
}

/// 下一页
- (void)nextPage {
    
    [self.browserView nextPage];
}

#pragma mark -- UIScrollViewDelegate

/// 返回要缩放的控件
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.browserView;
}

/// 已经缩放
- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width) ? (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height) ? (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    self.browserView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX, scrollView.contentSize.height * 0.5 + offsetY - 64);
}

#pragma mark -- Getter

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _scrollView.backgroundColor = [UIColor blackColor];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (TFPDFBrowserView *)browserView {
    if (!_browserView) {
        _browserView = [[TFPDFBrowserView alloc] initWithFilePath:_filePath];
    }
    return _browserView;
}

@end
