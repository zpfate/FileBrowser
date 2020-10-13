//
//  TFPDFBrowserView.h
//  FileBrowser
//
//  Created by Twisted Fate on 2020/10/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TFPDFBrowserView : UIView

- (instancetype)initWithDocumentRef:(CGPDFDocumentRef)documentRef;

@end

NS_ASSUME_NONNULL_END
