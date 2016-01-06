//
//  KWNoticeScrollView.m
//  KWFunctionViewDemo
//
//  Created by 凯文马 on 16/1/5.
//  Copyright © 2016年 凯文马. All rights reserved.
//

#import "KWNoticeScrollView.h"

CGFloat const KWNoticeScrollViewCellHeight = 70;

@interface KWNoticeScrollView () <UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, assign) NSInteger index;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) CGFloat timeInterval;

@end

@implementation KWNoticeScrollView

# pragma mark - init

- (instancetype)initWithFrame:(CGRect)frame{
    if (frame.size.height < KWNoticeScrollViewCellHeight) {
        frame.size.height = KWNoticeScrollViewCellHeight;
    }
    frame.size.width = [UIScreen mainScreen].bounds.size.width;
    if (self = [super initWithFrame:frame]) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.bounces = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self addSubview:_tableView];
        _timeInterval = 3.f;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _tableView.frame = CGRectMake(0, 0, self.bounds.size.width, KWNoticeScrollViewCellHeight);
    _tableView.center = CGPointMake(_tableView.center.x, self.bounds.size.height * 0.5f);
}

+ (instancetype)noticeScrollViewWithNotices:(NSArray<KWNoticeModel *> *)notices timeInterval:(CGFloat)timeInterval clickAction:(KWNoticeScrollViewClickBlock)clickAction
{
    KWNoticeScrollView *view = [[self alloc] initWithFrame:CGRectZero];
    if (timeInterval) {
        view.timeInterval = timeInterval;
    }
    view.notices = notices;
    view.clickAction = clickAction;
    return view;
}

+ (instancetype)noticeScrollViewWithNotices:(NSArray<KWNoticeModel *> *)notices clickAction:(KWNoticeScrollViewClickBlock)clickAction
{
    return [self noticeScrollViewWithNotices:notices timeInterval:0 clickAction:clickAction];
}

- (void)setNotices:(NSArray<KWNoticeModel *> *)notices
{
    _notices = notices;
    self.index = 0;
    [self stopTimer];
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
    [self startTimer];
}

# pragma mark - Timer

- (void)startTimer
{
    if (!self.timer) {
        self.timer = [NSTimer scheduledTimerWithTimeInterval:self.timeInterval target:self selector:@selector(timeActions) userInfo:nil repeats:YES];
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
    self.index = self.index >= self.notices.count - 1 ? 0 : self.index + 1;
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationTop];
}

# pragma mark - UIScrollViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KWNoticeScrollViewCell *cell = [KWNoticeScrollViewCell cellWithTableView:tableView notice:self.notices[self.index]];
    cell.holderImage = self.holderImage;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    KWNoticeScrollViewCell *cell = (KWNoticeScrollViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    KWNoticeModel *notice = cell.notice;
    if (self.clickAction) {
        __weak typeof(self) weakSelf = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            weakSelf.clickAction(notice);
        });
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return KWNoticeScrollViewCellHeight;
}

@end

@implementation KWNoticeModel

+ (instancetype)noticeWithId:(NSNumber *)ID title:(NSString *)title subtitle:(NSString *)subtitle data:(id)data
{
    KWNoticeModel *notice = [[KWNoticeModel alloc] init];
    notice.ID = ID;
    notice.title = title;
    notice.subtitle = subtitle;
    notice.data = data;
    return notice;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"KWNotice:id = %@,title = %@,subtitle = %@,data = %@",self.ID,self.title,self.subtitle,self.data];
}

@end

@interface KWNoticeScrollViewCell ()

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *infoLabel;

@end

@implementation KWNoticeScrollViewCell

+ (KWNoticeScrollViewCell *)cellWithTableView:(UITableView *)tableView notice:(KWNoticeModel *)notice
{
    static NSString *ID = @"KWNoticeScrollViewCell";
    KWNoticeScrollViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[KWNoticeScrollViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        [cell initCell];
    }
    cell.notice = notice;
    return cell;
}

- (void)initCell
{
    CGFloat margin = 15.f;
    CGFloat width = KWNoticeScrollViewCellHeight - 2 * margin;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(margin, margin, width, width)];
    imageView.tag = 998;
    imageView.image = self.holderImage;
    [self.contentView addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(imageView.frame.origin.x + imageView.frame.size.width + margin, imageView.frame.origin.y, [UIScreen mainScreen].bounds.size.width - 4 * margin - imageView.frame.size.width,[@"a" boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.f]} context:nil].size.height)];
    label.font = [UIFont boldSystemFontOfSize:14];
    label.textColor = [UIColor blackColor];
    [self.contentView addSubview:label];
    self.titleLabel = label;
    
    CGFloat infoLabelHeight = [@"a" boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:12.f]} context:nil].size.height;
    UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(label.frame.origin.x, imageView.frame.origin.y + imageView.frame.size.height - infoLabelHeight, label.frame.size.width, infoLabelHeight)];
    infoLabel.font = [UIFont systemFontOfSize:12];
    infoLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:infoLabel];
    self.infoLabel = infoLabel;
}

- (void)setHolderImage:(UIImage *)holderImage
{
    UIImageView *imageView = [self.contentView viewWithTag:998];
    imageView.image = holderImage;
    _holderImage = holderImage;
}

- (void)setNotice:(KWNoticeModel *)notice
{
    _notice = notice;
    self.titleLabel.text = notice.title;
    self.infoLabel.text = notice.subtitle;
}

@end