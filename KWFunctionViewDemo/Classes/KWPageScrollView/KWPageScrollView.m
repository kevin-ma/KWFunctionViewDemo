//
//  KWPageScrollView.m
//  KWFunctionViewDemo
//
//  Created by 凯文马 on 16/1/4.
//  Copyright © 2016年 凯文马. All rights reserved.
//

#import "KWPageScrollView.h"
#import "KWWebImageManager.h"
#import "UIImage+KW.h"

@interface KWPageScrollView () <UIScrollViewDelegate>

@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation KWPageScrollView

- (instancetype)init
{
    if (self = [super init]) {
        [self initView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initView];
    }
    return self;
}

- (void)initView
{
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.pagingEnabled = YES;
    scrollView.delegate = self;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    [self addSubview:scrollView];
    _scrollView = scrollView;
    
    _pageControl = [[UIPageControl alloc] init];
    _pageControl.hidesForSinglePage = YES;
    _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    _pageControl.currentPageIndicatorTintColor = [UIColor grayColor];
    [self addSubview:_pageControl];
}

- (void)setCurrentPage:(NSUInteger)currentPage
{
    [self setCurrentPage:currentPage withAnimation:NO];
}

- (void)setCurrentPage:(NSUInteger)currentPage withAnimation:(BOOL)animation
{
    _currentPage = currentPage;
    [_pageControl setCurrentPage:currentPage];
    // TODO: 切换
}

# pragma mark - public setting

- (void)setImages:(NSArray *)images
{
    if (!images || !images.count) {
        images = @[self.placeHolder ? self.placeHolder : [[UIImage alloc] init]];
    };
    _images = images;
    [_scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    CGFloat width = self.bounds.size.width;
    CGFloat height = self.bounds.size.height;
    for (NSInteger i = 0; i < images.count + 2; i++) {
        UIImage *image = images[(i - 1) % images.count];
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(i * width, 0, width, height)];
        btn.tag = i % images.count;
        if ([image isKindOfClass:[NSString class]]) {
            [btn kw_setWebBackgroundImageWithUrl:(NSString *)image forState:UIControlStateNormal placeHolder:self.placeHolder finishAction:^(UIImage *image, NSString *url) {
                [btn setBackgroundImage:[image imageWithAlphaComponent:0.4f] forState:UIControlStateHighlighted];
            }];
        } else {
            [btn setBackgroundImage:image forState:UIControlStateNormal];
            [btn setBackgroundImage:[image imageWithAlphaComponent:0.4f] forState:UIControlStateHighlighted];
        }
        [btn addTarget:self action:@selector(imageBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [btn addTarget:self action:@selector(stopTimer) forControlEvents:UIControlEventTouchDown];
        [btn addTarget:self action:@selector(startTimer) forControlEvents:UIControlEventTouchCancel];
        [_scrollView addSubview:btn];
    }
    _scrollView.contentSize = CGSizeMake((images.count + 2) * width, 0);
    self.pageControl.numberOfPages = images.count;
    self.pageControl.currentPage = 0;
}

- (void)addImage:(UIImage *)image
{
    NSMutableArray *temp = [self.images mutableCopy];
    [temp addObject:image];
    self.images = [temp copy];
}

- (void)setPageTintColor:(UIColor *)pageTintColor
{
    _pageTintColor = pageTintColor;
    _pageControl.pageIndicatorTintColor = pageTintColor;
}

- (void)setPageCurrentTintColor:(UIColor *)pageCurrentTintColor
{
    _pageCurrentTintColor = pageCurrentTintColor;
    _pageControl.currentPageIndicatorTintColor = pageCurrentTintColor;
}

- (NSUInteger)totalPage
{
    return self.pageControl.numberOfPages;
}

- (void)setAutoScrollInterval:(CGFloat)autoScrollInterval
{
    if (_autoScrollInterval != autoScrollInterval) {
        _autoScrollInterval = autoScrollInterval;
        // 先停止
        [self stopTimer];
        // 再开启
        [self startTimer];
    }
}

# pragma mark - timer
- (void)startTimer
{
    if (!self.timer && _autoScrollInterval >= 0.3f) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:_autoScrollInterval target:self selector:@selector(timeActions) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
    }
}

- (void)stopTimer
{
    if (self.timer) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

- (void)timeActions
{
    if (_scrollView.contentOffset.x + self.bounds.size.width >= _scrollView.contentSize.width) {
        _scrollView.contentOffset = CGPointMake(self.bounds.size.width, 0);
        _pageControl.currentPage = 1;
    }
    [UIView animateWithDuration:.3f animations:^{
        CGPoint temp = _scrollView.contentOffset;
        temp.x += self.self.bounds.size.width;
        _scrollView.contentOffset = temp;
    } completion:^(BOOL finished) {
        
    }];
}

# pragma mark - base setting

- (void)layoutSubviews
{
    [super layoutSubviews];
    // 调整视图位置
    _scrollView.frame = self.bounds;
    CGRect rect = _pageControl.frame;
    rect.size.width = self.bounds.size.width;
    rect.size.height = 10.f;
    rect.origin.y = self.bounds.size.height - 20.f;
    _pageControl.frame = rect;
}

- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    [super setBackgroundColor:backgroundColor];
    _scrollView.backgroundColor = backgroundColor;
}

# pragma mark - private method

- (void)imageBtnAction:(UIButton *)sender
{
    NSUInteger index = sender.tag;
    if (self.selectAction) {
        self.selectAction(index);
    }
    if ([self.delegate respondsToSelector:@selector(pageScrollView:didSelectImageAtIndex:)]) {
        [self.delegate pageScrollView:self didSelectImageAtIndex:index];
    }
    [self startTimer];
}

# pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.images.count) {
        if (!self.timer) {
            if (scrollView.contentOffset.x  + self.bounds.size.width >= scrollView.contentSize.width) {
                scrollView.contentOffset = CGPointMake(self.bounds.size.width, 0);
            }
            if (scrollView.contentOffset.x < self.bounds.size.width) {
                scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x + self.totalPage * self.bounds.size.width, 0);
            }
        }
        NSUInteger index = (NSUInteger)(scrollView.contentOffset.x / self.bounds.size.width - 0.5f + 1) % self.images.count;
        _pageControl.currentPage = index;
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self stopTimer];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self startTimer];
}

@end
