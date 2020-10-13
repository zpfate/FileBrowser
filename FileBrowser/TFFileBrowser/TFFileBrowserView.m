//
//  TFFileBrowserView.m
//  FileBrowser
//
//  Created by Twisted Fate on 2020/10/9.
//

#import "TFFileBrowserView.h"

@interface TFFileBrowserView ()

@property (nonatomic, strong) NSString *filePath;

@end

@implementation TFFileBrowserView

- (instancetype)initWithFrame:(CGRect)frame filePath:(NSString *)filePath {
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
 
    CGContextRef context = UIGraphicsGetCurrentContext();
    [[UIColor whiteColor] set];
    CGContextFillRect(context, rect);
    
}

@end
