//
//  CTView.m
//  Font2Image
//
//  Created by baidu on 15/3/5.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#import "ResultView.h"
#import "ResultViewController.h"
#import <CoreText/CoreText.h>
@implementation ResultView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    [self characterAttribute];
    [self gettexture];
}

-(void)setText:(NSString *)inputtext
{
    _projectName = inputtext;
}

-(void)gettexture
{
    /*
    GLuint texID;
    // 分配纹理编号
    glGenTextures(1, &texID);
    // 指定为当前纹理
    glBindTexture(GL_TEXTURE_2D, texID);
    // 把像素作为纹理数据
    // 将屏幕(0, 0) 到 (64, 64)的矩形区域的像素复制到纹理中
    glCopyTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, 0, 0, self.bounds.size.width, self.bounds.size.height, 0);
     */
    
}

-(void)characterAttribute
{
    NSString *str = _projectName;
    NSMutableAttributedString *mabstring = [[NSMutableAttributedString alloc]initWithString:str];
    
    [mabstring beginEditing];
    /*
     long number = 1;
     CFNumberRef num = CFNumberCreate(kCFAllocatorDefault,kCFNumberSInt8Type,&number);
     [mabstring addAttribute:(id)kCTCharacterShapeAttributeName value:(id)num range:NSMakeRange(0, 4)];
     */
    /*
     //设置字体属性
     CTFontRef font = CTFontCreateWithName(CFSTR("Georgia"), 40, NULL);
     [mabstring addAttribute:(id)kCTFontAttributeName value:(id)font range:NSMakeRange(0, 4)];
     */
    /*
     //设置字体简隔 eg:test
     long number = 10;
     CFNumberRef num = CFNumberCreate(kCFAllocatorDefault,kCFNumberSInt8Type,&number);
     [mabstring addAttribute:(id)kCTKernAttributeName value:(id)num range:NSMakeRange(10, 4)];
     */
    
    /*
     long number = 1;
     CFNumberRef num = CFNumberCreate(kCFAllocatorDefault,kCFNumberSInt8Type,&number);
     [mabstring addAttribute:(id)kCTLigatureAttributeName value:(id)num range:NSMakeRange(0, [str length])];
     */
    /*
     //设置字体颜色
     [mabstring addAttribute:(id)kCTForegroundColorAttributeName value:(id)[UIColor redColor].CGColor range:NSMakeRange(0, 9)];
     */
    /*
     //设置字体颜色为前影色
     CFBooleanRef flag = kCFBooleanTrue;
     [mabstring addAttribute:(id)kCTForegroundColorFromContextAttributeName value:(id)flag range:NSMakeRange(5, 10)];
     */
    
    /*
     //设置空心字
     long number = 2;
     CFNumberRef num = CFNumberCreate(kCFAllocatorDefault,kCFNumberSInt8Type,&number);
     [mabstring addAttribute:(id)kCTStrokeWidthAttributeName value:(id)num range:NSMakeRange(0, [str length])];
     
     //设置空心字颜色
     [mabstring addAttribute:(id)kCTStrokeColorAttributeName value:(id)[UIColor greenColor].CGColor range:NSMakeRange(0, [str length])];
     */
    
    /*
     long number = 1;
     CFNumberRef num = CFNumberCreate(kCFAllocatorDefault,kCFNumberSInt8Type,&number);
     [mabstring addAttribute:(id)kCTSuperscriptAttributeName value:(id)num range:NSMakeRange(3, 1)];
     */
    
    /*
     //设置斜体字
     CTFontRef font = CTFontCreateWithName((CFStringRef)[UIFont italicSystemFontOfSize:20].fontName, 14, NULL);
     [mabstring addAttribute:(id)kCTFontAttributeName value:(id)font range:NSMakeRange(0, 4)];
     */
    
    /*
     //下划线
     [mabstring addAttribute:(id)kCTUnderlineStyleAttributeName value:(id)[NSNumber numberWithInt:kCTUnderlineStyleDouble] range:NSMakeRange(0, 4)];
     //下划线颜色
     [mabstring addAttribute:(id)kCTUnderlineColorAttributeName value:(id)[UIColor redColor].CGColor range:NSMakeRange(0, 4)];
     */
    
    
    
    //对同一段字体进行多属性设置
    //红色
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithObject:(id)[UIColor blackColor].CGColor forKey:(id)kCTForegroundColorAttributeName];
    //斜体
    CTFontRef font = CTFontCreateWithName((CFStringRef)[UIFont italicSystemFontOfSize:20].fontName, 40, NULL);
    [attributes setObject:(__bridge id)font forKey:(id)kCTFontAttributeName];
    //下划线
    //[attributes setObject:(id)[NSNumber numberWithInt:kCTUnderlineStyleDouble] forKey:(id)kCTUnderlineStyleAttributeName];
    
    [mabstring addAttributes:attributes range:NSMakeRange(0, mabstring.length)];
    
    
    
    NSRange kk = NSMakeRange(0, 4);
    
    NSDictionary * dc = [mabstring attributesAtIndex:0 effectiveRange:&kk];
    
    [mabstring endEditing];
    
    NSLog(@"value = %@",dc);
    
    
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)mabstring);
    
    CGMutablePathRef Path = CGPathCreateMutable();
    
    CGPathAddRect(Path, NULL ,CGRectMake(100 , 200 ,self.bounds.size.width-100 , self.bounds.size.height-400));
    
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), Path, NULL);
    
    //获取当前(View)上下文以便于之后的绘画，这个是一个离屏。
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, YES, 1.0);
    _context = UIGraphicsGetCurrentContext();
    
    
    CGContextSetTextMatrix(_context , CGAffineTransformIdentity);
    
    //压栈，压入图形状态栈中.每个图形上下文维护一个图形状态栈，并不是所有的当前绘画环境的图形状态的元素都被保存。图形状态中不考虑当前路径，所以不保存
    //保存现在得上下文图形状态。不管后续对context上绘制什么都不会影响真正得屏幕。
    CGContextSaveGState(_context);
    
    //x，y轴方向移动
    CGContextTranslateCTM(_context , 0 ,self.bounds.size.height);
    
    //缩放x，y轴方向缩放，－1.0为反向1.0倍,坐标系转换,沿x轴翻转180度
    CGContextScaleCTM(_context, 1.0 ,-1.0);
    
    
//    CGContextSetStrokeColorWithColor(_context, [UIColor green].CGColor);
//    CGContextSetFillColorWithColor(_context, [UIColor greenColor].CGColor);

    
    
    
    CGContextSetRGBFillColor(_context, 1, 1, 1, 1);
    CGContextFillRect(_context, self.bounds);
    CGContextStrokePath(_context);

    CTFrameDraw(frame,_context);
    
    CGPathRelease(Path);
    CFRelease(framesetter);
    if (_controller != nil) {
        
        //[self.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        [self removeFromSuperview];
        
        //保存图像
        NSString *path = [NSHomeDirectory() stringByAppendingFormat:@"lll.png"];
        if ([UIImagePNGRepresentation(viewImage) writeToFile:path atomically:YES]) {
            NSLog(@"Succeeded!");
        }
        else {
        }
    }
    
    
    //[self addSubview:imageview];
    //[imageview release];
}

@end
