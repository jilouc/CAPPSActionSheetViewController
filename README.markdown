## Purpose

This replicates `UIActionSheet` behavior, but using a `UIViewController` instead of a simple view. It also mimics the look and feel of iOS 7 action sheets.

Using a view controller gives the benefits of view controllers containers, auto-rotation.

* iOS 7 style brought to iOS 6
* Block callbacks
* Colors are customizable
* Auto-rotation
* Arbitrary number of items
* **Requires ARC** (use `-fobjc-arc` on non-ARC projects)
* Uses UIKit view controller containment

## Use

Present:

````objc
CAPPSActionSheetViewController *asvc = [[CAPPSActionSheetViewController alloc]
                                            initWithNibName:nil bundle:nil];
    
[asvc setTitle:@"Action Sheet title"];
[asvc addButtonWithTitle:@"Option 1" block:^{
    // Action to perform on tap   
}];
[asvc addButtonWithTitle:@"Option 2" block:^{
    // Action to perform on tap   
}];
// ...
    
[asvc presentInViewController:self completion:nil];
````

and dismiss:

````objc
[asvc dismiss:^{ /* …  */ }];

````

## License

The MIT License (MIT)

Copyright (c) <year> <copyright holders>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

