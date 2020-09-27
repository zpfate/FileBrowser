//
//  ViewController.m
//  FileBrowser
//
//  Created by Twisted Fate on 2020/9/24.
//

#import "ViewController.h"
#import <WebKit/WebKit.h>
#import <AFNetworking/AFNetworking.h>

@interface ViewController ()<WKUIDelegate,WKNavigationDelegate>

@property (nonatomic, strong) WKWebView *wkWebView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupViews];
    [self loadLocalPDFFile];
}

- (void)setupViews {
    [self.view addSubview:self.wkWebView];
}

- (void)loadLocalPDFFile {
    
    NSString *pdfPath = [[NSBundle mainBundle] pathForResource:@"test" ofType:@"pdf"];
    NSURL *fileUrl = [NSURL fileURLWithPath:pdfPath];
    [self.wkWebView loadFileURL:fileUrl allowingReadAccessToURL:fileUrl];
}

- (void)downloadFile {
    
    NSString *urlString = @"";
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [[AFHTTPSessionManager manager] downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        return [NSURL fileURLWithPath:@""];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
    }];
}

- (WKWebView *)wkWebView {
    if (!_wkWebView) {
        WKUserContentController *userContentController = WKUserContentController.alloc.init;
        WKWebViewConfiguration *configuration = WKWebViewConfiguration.alloc.init;
        configuration.userContentController = userContentController;
        _wkWebView = [WKWebView.alloc initWithFrame:self.view.bounds configuration:configuration];
        _wkWebView.UIDelegate = self;
        _wkWebView.navigationDelegate = self;
    }
    return _wkWebView;
}



@end
