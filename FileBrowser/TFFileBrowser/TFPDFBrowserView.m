//
//  TFPDFBrowserView.m
//  FileBrowser
//
//  Created by Twisted Fate on 2020/10/13.
//

#import "TFPDFBrowserView.h"

@interface TFPDFBrowserView ()

{
    CGPDFDocumentRef document;
}

@property (nonatomic, assign) NSInteger currentPage;

@end

@implementation TFPDFBrowserView


- (instancetype)initWithDocumentRef:(CGPDFDocumentRef)documentRef {
    
    CGPDFPageRef page = CGPDFDocumentGetPage(documentRef, 1);
    CGRect rect = CGPDFPageGetBoxRect(page, kCGPDFMediaBox);
    self = [super initWithFrame:rect];
    if (self) {
        _currentPage = 1;
        document = documentRef;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    [[UIColor whiteColor] set];
    CGContextFillRect(context, rect);
    
    /// Quartz坐标系和UIView坐标系不一样
    CGContextTranslateCTM(context, 0.0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGPDFPageRef page = CGPDFDocumentGetPage(document, _currentPage);
    CGAffineTransform pdfTransform = CGPDFPageGetDrawingTransform(page, kCGPDFCropBox, rect, 0, true);
    CGContextConcatCTM(context, pdfTransform);
    CGContextDrawPDFPage(context, page);
}

@end
