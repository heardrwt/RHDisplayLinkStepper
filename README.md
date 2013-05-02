## RHDisplayLinkStepper

A custom, CADisplayLink backed value stepper, perfect for performing complex animations or firing delegate callbacks over a specified period of time.


## Overview

For instance, UIScrollView could use this class to call `scrollViewDidScroll:` as it animates to a new content offset. It currently only supports linear timing, however could easily be extended to perform more complex easing.

## Interface

```objectivec

typedef void (^RHDisplayLinkStepperProgressBlock)(CGFloat progress);
typedef void (^RHDisplayLinkStepperCompletionBlock)(BOOL finished);

@interface RHDisplayLinkStepper : NSObject

@property (nonatomic, readonly) CADisplayLink *displayLink;
@property (nonatomic, readonly) BOOL running;

//forward (0.0f -> 1.0f)
-(void)stepWithDuration:(NSTimeInterval)duration progress:(RHDisplayLinkStepperProgressBlock)progressBlock;
-(void)stepWithDuration:(NSTimeInterval)duration progress:(RHDisplayLinkStepperProgressBlock)progressBlock completion:(RHDisplayLinkStepperCompletionBlock)completionBlock;

//reverse (1.0f -> 0.0f)
-(void)reverseStepWithDuration:(NSTimeInterval)duration progress:(RHDisplayLinkStepperProgressBlock)progressBlock;
-(void)reverseStepWithDuration:(NSTimeInterval)duration progress:(RHDisplayLinkStepperProgressBlock)progressBlock completion:(RHDisplayLinkStepperCompletionBlock)completionBlock;

//custom (variable -> variable)
-(void)stepFrom:(CGFloat)from to:(CGFloat)to withDuration:(NSTimeInterval)duration progress:(RHDisplayLinkStepperProgressBlock)progressBlock;
-(void)stepFrom:(CGFloat)from to:(CGFloat)to withDuration:(NSTimeInterval)duration progress:(RHDisplayLinkStepperProgressBlock)progressBlock completion:(RHDisplayLinkStepperCompletionBlock)completionBlock;

//cancel if currently stepping, calls completion block if set.
-(void)cancel;

@end


```


## Licence
Released under the Modified BSD License. 
(Attribution Required)
<pre>
RHDisplayLinkStepper

Copyright (c) 2013 Richard Heard. All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions
are met:
1. Redistributions of source code must retain the above copyright
notice, this list of conditions and the following disclaimer.
2. Redistributions in binary form must reproduce the above copyright
notice, this list of conditions and the following disclaimer in the
documentation and/or other materials provided with the distribution.
3. The name of the author may not be used to endorse or promote products
derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
</pre>

## iOS version support

This code works on and has been tested on 5.0+. 

Feel free to file issues for anything that doesn't work correctly, or you feel could be improved. 

## Appreciation 

If you find this project useful, buy me a beer the next time you see me, or grab me something from my [**wishlist**](http://www.amazon.com/gp/registry/wishlist/3FWPYC4SEU5QM ). 

