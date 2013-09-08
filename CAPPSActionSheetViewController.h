//
//  CAPPSActionSheetViewController.h
//  Cocoapps Toolbox
//
//  Created by Jean-Luc Dagon on 03/09/13.
//  Copyright (c) 2013 Cocoapps.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CAPPSActionSheetViewController : UIViewController

@property (nonatomic, strong, readonly) UIButton *cancelButton;
@property (nonatomic, strong, readonly) UILabel *titleLabel;

@property (nonatomic, assign) UIEdgeInsets sheetInsets;
@property (nonatomic, assign) CGFloat sheetCornerRadius;
@property (nonatomic, assign) CGFloat buttonHeight;
@property (nonatomic, strong) UIColor *modalBackgroundColor;
@property (nonatomic, strong) UIColor *backgroundColor;

@property (nonatomic, copy) void(^cancelBlock)();

- (void)addButtonWithTitle:(NSString *)title;
- (void)addButtonWithTitle:(NSString *)title block:(void(^)())block;
- (void)mapButtons:(void(^)(UIButton *button, NSInteger index))block;

- (void)presentInViewController:(UIViewController *)viewController completion:(void(^)())completion;
- (void)dismiss:(void(^)())completion;

- (void)setButtonsTintColor:(UIColor *)tintColor;

@end
