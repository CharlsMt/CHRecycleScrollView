//
//  CHRecycleScrollView.m
//  练习无限循环
//
//  Created by lili on 16/5/19.
//  Copyright © 2016年 陈浩. All rights reserved.
//

#import "CHRecycleScrollView.h"
#import "UIImageView+WebCache.h"
#define KImageW _frmRect.size.width
#define Height _frmRect.size.height
@interface CHRecycleScrollView()<UIScrollViewDelegate>

@property (nonatomic ,strong) UIScrollView *scrollView;

@property (nonatomic ,strong) UIPageControl *pageCtr;
//   索引
@property (nonatomic ,assign) NSInteger  index;
//   图片数量
@property (nonatomic ,assign) NSInteger  imageCount;
//   图片集合
@property (nonatomic ,strong) NSArray *images;
//   标题集合
@property (nonatomic ,strong) UILabel *label;
@property (nonatomic ,strong) NSArray *titles;
@property (nonatomic ,strong) NSTimer *timer;
@property (nonatomic ,assign) CGRect frmRect;
@property (nonatomic ,assign) NSTimeInterval duration;


@end


@implementation CHRecycleScrollView
-(UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.contentSize = CGSizeMake((_imageCount+2)*KImageW, 0);
        _scrollView.contentOffset = CGPointMake(KImageW, 0);
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
    }
    return _scrollView;
}


-(UIPageControl *)pageCtr{
    if (!_pageCtr) {
        _pageCtr = [[UIPageControl alloc] initWithFrame:CGRectMake(KImageW - 80, Height -30 , 80, 30)];
        _pageCtr.pageIndicatorTintColor = [UIColor whiteColor];
        _pageCtr.currentPageIndicatorTintColor = [UIColor redColor];
        _pageCtr.numberOfPages = _imageCount;
        _pageCtr.currentPage = 0;
    }
    return _pageCtr;
}

-(instancetype)initWithFrame:(CGRect)frame animationDuration:(NSTimeInterval)duration Images:(NSArray *)images andTitles:(NSArray *)titles {
    if (self = [super initWithFrame:frame]) {
        
        _index = 1;
        _imageCount = images.count;
        _images = images;
        _titles = titles;
        _frmRect = frame;
        _duration = duration;
        
        [self addSubview:self.scrollView];
        [self addSubview:self.pageCtr];
        [self startTimer];
        [self addImages];
    
    }
    return self;
    
}






-(void)addImages{
    for (int i = 0; i < _imageCount+2; i++) {
        UIImageView *imgView = [[UIImageView alloc] init];
        imgView.userInteractionEnabled = YES;
        if (_titles) {
            UILabel *label = [[UILabel alloc] init];
            label.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.5];
            label.textColor = [UIColor whiteColor];
            label.alpha = 0.5;
            _label = label;
        }
    
        NSString *imgName = nil;
        NSString *title = nil;
        if (i == 0) {
            
            imgName = [_images objectAtIndex:_imageCount -1];
            title = [_titles objectAtIndex:_imageCount -1];
            imgView.frame = CGRectMake(0, 0, KImageW, Height);
            _label.frame =  CGRectMake(0, Height-30, KImageW, 30);
            
        }else if(i == _imageCount+1){
            imgName = [_images objectAtIndex:0];
            title = [_titles objectAtIndex:0];
            imgView.frame = CGRectMake(KImageW *(_imageCount +1), 0, KImageW, Height);
            _label.frame = CGRectMake(KImageW *(_imageCount +1), Height-30, KImageW, 30);
            imgView.tag = 1;
            
        }else{
            imgView.tag = i;
            imgName = [_images objectAtIndex:i-1];
            title = [_titles objectAtIndex:i-1];
            imgView.frame = CGRectMake(i*KImageW, 0, KImageW, Height);
            _label.frame =  CGRectMake(i*KImageW, Height -30 , KImageW, 30);
           
            
        }
     
        NSURL *url =  [NSURL URLWithString:imgName];
        [imgView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"placeholder"]];
        [_scrollView addSubview:imgView];
        
        if (_titles) {
            _label.text = [NSString stringWithFormat:@"   %@",title];
            [_scrollView addSubview:_label];
        }
        
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        [imgView addGestureRecognizer:tap];
    }
}



-(void)startTimer{
    _timer = [NSTimer timerWithTimeInterval:_duration target:self selector:@selector(changeImage) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop]addTimer:_timer forMode:NSRunLoopCommonModes];
}

-(void)stopTimer{
    [_timer invalidate];
    _timer = nil;
}


-(void)changeImage{
    [_scrollView setContentOffset:CGPointMake((_index +1) *KImageW, 0) animated:YES];
    
}


#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    _index = scrollView.contentOffset.x / KImageW;
//   如果滚动到最后一张，立马跳转到第一张图片的位置
    if (scrollView.contentOffset.x >(_imageCount+1) * KImageW) {
        [scrollView setContentOffset:CGPointMake(KImageW + scrollView.contentOffset.x - KImageW *(_imageCount +1), 0) animated:NO];
        if (_timer) {
            [self changeImage];
        }
    }
//      当滚动到第一张的时候，立马切换到最后图片的位置
    if (scrollView.contentOffset.x < KImageW) {
        [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x+ _imageCount *KImageW, 0) animated:NO];
    }
}


-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger index = _index;
    if (_index == _images.count +1) {
        index = 1;
    }
    _pageCtr.currentPage = index -1;
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    NSInteger index = _index;
    if (_index == _images.count +1) {
        index = 1;
    }
    _pageCtr.currentPage = index -1;
}


// 手动滚动结束，重启定时器
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
    [self startTimer];
}

//   手动开始滚动，停止定时器
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    NSInteger index = _index;
    if (_index == _images.count +1) {
        index = 1;
    }
    _pageCtr.currentPage = index -1;
    [self stopTimer];
}



-(void)handleTap:(UITapGestureRecognizer *)tap{
    if (self.TapActionBlock) {
        self.TapActionBlock(tap.view.tag);
    }
}





@end
