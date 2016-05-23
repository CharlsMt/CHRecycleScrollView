//
//  ViewController.m
//  无限循环Demo
//
//  Created by lili on 16/5/23.
//  Copyright © 2016年 陈浩. All rights reserved.
//

#import "ViewController.h"
#import "CHRecycleScrollView.h"
#define KScreenW [UIScreen mainScreen].bounds.size.width
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"无限循环Demo";
    self.edgesForExtendedLayout = UIRectEdgeNone ;
    NSArray *images = @[@"http://img.taopic.com/uploads/allimg/120524/189122-1205240r45941.jpg",
                        @"http://img.taopic.com/uploads/allimg/110805/10022-110P511132397.jpg",
                        @"http://imgsrc.baidu.com/baike/pic/item/c9fcc3cec3fdfc031d23eb2bd43f8794a5c226cd.jpg",
                        @"http://rescdn.qqmail.com/dyimg/20140625/788A5DC4B0A5.jpg"];
    NSArray *titles = @[@"好的额外热舞人",@"二额外热舞热舞 ",@"我的范德萨范德萨",@"二二额外热舞"];
    
    CHRecycleScrollView *scrollView = [[CHRecycleScrollView alloc] initWithFrame:CGRectMake(0, 0, KScreenW, 200)
                                                               animationDuration:2.0
                                                                          Images:images
                                                                       andTitles:nil];
    
    
    [self.view addSubview:scrollView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
