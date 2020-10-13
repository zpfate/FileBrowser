//
//  TFPDFBrowserViewController.m
//  FileBrowser
//
//  Created by Twisted Fate on 2020/10/13.
//

#import "TFPDFBrowserViewController.h"
#import "TFPDFBrowserView.h"
@interface TFPDFBrowserViewController ()

{
    CGPDFDocumentRef document;
}

@property (nonatomic, assign) NSInteger totoalPages;

@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, strong) TFPDFBrowserView *browserView;

@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation TFPDFBrowserViewController

- (instancetype)initWithPDFFile:(NSString *)filePath {
    self = [super init];
    if (self) {
        [self createPDF:filePath];
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
    
    CGRect frame = self.browserView.frame;
    
    [self.view addSubview:self.browserView];
    self.browserView.center = self.view.center;
    
}


- (void)createPDF:(NSString *)filePath {
    
    CFStringRef path = CFStringCreateWithCString(NULL, filePath.UTF8String, kCFStringEncodingUTF8);
    
    CFURLRef url = CFURLCreateWithFileSystemPath(NULL, path, kCFURLPOSIXPathStyle, NO);
    CFRelease(path);
    document = CGPDFDocumentCreateWithURL(url);
    CFRelease(url);
    
    self.totoalPages = CGPDFDocumentGetNumberOfPages(document);
    self.currentPage = 1;
}


#pragma mark -- Getter

- (TFPDFBrowserView *)browserView {
    if (!_browserView) {
        _browserView = [[TFPDFBrowserView alloc] initWithDocumentRef:document];
        _browserView.backgroundColor = [UIColor whiteColor];
    }
    return _browserView;
}


- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _scrollView.backgroundColor = [UIColor blackColor];
        
    }
    return _scrollView;
}

@end
