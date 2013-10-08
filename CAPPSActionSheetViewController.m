//
//  CAPPSActionSheetViewController.m
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


#import "CAPPSActionSheetViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface CAPPSActionSheetViewController () <UIGestureRecognizerDelegate> {
    UIColor *_buttonsTintColor;
}

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *sheetView;
@property (nonatomic, strong) UIView *buttonsContainerView;

@property (nonatomic, strong) NSMutableDictionary *internalButtons;

@end

#define CAPPS_MAX_VISIBLE_BUTTONS 7

@implementation CAPPSActionSheetViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _sheetInsets = UIEdgeInsetsMake(10.f, 10.f, 10.f, 10.f);
        _sheetCornerRadius = 4.f;
        _buttonHeight = 44.f;
        _internalButtons = @{}.mutableCopy;
        _buttonsTintColor = [UIColor colorWithRed:0.f green:0x7a/255.f blue:1.f alpha:1.f]; // iOS7 blue
        _modalBackgroundColor = [UIColor colorWithWhite:0.f alpha:0.4f];
        _backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)loadView
{
    [super loadView];
    
    _sheetView = [[UIView alloc] initWithFrame:CGRectMake(_sheetInsets.left,
                                                          _sheetInsets.top,
                                                          CGRectGetWidth(self.view.frame) - _sheetInsets.left - _sheetInsets.right,
                                                          CGRectGetHeight(self.view.frame) - _sheetInsets.top - _sheetInsets.bottom)];
    _sheetView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleTopMargin;
    
    _buttonsContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_sheetView.frame), CGRectGetHeight(_sheetView.frame) - _buttonHeight - _sheetInsets.bottom)];
    
    _buttonsContainerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _buttonsContainerView.layer.cornerRadius = _sheetCornerRadius;
    _buttonsContainerView.clipsToBounds = YES;
    _buttonsContainerView.backgroundColor = _backgroundColor;
    [_sheetView addSubview:_buttonsContainerView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, CGRectGetWidth(_sheetView.frame) - 20, 30)];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.textColor = [UIColor colorWithWhite:0.54f alpha:1.f];
    _titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:14.f];
    _titleLabel.numberOfLines = 5;
    _titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleBottomMargin;
    [_buttonsContainerView addSubview:_titleLabel];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_titleLabel.frame), CGRectGetWidth(_buttonsContainerView.frame), CGRectGetHeight(_buttonsContainerView.frame) - CGRectGetMaxY(_titleLabel.frame))];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = YES;
    _scrollView.backgroundColor = _backgroundColor;
    _scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [_buttonsContainerView addSubview:_scrollView];
    
    _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _cancelButton.layer.cornerRadius = _sheetCornerRadius;
    _cancelButton.clipsToBounds = YES;
    _cancelButton.backgroundColor = _backgroundColor;
    _cancelButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:19.f];
    [_cancelButton setTitle:NSLocalizedString(@"Cancel", nil) forState:UIControlStateNormal];
    _cancelButton.frame = CGRectMake(0, CGRectGetHeight(_sheetView.frame) - _buttonHeight, CGRectGetWidth(_sheetView.frame), _buttonHeight);
    _cancelButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleWidth;
    [_cancelButton addTarget:self action:@selector(cancelButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [_sheetView addSubview:_cancelButton];
    
    [self.view addSubview:_sheetView];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissTap:)];
    tap.delegate = self;
    [self.view addGestureRecognizer:tap];
    
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    [self updateButtonFrames];
}

#pragma mark - Customization

- (void)setTitle:(NSString *)title
{
    [super setTitle:title];
    if (!self.view) {
        return;
    }
    _titleLabel.text = title;
}

- (void)addButtonWithTitle:(NSString *)title
{
    [self addButtonWithTitle:title block:nil];
}

- (void)addButtonWithTitle:(NSString *)title block:(void(^)())block
{
    if (!self.view) {
        return;
    }
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_buttonsContainerView.frame), _buttonHeight)];
    containerView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleWidth;
    containerView.backgroundColor = _backgroundColor;
    UIView *separatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(containerView.frame), 1)];
    separatorView.backgroundColor = [UIColor colorWithRed:0xce/255.f green:0xce/255.f blue:0xd6/255.f alpha:1.f];
    separatorView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleBottomMargin;
    [containerView addSubview:separatorView];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 1, CGRectGetWidth(containerView.frame), _buttonHeight - 1);
    btn.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    [btn setTitle:title ?: @"" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:19.f];
    [btn addTarget:self action:@selector(buttonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [containerView addSubview:btn];
    [_scrollView addSubview:containerView];
    
    NSInteger btnTag = [_internalButtons count];
    btn.tag = btnTag;
    
    _internalButtons[@(btnTag)] = @{@"button": btn, @"view": containerView, @"block": block ?: (void(^)())^{}};
    
}

- (void)setButtonsTintColor:(UIColor *)tintColor
{
    _buttonsTintColor = tintColor;
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    if ([self.view respondsToSelector:@selector(setTintColor:)]) {
        [self.view setTintColor:tintColor];
    }
#endif
    [self updateButtons];
}

- (void)mapButtons:(void (^)(UIButton *button, NSInteger index))block
{
    if (!block) {
        return;
    }
    [_internalButtons enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        block(obj[@"button"], [key integerValue]);
    }];
}

#pragma mark Internals

- (void)updateButtons
{
    [self mapButtons:^(UIButton *button, NSInteger index) {
        [button setTitleColor:_buttonsTintColor forState:UIControlStateNormal];
        [button setTitleColor:[_buttonsTintColor colorWithAlphaComponent:0.4f] forState:UIControlStateHighlighted];
    }];
    [self.cancelButton setTitleColor:_buttonsTintColor forState:UIControlStateNormal];
    [self.cancelButton setTitleColor:[_buttonsTintColor colorWithAlphaComponent:0.4f] forState:UIControlStateHighlighted];
}

- (void)updateBackgroundColor
{
    [_internalButtons enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [obj[@"view"] setBackgroundColor:_backgroundColor];
    }];
    _buttonsContainerView.backgroundColor = _backgroundColor;
    _scrollView.backgroundColor = _backgroundColor;
    _cancelButton.backgroundColor = _backgroundColor;
}

- (void)updateButtonFrames
{
    CGSize labelSize = [self.titleLabel sizeThatFits:CGSizeMake(CGRectGetWidth(_titleLabel.frame), CGFLOAT_MAX)];
    
    CGFloat availableHeight = CGRectGetHeight(self.view.bounds) - (2 * _buttonHeight + labelSize.height + 2 *_sheetInsets.bottom + _sheetInsets.top);
    NSInteger maxButtonsDisplayed = (NSInteger)floorf(availableHeight / _buttonHeight);
    
    NSInteger totalButtonCount = [self.internalButtons count];
    NSInteger visibleButtonCount = fmin(maxButtonsDisplayed,
                                        (totalButtonCount > CAPPS_MAX_VISIBLE_BUTTONS) ? CAPPS_MAX_VISIBLE_BUTTONS : totalButtonCount);
    
    CGRect r = _titleLabel.frame;
    r.size.height = labelSize.height + 2 * 10;
    _titleLabel.frame = r;
    
    CGFloat containerHeight = CGRectGetHeight(_titleLabel.frame) + visibleButtonCount * _buttonHeight + (totalButtonCount > visibleButtonCount ? _buttonHeight / 2 : 0);
    r = _buttonsContainerView.frame;
    r.size.height = containerHeight;
    _buttonsContainerView.frame = r;
    
    [_internalButtons enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        UIView *containerView = obj[@"view"];
        NSInteger index = [key integerValue];
        CGRect r = containerView.frame;
        r.origin.y = index * _buttonHeight;
        containerView.frame = r;
    }];
    
    r = _scrollView.frame;
    r.origin.y = CGRectGetMaxY(_titleLabel.frame);
    r.size.height = CGRectGetHeight(_buttonsContainerView.frame) - CGRectGetMinY(r);
    _scrollView.frame = r;
    _scrollView.contentSize = CGSizeMake(CGRectGetWidth(_scrollView.frame), _buttonHeight * totalButtonCount);
    
    CGFloat sheetHeight = containerHeight + _sheetInsets.bottom + _buttonHeight;
    r = _sheetView.frame;
    r.size.height = sheetHeight;
    r.origin.y = CGRectGetHeight(self.view.bounds) - CGRectGetHeight(r) - _sheetInsets.bottom;
    _sheetView.frame = r;
}


#pragma mark - Button actions

- (void)cancelButtonTapped:(UIButton *)btn
{
    [self dismiss:^{
        if (self.cancelBlock) {
            self.cancelBlock();
        }
    }];
}

- (void)buttonTapped:(UIButton *)btn
{
    [self dismiss:^{
        NSDictionary *buttonInfo = _internalButtons[@(btn.tag)];
        void(^buttonBlock)() = buttonInfo[@"block"];
        if (buttonBlock) {
            buttonBlock();
        }
        if (_commonButtonBlock) {
            self.commonButtonBlock(btn.tag);
        }
    }];
}

#pragma mark - Present & Dismiss

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if (CGRectContainsPoint(self.sheetView.frame, [touch locationInView:self.sheetView.superview])) {
        return NO;
    }
    return YES;
}

- (void)dismissTap:(id)sender
{
    [self dismiss:^{
        if (self.cancelBlock) {
            self.cancelBlock();
        }
    }];
}

- (void)presentInViewController:(UIViewController *)viewController completion:(void(^)())completion
{
    viewController.modalPresentationStyle = UIModalPresentationCurrentContext;
    viewController.navigationController.modalPresentationStyle = UIModalPresentationCurrentContext;
    
    [self updateButtonFrames];
    [self updateButtons];
    [self updateBackgroundColor];
    
    _sheetView.hidden = YES;
    
    self.view.backgroundColor = [UIColor clearColor];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    self.view.frame = CGRectMake(0, 0,
                                 CGRectGetWidth(viewController.view.bounds),
                                 CGRectGetHeight(viewController.view.bounds));
    
    [self willMoveToParentViewController:viewController];
    [viewController addChildViewController:self];
    [viewController.view addSubview:self.view];
    
    CGRect r = _sheetView.frame;
    r.origin.y = CGRectGetHeight(self.view.frame);
    _sheetView.frame = r;
    
    _sheetView.hidden = NO;
    
    [UIView animateWithDuration:0.25f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        self.view.backgroundColor = _modalBackgroundColor;
        
        CGRect r = _sheetView.frame;
        r.origin.y = CGRectGetHeight(self.view.frame) - CGRectGetHeight(_sheetView.frame) - 10;
        _sheetView.frame = r;
        
    } completion:^(BOOL finished) {
        if (completion) {
            completion();
        }
    }];
    
}


- (void)dismiss:(void(^)())completion
{
    [UIView animateWithDuration:0.25f delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        self.view.backgroundColor = [UIColor clearColor];
        
        CGRect r = _sheetView.frame;
        r.origin.y = CGRectGetHeight(self.view.frame);
        _sheetView.frame = r;
        
    } completion:^(BOOL finished) {
        
        [self removeFromParentViewController];
        [self didMoveToParentViewController:nil];
        [self.view removeFromSuperview];
        
        if (completion) {
            completion();
        }
    }];
}

#pragma mark - Rotation

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

@end
