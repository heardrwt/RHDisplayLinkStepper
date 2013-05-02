//
//  RHDisplayLinkStepper.m
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

//require arc
#if !(defined(__has_feature) && __has_feature(objc_arc))
    #error This file requires ARC! (add -fobjc-arc to this files compiler flags)
#endif

#import "RHDisplayLinkStepper.h"

@interface RHDisplayLinkStepper ()

-(void)_startDisplayLink;
-(void)_stopDisplayLink;
-(void)_displayLinkFired:(CADisplayLink*)displayLink;

@end

@implementation RHDisplayLinkStepper

@synthesize displayLink=_displayLink;
@synthesize running=_running;

-(id)init{
    self = [super init];
    if (self){
        //setup
    }
    return self;
}

-(void)dealloc{
    _displayLink = nil;
}

#pragma mark - public

//forward
-(void)stepWithDuration:(NSTimeInterval)duration progress:(RHDisplayLinkStepperProgressBlock)progressBlock{
    [self stepWithDuration:duration progress:progressBlock completion:nil];
}
-(void)stepWithDuration:(NSTimeInterval)duration progress:(RHDisplayLinkStepperProgressBlock)progressBlock completion:(RHDisplayLinkStepperCompletionBlock)completionBlock{
    [self stepFrom:0.0f to:1.0f withDuration:duration progress:progressBlock completion:completionBlock];
}

//reverse
-(void)reverseStepWithDuration:(NSTimeInterval)duration progress:(RHDisplayLinkStepperProgressBlock)progressBlock{
    [self reverseStepWithDuration:duration progress:progressBlock completion:nil];
}
-(void)reverseStepWithDuration:(NSTimeInterval)duration progress:(RHDisplayLinkStepperProgressBlock)progressBlock completion:(RHDisplayLinkStepperCompletionBlock)completionBlock{
    [self stepFrom:1.0f to:0.0f withDuration:duration progress:progressBlock completion:completionBlock];
}

//custom
-(void)stepFrom:(CGFloat)from to:(CGFloat)to withDuration:(NSTimeInterval)duration progress:(RHDisplayLinkStepperProgressBlock)progressBlock{
    [self stepFrom:from to:to withDuration:duration progress:progressBlock completion:nil];
}

-(void)stepFrom:(CGFloat)from to:(CGFloat)to withDuration:(NSTimeInterval)duration progress:(RHDisplayLinkStepperProgressBlock)progressBlock completion:(RHDisplayLinkStepperCompletionBlock)completionBlock{
    [self _stopDisplayLink];
    if (!progressBlock){
        [NSException raise:NSInvalidArgumentException format:@"Error: progressBlock must not be NULL"];
        return;
    }
    
    //if our duration is zero, just fire and forget
    if (duration <= 0.0f){
        progressBlock(to);
        if (completionBlock) completionBlock(YES);
        return;
    }
    
    _fromProgress = from;
    _currentProgress = from;
    _toProgress = to;
    
    _duration = duration;
    _progressBlock = progressBlock ? [progressBlock copy] : NULL;
    _completionBlock = completionBlock ? [completionBlock copy] : NULL;
    
    [self _startDisplayLink];
}

-(void)cancel{
    [self _stopDisplayLink];
}

#pragma mark - display link
-(void)_startDisplayLink{
    if (_displayLink){
        [self _stopDisplayLink];
    }
    
    _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(_displayLinkFired:)];
    [_displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
    
    _running = YES;
    
    //perform initial progress update
    _mostRecentTimestamp = _startTimestamp = CACurrentMediaTime();
    _progressBlock(_currentProgress);
    
}

-(void)_stopDisplayLink{
    if (!_displayLink) return;
    
    [_displayLink invalidate];
    _displayLink = nil;
    
    _running = NO;
    
    //call our final completion block
    if (_completionBlock) _completionBlock( _currentProgress == _toProgress);
    
    //cleanup
    _progressBlock = NULL;
    _completionBlock = NULL;
}

-(void)_displayLinkFired:(CADisplayLink*)displayLink{
    //compare fire time to previous fire time and calculate percentage completion
    _mostRecentTimestamp = [displayLink timestamp];
    CFTimeInterval delta = _mostRecentTimestamp - _startTimestamp;
    CGFloat percent = MAX(MIN(delta / _duration, 1.0f), 0.0f);
    
    //update current progress
    _currentProgress = _fromProgress + ((_toProgress - _fromProgress) * percent);

    //call our progress block with our new currentProgress value
    _progressBlock(_currentProgress);
    
    //if completed, call _stopDisplayLink; this in turn calls our completion block, if required
    if (_currentProgress == _toProgress){
        [self _stopDisplayLink];
    }
}


@end
