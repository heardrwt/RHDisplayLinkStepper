//
//  RHDisplayLinkStepper.h
//
//  Created by Richard Heard on 2/05/13.
//  Copyright (c) 2013 Richard Heard. All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions
//  are met:
//  1. Redistributions of source code must retain the above copyright
//  notice, this list of conditions and the following disclaimer.
//  2. Redistributions in binary form must reproduce the above copyright
//  notice, this list of conditions and the following disclaimer in the
//  documentation and/or other materials provided with the distribution.
//  3. The name of the author may not be used to endorse or promote products
//  derived from this software without specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE AUTHOR ``AS IS'' AND ANY EXPRESS OR
//  IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
//  OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
//  IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
//  INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
//  NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
//  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
//  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
//  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
//  THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
// steps from an index to a second index; usually 0.0 -> 1.0 or 1.0f -> 0.0 over a given duration
// useful for manually animating complex timing relationships.

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>

typedef void (^RHDisplayLinkStepperProgressBlock)(CGFloat progress);
typedef void (^RHDisplayLinkStepperCompletionBlock)(BOOL finished);

@interface RHDisplayLinkStepper : NSObject {
    //ivars are private
    CADisplayLink *_displayLink;
    
    RHDisplayLinkStepperProgressBlock _progressBlock;
    RHDisplayLinkStepperCompletionBlock _completionBlock;
    
    BOOL _running;
    CGFloat _fromProgress;
    CGFloat _toProgress;
    CGFloat _currentProgress;
    
    NSTimeInterval _duration;
    
    CFTimeInterval _startTimestamp;
    CFTimeInterval _mostRecentTimestamp;
}

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
