//
//  ViewController.m
//  UIScrollView轮播
//
//  Created by mac on 16/3/10.
//  Copyright (c) 2016年 lzc. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UIScrollViewDelegate>

@property (nonatomic,strong)UIScrollView *scrollView;

@property (nonatomic,strong)UIPageControl *pageControl;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 100, CGRectGetWidth(self.view.bounds), 250)];
    self.scrollView.pagingEnabled = YES;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:self.scrollView];
//    在最前面添加冗余的最后一张图片
    UIImageView *firstImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.scrollView.bounds), 250)];
    firstImage.image = [UIImage imageNamed:@"4.jpg"];
    [self.scrollView addSubview:firstImage];
    for (NSInteger i = 1; i <= 4; i++) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(i*CGRectGetWidth(self.scrollView.bounds), 0, CGRectGetWidth(self.scrollView.bounds), 250)];
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%ld.jpg",i]];
        [self.scrollView addSubview:imageView];
    }
//    在最后的位置添加冗余的第一张图片
    UIImageView *lastImage = [[UIImageView alloc]initWithFrame:CGRectMake(5*CGRectGetWidth(self.scrollView.bounds), 0, CGRectGetWidth(self.scrollView.bounds), 250)];
    lastImage.image = [UIImage imageNamed:@"1.jpg"];
    [self.scrollView addSubview:lastImage];
    self.scrollView.contentOffset = CGPointMake(CGRectGetWidth(self.scrollView.bounds), 0);
    self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.scrollView.bounds)*6, 0);
//    分页控制器
//UIPageControl
    self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, 300, CGRectGetWidth(self.scrollView.bounds), 50)];
//    设置页数
    self.pageControl.numberOfPages = 4;
//    设置当前页数
    self.pageControl.currentPage = 0;
    [self.view addSubview:self.pageControl];
//    设置颜色
//    未选择页数的颜色
    self.pageControl.pageIndicatorTintColor = [UIColor redColor];
//    选择页数的颜色
    self.pageControl.currentPageIndicatorTintColor = [UIColor yellowColor];
//    将pageControl与scrollView建立联系
//    pageControl改变，通过pageControl的valueChange事件处理scrollView
    [self.pageControl addTarget:self action:@selector(Action:) forControlEvents:UIControlEventValueChanged];
//    2.scrollView改变偏移量，pageControl需要跟着变动
//    设置代理，根据代理方法处理偏移量的变化
    self.scrollView.delegate = self;
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timer) userInfo:nil repeats:YES];
    
}

- (void)Action:(UIPageControl *)sender
{
//    当前在第几页
    NSInteger page = sender.currentPage+1;
//    让scrollView滚到对应的页数
    self.scrollView.contentOffset = CGPointMake(page * CGRectGetWidth(self.scrollView.bounds), 0);
}

- (void)timer
{
    CGPoint offSet = self.scrollView.contentOffset;
    offSet.x = offSet.x +CGRectGetWidth(self.scrollView.bounds);
//    self.scrollView.contentOffset = offSet;
    [self.scrollView setContentOffset:offSet animated:YES];

    
}
//停止减速时，计算当前页数
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger page = scrollView.contentOffset.x /CGRectGetWidth(self.scrollView.bounds);
    if (page == 5) {
        self.scrollView.contentOffset = CGPointMake(CGRectGetWidth(self.scrollView.bounds), 0);
        self.pageControl.currentPage = 0;
    }else if(page == 0)
    {
        self.scrollView.contentOffset = CGPointMake(CGRectGetWidth(self.scrollView.bounds)*4, 0);
        self.pageControl.currentPage = 3;
    }else
    {
        self.pageControl.currentPage = page - 1;
    }
//    self.pageControl.currentPage = page;
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    NSInteger page = self.scrollView.contentOffset.x / CGRectGetWidth(self.scrollView.bounds);
    if (page < 5) {
        self.pageControl.currentPage = page-1;
    }else
    {
        self.pageControl.currentPage = 0;
        self.scrollView.contentOffset = CGPointMake(CGRectGetWidth(self.scrollView.bounds), 0);
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
