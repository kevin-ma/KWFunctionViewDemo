//
//  KWWebImageManager.h
//  KWFunctionViewDemo
//
//  Created by 凯文马 on 16/1/4.
//  Copyright © 2016年 凯文马. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger , KWWebCacheType) {
    KWWebCacheTypeNone,
    KWWebCacheTypeLow,
    KWWebCacheTypeHigh,
};

@interface KWWebImageManager : NSObject

@property (nonatomic,strong) NSMutableDictionary *webImageCache;

+ (instancetype)shareManager;

- (void)loadImageWithUrlString:(NSString *)urlSting finish:(void(^)(UIImage *image , NSError *error))finish;

- (void)loadImageWithUrlString:(NSString *)urlSting cache:(KWWebCacheType)type finish:(void(^)(UIImage *image , NSError *error))finish;

- (void)cleanCache;
@end

@interface UIButton (KWCache)

- (void)kw_setWebImageWithUrl:(NSString *)urlStr forState:(UIControlState)state placeHolder:(UIImage *)holderImage;

- (void)kw_setWebImageWithUrl:(NSString *)urlStr forState:(UIControlState)state placeHolder:(UIImage *)holderImage finishAction:(void(^)(UIImage *image, NSString *url))finish;

- (void)kw_setWebBackgroundImageWithUrl:(NSString *)urlStr forState:(UIControlState)state placeHolder:(UIImage *)holderImage;

- (void)kw_setWebBackgroundImageWithUrl:(NSString *)urlStr forState:(UIControlState)state placeHolder:(UIImage *)holderImage finishAction:(void(^)(UIImage *image, NSString *url))finish;
@end