//
//  KWPageScrollView.h
//  KWFunctionViewDemo
//
//  Created by 凯文马 on 16/1/4.
//  Copyright © 2016年 凯文马. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KWPageScrollView;

@protocol KWPageScrollViewDelegate <NSObject>

@optional

/**
 *  点击某一个图片进行的代理方法
 *
 *  @param scrollView KWPageScrollView
 *  @param index      点击的页面序号
 */
- (void)pageScrollView:(KWPageScrollView *)scrollView didSelectImageAtIndex:(NSUInteger)index;

@end

typedef void(^KWPageScrollViewSelectBlock)(NSUInteger index);

@interface KWPageScrollView : UIView

/**
 *  占位图片
 */
@property (nonatomic, strong) UIImage *placeHolder;

/**
 *  常规不用设置
 */
@property (nonatomic, weak, readonly) UIScrollView *scrollView;

/**
 *  当前页面序号
 */
@property (nonatomic, assign, readonly) NSUInteger currentPage;

/**
 *  一共有多少页面
 */
@property (nonatomic, assign, readonly) NSUInteger totalPage;

/**
 *  每页展示的一些图片信息
 */
@property (nonatomic, strong) NSArray *images;

/**
 *  代理，也可以通过block去执行一些操作
 */
@property (nonatomic, weak) id<KWPageScrollViewDelegate> delegate;

/**
 *  选中某一个的block回调
 */
@property (nonatomic, copy) KWPageScrollViewSelectBlock selectAction;

/**
 *  页码指示器未选中的颜色
 */
@property (nonatomic, strong) UIColor *pageTintColor;

/**
 *  页码指示器当前页码的颜色
 */
@property (nonatomic, strong) UIColor *pageCurrentTintColor;

/**
 *  自动滚动的时间间隔(>= 0.3 才会执行)
 */
@property (nonatomic, assign) CGFloat autoScrollInterval;

/**
 *  添加新的需要显示的图片
 *
 *  @param image 可以是UIImage对象或者是NSString对象
 */
- (void)addImage:(id)image;

//- (void)setUnenabledUserInteractionIndex:(NSArray *)indexs;
@end
