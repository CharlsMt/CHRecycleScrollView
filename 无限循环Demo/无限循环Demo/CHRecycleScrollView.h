//
//  CHRecycleScrollView.h
//  练习无限循环
//
//  Created by lili on 16/5/19.
//  Copyright © 2016年 陈浩. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CHRecycleScrollView : UIView


/**
 当点击的时候，执行的block
 **/
@property (nonatomic ,copy) void (^TapActionBlock)(NSInteger pageIndex);


#pragma mark - 不带下标题
-(instancetype)initWithFrame:(CGRect)frame
           animationDuration:(NSTimeInterval)duration
                      Images:(NSArray *)images
                   andTitles:(NSArray *)titles;

@end
