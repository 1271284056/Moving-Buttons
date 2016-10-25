//
//  ViewController.m
//  移动按钮
//
//  Created by 张江东 on 16/1/18.
//  Copyright © 2016年 58kuaipai. All rights reserved.
//

#import "ViewController.h"
#define KBase_tag     100
#define kScreenWidth   [UIScreen mainScreen].bounds.size.width
#define kScreenHeight  [UIScreen mainScreen].bounds.size.height
#define kMaxCols 3

@interface ViewController (){
    NSInteger totalNumer;
    CGPoint nextPoint;//下一个按钮的位置
    CGPoint valuePoint;//记录移动按钮的位置
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    NSLog(@"%ld",self.view.tag);
    totalNumer = 9;
    CGFloat btnW = (kScreenWidth - (kMaxCols+1)*20)/kMaxCols;
    CGFloat btnH = btnW;
    for (int i = 0; i<totalNumer; i++) {
        UIButton *btn = [[UIButton alloc] init];
        btn.frame = CGRectMake(20+(20+btnW)*(i%kMaxCols), 100+(20+ btnH)*(i/kMaxCols), btnW, btnH);
        [btn addTarget:self action:@selector(btnDelete:) forControlEvents:UIControlEventTouchUpInside];
        btn.backgroundColor = [UIColor redColor];
        btn.tag = KBase_tag + i;
        
        NSString *title = [NSString stringWithFormat:@"第%d",i];
        [btn setTitle:title forState:UIControlStateNormal];
        [self.view addSubview:btn];
        
        
        //添加长按手势
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
        [btn addGestureRecognizer:longPress];
    }
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(add)];
    self.navigationItem.title = @"按钮移动";
    
}


//删除
- (void)btnDelete:(UIButton *)btn{
    CGPoint btnPoint = btn.center;
    NSInteger btnTag = btn.tag - KBase_tag;
    [btn removeFromSuperview];

    __block CGPoint currentPoint = btnPoint;
    
    [UIView animateWithDuration:0.2 animations:^{
        for ( int i = (int)btnTag + 1; i<totalNumer; i++) {
            UIButton *btn = (UIButton *)[self.view viewWithTag:i+ KBase_tag];
            nextPoint = btn.center;
            btn.center = currentPoint;
            currentPoint = nextPoint;
            btn.tag--;
            [btn setTitle:[NSString stringWithFormat:@"第%ld",btn.tag] forState:UIControlStateNormal];
        }
        
    }completion:^(BOOL finished) {
        totalNumer--;

    }];
    
  
}

//增加按钮
- (void)add{
    totalNumer++;
    CGFloat btnW = (kScreenWidth - (kMaxCols+1)*20)/kMaxCols;
    CGFloat btnH = btnW;
    UIButton *btn = [[UIButton alloc] init];
    btn.frame = CGRectMake(20+(20+btnW)*((totalNumer-1)%kMaxCols), 100+(20+ btnH)*((totalNumer-1)/kMaxCols), btnW, btnH);
    btn.backgroundColor = [UIColor redColor];
    [btn addTarget:self action:@selector(btnDelete:) forControlEvents:UIControlEventTouchUpInside];
    btn.backgroundColor = [UIColor redColor];
    btn.tag = totalNumer - 1 + KBase_tag;
    
    NSString *title = [NSString stringWithFormat:@"第%ld",btn.tag];
    [btn setTitle:title forState:UIControlStateNormal];
    [self.view addSubview:btn];
    
    
    //添加长按手势
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    [btn addGestureRecognizer:longPress];


}

- (void)longPress:(UIGestureRecognizer *)recongize{
    UIButton *btn = (UIButton *)recongize.view;
    for (UIButton *btn1 in self.view.subviews) {
        if (btn1 != btn) {
            //禁用没被选中按钮的手势
            btn1.userInteractionEnabled = NO;
        }
    }
    //取得手势的位置
    CGPoint touchPoint = [recongize locationInView:self.view];
    if (recongize.state == UIGestureRecognizerStateBegan) {
        //开始移动
        [UIView animateWithDuration:0.2 animations:^{
            btn.transform = CGAffineTransformMakeScale(1.3, 1.3);
            btn.alpha = 0.7;
            //把选中按钮放到最前面
            [self.view bringSubviewToFront:btn];
            valuePoint = btn.center;
        }];
    }else if (recongize.state == UIGestureRecognizerStateChanged){//移动view
        btn.center = touchPoint;
        for (UIButton *btn2 in self.view.subviews) {
            //遍历按钮 如果某一个按钮frame包含移动的按钮
            if (CGRectContainsPoint(btn2.frame, touchPoint)&&btn2 != btn) {
                //开始按钮索引
                NSInteger startIndex = btn.tag - KBase_tag;
                //结束按钮索引
                NSInteger endIndex = btn2.tag - KBase_tag;
                
                if (endIndex > startIndex) {//往后移
                    [UIView animateWithDuration:0.2 animations:^{
                        for (NSInteger i = startIndex+1; i<=endIndex; i++) {
                            //取出后面的每一个按钮
                            UIButton *button = (UIButton *)[self.view viewWithTag:i+KBase_tag];
                            //记录下一个按钮的中心位置
                            nextPoint = button.center;
                            //移动下一个按钮到上一个位置
                            button.center = valuePoint;
                            //把下一个按钮的位置保存成当前按钮位置
                            valuePoint = nextPoint;
                            //tag减少
                            button.tag--;
                            //修改title
                            [button setTitle:[NSString stringWithFormat:@"第%ld",button.tag] forState:UIControlStateNormal];
                        }
                        btn.tag = endIndex + KBase_tag;
                        [btn setTitle:[NSString stringWithFormat:@"第%ld",btn.tag] forState:UIControlStateNormal];
                    }];
            }else {//往前移
                
                    [UIView animateWithDuration:0.2 animations:^{
                        for (NSInteger i = startIndex-1; i>=endIndex; i--) {
                            UIButton * button3 = (UIButton *)[self.view viewWithTag:i+KBase_tag];
                            nextPoint = button3.center;
                            button3.center = valuePoint;
                            valuePoint = nextPoint;
                            button3.tag++;
                            [button3 setTitle:[NSString stringWithFormat:@"第%ld",button3.tag] forState:UIControlStateNormal];
                        }
                        btn.tag = endIndex+KBase_tag;
                        [btn setTitle:[NSString stringWithFormat:@"第%ld",btn.tag] forState:UIControlStateNormal];
                    }];
                }
            }
        }
    }else if (recongize.state == UIGestureRecognizerStateEnded){
        //移动结束
        for (UIButton * bt in self.view.subviews) {
            if (bt!=btn) {
                bt.userInteractionEnabled = YES;
            }
        }
        // 结束时候恢复view的外观（放大，改变颜色等）
        [UIView animateWithDuration:0.2 animations:^{
            btn.transform = CGAffineTransformMakeScale(1.0, 1.0);
            btn.alpha = 1;
            btn.center = valuePoint;
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
