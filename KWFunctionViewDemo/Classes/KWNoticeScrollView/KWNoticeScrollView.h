//
//  KWNoticeScrollView.h
//  KWFunctionViewDemo
//
//  Created by 凯文马 on 16/1/5.
//  Copyright © 2016年 凯文马. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KWNoticeModel;

typedef void(^KWNoticeScrollViewClickBlock)(KWNoticeModel *notice);

@interface KWNoticeScrollView : UIView

/**
 *  EBNews 数组
 */
@property (nonatomic, strong) NSArray<KWNoticeModel *> *notices;

/**
 *  点击执行操作
 */
@property (nonatomic, copy) KWNoticeScrollViewClickBlock clickAction;

@property (nonatomic, strong) UIImage *holderImage;

+ (instancetype)noticeScrollViewWithNotices:(NSArray<KWNoticeModel *> *)notices clickAction:(KWNoticeScrollViewClickBlock)clickAction;

+ (instancetype)noticeScrollViewWithNotices:(NSArray<KWNoticeModel *> *)notices timeInterval:(CGFloat)timeInterval clickAction:(KWNoticeScrollViewClickBlock)clickAction;

@end

@interface KWNoticeModel : NSObject

@property (nonatomic, strong) NSNumber *ID;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic, strong) id data;

+ (instancetype)noticeWithId:(NSNumber *)ID title:(NSString *)title subtitle:(NSString *)subtitle data:(id )data;

@end

@interface KWNoticeScrollViewCell : UITableViewCell

+ (KWNoticeScrollViewCell *)cellWithTableView:(UITableView *)tableView notice:(KWNoticeModel *)notice;
@property (nonatomic, strong) KWNoticeModel *notice;
@property (nonatomic, strong) UIImage *holderImage;

@end