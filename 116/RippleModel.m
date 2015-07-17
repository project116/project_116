/*
 File: RippleModel.m
 Abstract: Ripple model class that simulates the ripple effect.
 Version: 1.0
 
 Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple
 Inc. ("Apple") in consideration of your agreement to the following
 terms, and your use, installation, modification or redistribution of
 this Apple software constitutes acceptance of these terms.  If you do
 not agree with these terms, please do not use, install, modify or
 redistribute this Apple software.
 
 In consideration of your agreement to abide by the following terms, and
 subject to these terms, Apple grants you a personal, non-exclusive
 license, under Apple's copyrights in this original Apple software (the
 "Apple Software"), to use, reproduce, modify and redistribute the Apple
 Software, with or without modifications, in source and/or binary forms;
 provided that if you redistribute the Apple Software in its entirety and
 without modifications, you must retain this notice and the following
 text and disclaimers in all such redistributions of the Apple Software.
 Neither the name, trademarks, service marks or logos of Apple Inc. may
 be used to endorse or promote products derived from the Apple Software
 without specific prior written permission from Apple.  Except as
 expressly stated in this notice, no other rights or licenses, express or
 implied, are granted by Apple herein, including but not limited to any
 patent rights that may be infringed by your derivative works or by other
 works in which the Apple Software may be incorporated.
 
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE
 MAKES NO WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION
 THE IMPLIED WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS
 FOR A PARTICULAR PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND
 OPERATION ALONE OR IN COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL
 OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
 SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
 INTERRUPTION) ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION,
 MODIFICATION AND/OR DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED
 AND WHETHER UNDER THEORY OF CONTRACT, TORT (INCLUDING NEGLIGENCE),
 STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN ADVISED OF THE
 POSSIBILITY OF SUCH DAMAGE.
 
 Copyright (C) 2013 Apple Inc. All Rights Reserved.
 
 */

#import "RippleModel.h"

@interface RippleModel () {
    unsigned int poolWidth;
    unsigned int poolHeight;
    unsigned int touchRadius;
    
    float texCoordFactorS;
    float texCoordOffsetS;
    float texCoordFactorT;
    float texCoordOffsetT;
    
    // ripple coefficients
    float *rippleCoeff;
    
    // ripple simulation buffers
    float *rippleSource;
    float *rippleDest;
    
}

@end

@implementation RippleModel

- (void)initRippleMap
{
    // +2 for padding the border
    memset(rippleSource, 0, (poolWidth+2)*(poolHeight+2)*sizeof(float));
    memset(rippleDest, 0, (poolWidth+2)*(poolHeight+2)*sizeof(float));
}

- (void)initRippleCoeff
{
    for (int y=0; y<=2*touchRadius; y++)
    {
        for (int x=0; x<=2*touchRadius; x++)
        {        
            float distance = sqrt((x-touchRadius)*(x-touchRadius)+(y-touchRadius)*(y-touchRadius));
            
            if (distance <= touchRadius)
            {
                float factor = (distance/touchRadius);

                // goes from -512 -> 0
                rippleCoeff[y*(touchRadius*2+1)+x] = -(cos(factor*M_PI)+1.f) * 256.f;
            }
            else 
            {
                rippleCoeff[y*(touchRadius*2+1)+x] = 0.f;   
            }
        }
    }    
}



- (void)freeBuffers
{
    free(rippleCoeff);
    
    free(rippleSource);
    free(rippleDest);
    
}

- (id)initWithPoolWidth:(unsigned int)width PoolHeight:(unsigned int)height touchRadius:(unsigned int)radius factorS:(float)factorS factorT:(float)factorT OffsetS:(float)offsetS OffsetT:(float)offsetT
{
    self = [super init];
    
    if (self)
    {
        poolWidth = width;
        poolHeight = height;
        touchRadius = radius;
        
        texCoordFactorS = factorS;
        texCoordOffsetS = offsetS;
            
        texCoordFactorT = factorT;
        texCoordOffsetT = offsetT;
        
        rippleCoeff = (float *)malloc((touchRadius*2+1)*(touchRadius*2+1)*sizeof(float));
        
        // +2 for padding the border
        rippleSource = (float *)malloc((poolWidth+2)*(poolHeight+2)*sizeof(float));
        rippleDest = (float *)malloc((poolWidth+2)*(poolHeight+2)*sizeof(float));
        
        if (!rippleSource || !rippleDest)
        {
            [self freeBuffers];
            return nil;
        }
        
        [self initRippleMap];
        
        [self initRippleCoeff];
        
    }
    
    return self;
}

- (void)runSimulation:(float*)rippleTexCoords
{
   
    
    // first pass for simulation buffers...
    for (int y=0; y<poolHeight; y++){
        for (int x=0; x<poolWidth; x++)
        {
            // * - denotes current pixel
            //
            //       a 
            //     c * d
            //       b 
            
            // +1 to both x/y values because the border is padded
            float a = rippleSource[(y)*(poolWidth+2) + x+1];
            float b = rippleSource[(y+2)*(poolWidth+2) + x+1];
            float c = rippleSource[(y+1)*(poolWidth+2) + x];
            float d = rippleSource[(y+1)*(poolWidth+2) + x+2];
            
            float result = (a + b + c + d)/2.f - rippleDest[(y+1)*(poolWidth+2) + x+1];
            
            result -= result/32.f;
            
            rippleDest[(y+1)*(poolWidth+2) + x+1] = result;
        }            
    };
    
    // second pass for modifying texture coord
    for (int y=0; y<poolHeight; y++){
        for (int x=0; x<poolWidth; x++)
        {
            // * - denotes current pixel
            //
            //       a
            //     c * d
            //       b
            
            // +1 to both x/y values because the border is padded
            float a = rippleDest[(y)*(poolWidth+2) + x+1];
            float b = rippleDest[(y+2)*(poolWidth+2) + x+1];
            float c = rippleDest[(y+1)*(poolWidth+2) + x];
            float d = rippleDest[(y+1)*(poolWidth+2) + x+2];
            
            float s_offset = ((b - a) / 2048.f);
            float t_offset = ((c - d) / 2048.f);
            
            // clamp
            s_offset = (s_offset < -0.5f) ? -0.5f : s_offset;
            t_offset = (t_offset < -0.5f) ? -0.5f : t_offset;
            s_offset = (s_offset > 0.5f) ? 0.5f : s_offset;
            t_offset = (t_offset > 0.5f) ? 0.5f : t_offset;
            
            float s_tc = (float)y/(poolHeight-1) * texCoordFactorS + texCoordOffsetS;
            float t_tc = (1.f - (float)x/(poolWidth-1)) * texCoordFactorT + texCoordOffsetT;
            
            rippleTexCoords[(y*poolWidth+x)*2+0] = s_tc + s_offset;
            rippleTexCoords[(y*poolWidth+x)*2+1] = t_tc + t_offset;
        }
    };
    
    float *pTmp = rippleDest;
    rippleDest = rippleSource;
    rippleSource = pTmp;    
}

- (void)initiateRippleAtLocation:(CGPoint)location
{
    unsigned int xIndex = (unsigned int)(location.x );
    unsigned int yIndex = (unsigned int)(location.y );
    
    for (int y=(int)yIndex-(int)touchRadius; y<=(int)yIndex+(int)touchRadius; y++)
    {
        for (int x=(int)xIndex-(int)touchRadius; x<=(int)xIndex+(int)touchRadius; x++)
        {        
            if (x>=0 && x<poolWidth &&
                y>=0 && y<poolHeight)
            {
                // +1 to both x/y values because the border is padded
                rippleSource[(poolWidth+2)*(y+1)+x+1] += rippleCoeff[(y-(yIndex-touchRadius))*(touchRadius*2+1)+x-(xIndex-touchRadius)];
            }
        }
    }    
}

- (void)dealloc
{
    [self freeBuffers];
}

@end
