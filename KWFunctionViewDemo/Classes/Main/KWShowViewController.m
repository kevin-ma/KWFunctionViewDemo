//
//  KWShowViewController.m
//  KWFunctionViewDemo
//
//  Created by 凯文马 on 16/1/4.
//  Copyright © 2016年 凯文马. All rights reserved.
//

#import "KWShowViewController.h"
#import "KWPageScrollView.h"
#import "KWNoticeScrollView.h"

@interface KWShowViewController ()

@end

@implementation KWShowViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.view.backgroundColor = [UIColor whiteColor];
    SEL selector = NSSelectorFromString(self.actionString);
    if ([self respondsToSelector:selector]) {
        IMP imp = [self methodForSelector:selector];
        void (*func)(id,SEL) = (void *)imp;
        func(self,selector);
    }
}

# pragma mark - 循环滚动

- (void)pageScrollViewDemo
{
    KWPageScrollView *scrollView = [[KWPageScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 200)];
    [self.view addSubview:scrollView];
    NSString *url0 = @"http://p3.so.qhimg.com/bdr/_240_/t012b839e73725f3fb3.jpg";
    NSString *url1 = @"http://p2.so.qhimg.com/bdr/_240_/t01c358cece19cfc6dc.jpg";
    NSString *url2 = @"http://p1.so.qhimg.com/bdr/_240_/t0147f3d0f4adafc77b.jpg";
    NSString *url3 = @"http://p2.so.qhimg.com/bdr/_240_/t01dc9883fc5ab7306c.jpg";
    scrollView.images = @[url0,url1,url2,url3];
    scrollView.autoScrollInterval = 2.f;
    scrollView.pageTintColor = [UIColor redColor];
    scrollView.pageCurrentTintColor = [UIColor whiteColor];
    scrollView.selectAction = ^(NSUInteger index){
        NSLog(@"选中了第%lu个",(unsigned long)index);
    };
}

# pragma mark - 滚动消息展示

-(void)noticeScrollViewDemo
{
    KWNoticeModel *model0 = [KWNoticeModel noticeWithId:@0 title:@"老炮儿" subtitle:@"老炮儿在北京话中，专指提笼遛鸟，无所事事的老混混儿。" data:nil];
    KWNoticeModel *model1 = [KWNoticeModel noticeWithId:@0 title:@"恶棍天使" subtitle:@"因为一起车祸，高智商低情商的学霸女査小刀意外相遇专职替人讨债。" data:nil];
    KWNoticeModel *model2 = [KWNoticeModel noticeWithId:@0 title:@"万万没想到：西游篇" subtitle:@"屌丝小妖王大锤，他生来便于常人不同，两耳尖尖，又有些小法力，总是自诩本地妖王。" data:nil];
    KWNoticeModel *model3 = [KWNoticeModel noticeWithId:@0 title:@"秦时明月" subtitle:@"战国末期，荆轲刺秦失败牺牲。天下第一剑客盖聂受荆轲所托，护送荆轲之子荆天明躲避秦王追杀。" data:nil];
    KWNoticeScrollView *scrollView = [KWNoticeScrollView noticeScrollViewWithNotices:@[model0,model1,model2,model3] timeInterval:2.f clickAction:^(KWNoticeModel *notice) {
        
    }];
    scrollView.holderImage = [UIImage imageNamed:@"demo1"];
    [self.view addSubview:scrollView];
    scrollView.clickAction = ^(KWNoticeModel *notice){
        NSLog(@"%@",notice);
    };
}
@end
