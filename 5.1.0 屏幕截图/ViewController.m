//
//  ViewController.m
//  5.1.0 屏幕截图
//
//  Created by 神猫 on 16/5/1.
//  Copyright © 2016年 神猫. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
/** 火影图片 */

@property (weak, nonatomic) IBOutlet UIImageView *imageDown;
/** 当前点 */
@property (nonatomic, assign) CGPoint location;

/** 最上面的图片 */
@property (nonatomic, weak) UIImageView *imageUp;

/** HUD */
@property (nonatomic, weak) UIView *HUD;
/** 保存的图片 */
@property (nonatomic, weak) UIImage *mypicture;


@end

@implementation ViewController

- (UIImageView *)imageUp
{
    if (!_imageUp) {
        UIImageView *imag = [[UIImageView alloc] initWithFrame:self.imageDown.bounds];
        imag.backgroundColor = [UIColor clearColor];
        [self.view addSubview:imag];
        _imageUp = imag;
    }
    return _imageUp;
}

- (UIView *)HUD
{
    if (!_HUD) {
        UIView *vie = [[UIView alloc] init];
        vie.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        [self.view addSubview:vie];
        _HUD = vie;
    }
    return _HUD;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //添加拖拽手势
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(setUp:)];
    
    //添加到图片上
    [self.imageDown addGestureRecognizer:pan];
    
    
}

- (void)setUp:(UIPanGestureRecognizer *)pan
{
    //点击时就要绘图
    //获取当前的手势点怎么获取  当手势点下去的时候触发
    CGPoint location =  [pan locationInView:self.imageDown];
    
    if (pan.state == UIGestureRecognizerStateBegan) {
        self.location = location;
        NSLog(@"self.location------->%f",self.location.x);
        NSLog(@"%s",__func__);
        self.HUD.frame =self.view.bounds;
        //获取截取的面积
        
        
    }else if (pan.state == UIGestureRecognizerStateChanged)
    {
        CGRect frame = CGRectMake(self.location.x, self.location.y, location.x - self.location.x, location.y - self.location.y);
        
        //开启图文上下文
        UIGraphicsBeginImageContext(self.imageDown.bounds.size);
        //获取当前上下文
        CGContextRef Ref =  UIGraphicsGetCurrentContext();
        //绘制图片
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:frame];
        //裁剪
        [path addClip];
        //将图层绘制到上下文
        [self.imageDown.layer renderInContext:Ref];
        
        //从上下文获取图片
        UIImage *imag = UIGraphicsGetImageFromCurrentImageContext();
        
        self.imageUp.image = imag;
        self.mypicture= imag;
        
        //关闭上下文
        UIGraphicsEndImageContext();
        
        
        
    }else if (pan.state == UIGestureRecognizerStateEnded)
    {
        [self.HUD removeFromSuperview];
        [self.imageUp removeFromSuperview];
        //写到桌面
        NSData *data = UIImagePNGRepresentation(self.mypicture);
        [data writeToFile:@"/Users/tony/Desktop/mypicture.png" atomically:YES];
        //写到相册
        UIImageWriteToSavedPhotosAlbum(self.mypicture, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
            
}
@end
