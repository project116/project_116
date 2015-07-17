//
//  116TextDrawelement.m
//  116
//
//  Created by baidu on 15/4/2.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#import "116TextDrawelement.h"
#import <CoreText/CoreText.h>
#import "Utils116.h"
#import <OpenGLES/ES1/gl.h>

@implementation _116TextDrawelement

-(_116TextDrawelement*) initWithText:(NSString *)text ElementRect:(CGRect)rect1 TextRect:(CGRect)rect2 UIFont:(UIFont *)font TextureNumStart:(unsigned int)number Program:(GLuint)_program Matrix:(GLKMatrix4)matrix
{
    stringTobeDraw = text;
    elementRect = rect1;
    insideRect = rect2;
    model2ImageMatrix = matrix;
    poolHeight = rect1.size.height/4;
    poolWidth = rect1.size.width/4;
    vertexbuffer = (GLfloat *)malloc(poolWidth*poolHeight*2*sizeof(GLfloat));
    texturebuffer = (GLfloat *)malloc(poolWidth*poolHeight*2*sizeof(GLfloat));
    Indicies = (GLushort *)malloc((poolHeight-1)*(poolWidth*2+2)*sizeof(GLushort));
    stringfont = font;
    textureNumStart = number;
    program = _program;
    stepArray = [[NSMutableArray alloc]init];
    ImageArray = [[NSMutableArray alloc]init];
    vertexCount = (poolHeight-1)*(poolWidth*2+2)*sizeof(GLushort)/sizeof(*Indicies);
    
    [self GetBackUpUIImage];
    [self initMesh];
    return self;
}

-(void) AddStep:(_116TextDrawingStep*)step
{
    [stepArray addObject:step];
}

-(void) SetStepArray:(NSMutableArray*)array
{
    [stepArray addObjectsFromArray:array];
}

-(void) GetBackUpUIImage
{
    NSString *str = stringTobeDraw;
    NSMutableAttributedString *mabstring = [[NSMutableAttributedString alloc]initWithString:str];
    
    [mabstring beginEditing];
    
    
    //对同一段字体进行多属性设置
    //红色
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithObject:(id)[UIColor blackColor].CGColor forKey:(id)kCTForegroundColorAttributeName];
    //斜体
    CTFontRef font = CTFontCreateWithName((CFStringRef)stringfont.fontName, 80, NULL);
    [attributes setObject:(__bridge id)font forKey:(id)kCTFontAttributeName];
    
    [mabstring addAttributes:attributes range:NSMakeRange(0, mabstring.length)];
    
    
    
    NSRange kk = NSMakeRange(0, 4);
    
    NSDictionary * dc = [mabstring attributesAtIndex:0 effectiveRange:&kk];
    
    [mabstring endEditing];
    
    NSLog(@"value = %@",dc);
    
    
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)mabstring);
    
    CGMutablePathRef Path = CGPathCreateMutable();
    
    CGPathAddRect(Path, NULL ,insideRect);
    
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), Path, NULL);
    
    //获取当前(View)上下文以便于之后的绘画，这个是一个离屏。
    UIGraphicsBeginImageContextWithOptions(elementRect.size, YES, 1.0);
    CGContextRef _context = UIGraphicsGetCurrentContext();
    
    
    CGContextSetTextMatrix(_context , CGAffineTransformIdentity);
    
    //压栈，压入图形状态栈中.每个图形上下文维护一个图形状态栈，并不是所有的当前绘画环境的图形状态的元素都被保存。图形状态中不考虑当前路径，所以不保存
    //保存现在得上下文图形状态。不管后续对context上绘制什么都不会影响真正得屏幕。
    CGContextSaveGState(_context);
    
    //x，y轴方向移动
    CGContextTranslateCTM(_context , 0 ,elementRect.size.height);
    
    //缩放x，y轴方向缩放，－1.0为反向1.0倍,坐标系转换,沿x轴翻转180度
    CGContextScaleCTM(_context, 1.0 ,-1.0);
    
    
    //    CGContextSetStrokeColorWithColor(_context, [UIColor green].CGColor);
    //    CGContextSetFillColorWithColor(_context, [UIColor greenColor].CGColor);
    
    
    
    
    CGContextSetRGBFillColor(_context, 1, 1, 1, 1);
    CGContextFillRect(_context, elementRect);
    CGContextStrokePath(_context);
    
    CTFrameDraw(frame,_context);
    
    CGPathRelease(Path);
    CFRelease(framesetter);
    
        
        //[self.layer renderInContext:UIGraphicsGetCurrentContext()];
        stringImageBackUp = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    UIImage* tmp, *tmp1, *tmp2, *tmp3;
    tmp = stringImageBackUp;
    [ImageArray addObject:tmp];
    tmp1 = [Utils116 GetgaussianBlurImage:tmp];
    tmp1 = [Utils116 GetgaussianBlurImage:tmp1];
    tmp1 = [Utils116 GetgaussianBlurImage:tmp1];
    tmp1 = [Utils116 GetgaussianBlurImage:tmp1];
    tmp1 = [Utils116 GetgaussianBlurImage:tmp1];
    [ImageArray addObject:tmp1];
    tmp2 = [Utils116 GetgaussianBlurImage:tmp1];
    tmp2 = [Utils116 GetgaussianBlurImage:tmp2];
    tmp2 = [Utils116 GetgaussianBlurImage:tmp2];
    tmp2 = [Utils116 GetgaussianBlurImage:tmp2];
    tmp2 = [Utils116 GetgaussianBlurImage:tmp2];
    [ImageArray addObject:tmp2];
    tmp3 = [Utils116 GetgaussianBlurImage:tmp2];
    tmp3 = [Utils116 GetgaussianBlurImage:tmp3];
    tmp3 = [Utils116 GetgaussianBlurImage:tmp3];
    tmp3 = [Utils116 GetgaussianBlurImage:tmp3];
    tmp3 = [Utils116 GetgaussianBlurImage:tmp3];
    tmp3 = [Utils116 GetgaussianBlurImage:tmp3];
    [ImageArray addObject:tmp3];

}

-(void) Bindtexture:(int)step
{
    if (stepArray.count <= step) {
        step = stepArray.count - 1;
    }
    int sampleIndex = [(_116TextDrawingStep*)[stepArray objectAtIndex:step] getSampleIndex];
    glActiveTexture(GL_TEXTURE0);
        
        // 1
    if (ImageArray.count <= sampleIndex) {
        sampleIndex = ImageArray.count - 1;
    }
    UIImage * image = [ImageArray objectAtIndex:sampleIndex];
    CGImageRef spriteImage = image.CGImage;
    spriteImage = [Utils116 CGImageRotatedByAngle:spriteImage angle:90.0f];
    if (!spriteImage) {
            NSLog(@"Failed to load image %@", @"image");
            exit(1);
        }
        
        
        
        // 2
    size_t _width = CGImageGetWidth(spriteImage);
    size_t _height = CGImageGetHeight(spriteImage);
        
    GLubyte * spriteData = (GLubyte *) calloc(_width*_height*4, sizeof(GLubyte));
        
    CGContextRef spriteContext = CGBitmapContextCreate(spriteData, _width, _height, 8, _width*4,
                                                           CGImageGetColorSpace(spriteImage), kCGImageAlphaPremultipliedLast);
        
        // 3
    CGContextDrawImage(spriteContext, CGRectMake(0, 0, _width, _height), spriteImage);
    CGContextRelease(spriteContext);
        
        // 4
    GLuint texName;
    glGenTextures(1, &texName);
    glBindTexture(GL_TEXTURE_2D, texName);
        
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
        
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, _width, _height, 0, GL_RGBA, GL_UNSIGNED_BYTE, spriteData);
        
    free(spriteData);
        
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_CLAMP_TO_EDGE);
    glTexParameterf(GL_TEXTURE_2D, GL_TEXTURE_WRAP_T, GL_CLAMP_TO_EDGE);
        
        // Get uniform locations.
    int location = glGetUniformLocation(program, "SamplerRGB");
    glUniform1i(location, 0);
}

- (void)initMesh
{
    texCoordFactorS = 1.f;
    texCoordOffsetS = 0.f;
    
    texCoordFactorT = 1.f;
    texCoordOffsetT = 0.f;
    unsigned int index1 = 0;
    unsigned int index2 = 0;
    for (int i=0; i<poolHeight; i++)
    {
        for (int j=0; j<poolWidth; j++)
        {
            index1 = (i*poolWidth+j)*2+0;
            index2 = (i*poolWidth+j)*2+1;
            
            vertexbuffer[index1] = -1.f + j*(2.f/(poolWidth-1));
            vertexbuffer[index2] = 1.f - i*(2.f/(poolHeight-1));
            
            texturebuffer[index1] = (float)i/(poolHeight-1) * texCoordFactorS + texCoordOffsetS;
            texturebuffer[index2] = (1.f - (float)j/(poolWidth-1)) * texCoordFactorT + texCoordOffsetT;
            
        }
    }
    
    unsigned int index = 0;
    for (int i=0; i<poolHeight-1; i++)
    {
        for (int j=0; j<poolWidth; j++)
        {
            if (i%2 == 0)
            {
                // emit extra index to create degenerate triangle
                if (j == 0)
                {
                    Indicies[index] = i*poolWidth+j;
                    index++;
                }
                
                Indicies[index] = i*poolWidth+j;
                index++;
                Indicies[index] = (i+1)*poolWidth+j;
                index++;
                
                // emit extra index to create degenerate triangle
                if (j == (poolWidth-1))
                {
                    Indicies[index] = (i+1)*poolWidth+j;
                    index++;
                }
            }
            else
            {
                // emit extra index to create degenerate triangle
                if (j == 0)
                {
                    Indicies[index] = (i+1)*poolWidth+j;
                    index++;
                }
                
                Indicies[index] = (i+1)*poolWidth+j;
                index++;
                Indicies[index] = i*poolWidth+j;
                index++;
                
                // emit extra index to create degenerate triangle
                if (j == (poolWidth-1))
                {
                    Indicies[index] = i*poolWidth+j;
                    index++;
                }
            }
        }
    }

}

- (void)setupBuffers
{
    
    glGenBuffers(1, &_indexVBO);
    glBindBuffer(GL_ELEMENT_ARRAY_BUFFER, _indexVBO);
    glBufferData(GL_ELEMENT_ARRAY_BUFFER, (poolHeight-1)*(poolWidth*2+2)*sizeof(GLushort), Indicies, GL_STATIC_DRAW);
    
    
    glGenBuffers(1, &_positionVBO);
    glBindBuffer(GL_ARRAY_BUFFER, _positionVBO);
    glBufferData(GL_ARRAY_BUFFER, poolWidth*poolHeight*2*sizeof(GLfloat), vertexbuffer, GL_STATIC_DRAW);
        
    glEnableVertexAttribArray(ATTRIB_VERTEX);
    glVertexAttribPointer(ATTRIB_VERTEX, 2, GL_FLOAT, GL_FALSE, 2*sizeof(GLfloat), 0);
    
    
    if (_ripple)
    {
        //for (int i = 0; i < 5; i ++) {
            [_ripple runSimulation:texturebuffer];
        //}
    }
    else
    {
        
    }
    glGenBuffers(1, &_texcoordVBO);
    glBindBuffer(GL_ARRAY_BUFFER, _texcoordVBO);
    glBufferData(GL_ARRAY_BUFFER, poolWidth*poolHeight*2*sizeof(GLfloat), texturebuffer, GL_DYNAMIC_DRAW);
        
    glEnableVertexAttribArray(ATTRIB_TEXCOORD);
    glVertexAttribPointer(ATTRIB_TEXCOORD, 2, GL_FLOAT, GL_FALSE, 2*sizeof(GLfloat), 0);
    return;
}

-(void) DrawStep:(int)stepIndex
{
    int tmp = stepIndex%10;
    stepIndex = stepIndex/10;
    if (stepArray.count <= stepIndex) {
        return;
    }
    if (!((_116TextDrawingStep*)[stepArray objectAtIndex:stepIndex]).canbeDraw) {
        return;
    }
    [self Bindtexture:stepIndex];
    
    
    
    int location = glGetUniformLocation(program, "ModelViewMatirx");

    
    glUniformMatrix4fv(location, 1, GL_FALSE, GLKMatrix4Multiply(model2ImageMatrix,((_116TextDrawingStep*)[stepArray objectAtIndex:stepIndex]).model2ImageMatrix).m);
    if (!_ripple) {
        _ripple = [[RippleModel alloc]initWithPoolWidth:poolWidth PoolHeight:poolHeight touchRadius:5 factorS:texCoordFactorS factorT:texCoordFactorT OffsetS:texCoordOffsetS OffsetT:texCoordOffsetT];
    }
    if (_ripple && ((_116TextDrawingStep*)[stepArray objectAtIndex:stepIndex]).Hhasripple && tmp == 0)
    {
        [_ripple initiateRippleAtLocation:CGPointMake(30, 70)];
    }
    
    [self setupBuffers];
    
    unsigned int indexCount = vertexCount;
    glDrawElements(GL_TRIANGLE_STRIP, indexCount, GL_UNSIGNED_SHORT, 0);
}
@end
