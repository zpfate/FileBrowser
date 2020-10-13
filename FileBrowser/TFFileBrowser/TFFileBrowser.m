//
//  TFFileBrowser.m
//  FileBrowser
//
//  Created by Twisted Fate on 2020/10/9.
//

#import "TFFileBrowser.h"
#import "TFFileBrowserViewController.h"
@interface TFFileBrowser ()

@property (nonatomic, strong) NSString *filePath;

@end

@implementation TFFileBrowser

+ (void)browserPDFFile:(NSString *)filePath {
    
    
    
}


/// 通过本地文件
- (CGPDFDocumentRef)createPDF:(NSString *)filePath {
    
    self.filePath = filePath;
    CFStringRef pathRef = CFStringCreateWithCString(NULL, filePath.UTF8String, kCFStringEncodingUTF8);
    CFURLRef urlRef = CFURLCreateWithFileSystemPath(NULL, pathRef, kCFURLPOSIXPathStyle, NO);
    CGPDFDocumentRef documentRef = CGPDFDocumentCreateWithURL(urlRef);
    CFRelease(pathRef);
    CFRelease(urlRef);
    return documentRef;
}

/// 使用网络PDF
- (void)createNetworkPDF:(NSString *)urlString {
    
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:urlString]];
    CFDataRef dataRef = CFBridgingRetain(data);
    CGDataProviderRef providerRef = CGDataProviderCreateWithCFData(dataRef);
//    CGPDFDocumentRef document = CGPDFDocumentCreateWithProvider(providerRef);
    CFRelease(dataRef);
    CGDataProviderRelease(providerRef);
    
}


@end
