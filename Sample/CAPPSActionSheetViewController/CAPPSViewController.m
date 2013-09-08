//
//  CAPPSViewController.m
//  CAPPSActionSheetViewController
//
//  Created by Jean-Luc Dagon on 08/09/13.
//  Copyright (c) 2013 Cocoapps. All rights reserved.
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

#import "CAPPSViewController.h"
#import "CAPPSActionSheetViewController.h"

@interface CAPPSViewController ()

@end

@implementation CAPPSViewController

- (void)showActionSheet:(id)sender
{
    CAPPSActionSheetViewController *asvc = [[CAPPSActionSheetViewController alloc]
                                            initWithNibName:nil bundle:nil];
    
    [asvc setTitle:@"Action Sheet title"];
    
    for (NSInteger i = 1; i < 6; i++) {
        [asvc addButtonWithTitle:[NSString stringWithFormat:@"Option %d", i] block:^{
            NSLog(@"Button %d tapped", i);
        }];
    }
    
    [asvc presentInViewController:self completion:nil];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}

@end
