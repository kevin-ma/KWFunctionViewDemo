//
//  KWWebImageManager.m
//  KWFunctionViewDemo
//
//  Created by 凯文马 on 16/1/4.
//  Copyright © 2016年 凯文马. All rights reserved.
//

#import "KWWebImageManager.h"

@interface KWWebImageManager ()

@property (nonatomic,copy) NSString *cachePath;

@end

@implementation KWWebImageManager

+ (instancetype)shareManager {
    
    static KWWebImageManager *_instance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[KWWebImageManager alloc] init];
    });
    
    return  _instance;
}

# pragma mark - public

- (void)loadImageWithUrlString:(NSString *)urlSting finish:(void(^)(UIImage *image , NSError *error))finish
{
    [self loadImageWithUrlString:urlSting cache:YES finish:finish];
}

- (void)loadImageWithUrlString:(NSString *)urlString cache:(KWWebCacheType)type finish:(void (^)(UIImage *, NSError *))finish
{
    if (type) {
        UIImage *image = [self loadCacheWithUrlString:urlString];
        if (image) {
            finish(image,nil);
        }
    }
    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:urlString] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        UIImage *image = [UIImage imageWithData:data];

        if (!image) {
            NSHTTPURLResponse *res = (NSHTTPURLResponse *)response;
            NSString *errorData = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
            
            NSError *error = [NSError errorWithDomain:[NSString stringWithFormat:@"error:%@\nhttp code:%zd",errorData,res.statusCode] code:0 userInfo:nil];
            finish(nil,error);
            return ;
        }
        
        if (type) {
            // 内存缓存
            self.webImageCache[urlString] = image;
            if (type == KWWebCacheTypeHigh) {
                // 沙盒缓存
                [data writeToFile:[self.cachePath stringByAppendingPathComponent:urlString.lastPathComponent] atomically:YES];
            }
        }
        finish(image,nil);
    }] resume];
}

- (UIImage *)loadCacheWithUrlString:(NSString *)urlSting
{
    if (self.webImageCache[urlSting]) {
        return self.webImageCache[urlSting];
    }
    //取沙盒缓存
    NSData *data = [NSData dataWithContentsOfFile:[self.cachePath stringByAppendingPathComponent:urlSting.lastPathComponent]];
    
    if (data.length > 0 ) {
        UIImage *image = [UIImage imageWithData:data];
        if (image) {
            self.webImageCache[urlSting] = image;
            return image;
        }else {
            [[NSFileManager defaultManager] removeItemAtPath:[self.cachePath stringByAppendingPathComponent:urlSting.lastPathComponent] error:nil];
        }
    }
    return nil;
}

# pragma mark - 

- (void)cleanCache
{
    NSDirectoryEnumerator *enumer = [[NSFileManager defaultManager] enumeratorAtPath:self.cachePath];
    for (NSString *path in enumer.allObjects) {
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    }
    self.webImageCache = nil;
}

# pragma mark - getter

- (NSMutableDictionary *)webImageCache
{
    if (!_webImageCache) {
        _webImageCache = [@{} mutableCopy];
    }
    return _webImageCache;
}

- (NSString *)cachePath
{
    if (!_cachePath) {
        _cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    }
    return _cachePath;
}

@end

@interface UIButton ()



@end

@implementation UIButton (KWCache)

- (void)kw_setWebImageWithUrl:(NSString *)urlStr forState:(UIControlState)state placeHolder:(UIImage *)holderImage
{
    [self kw_setWebImageWithUrl:urlStr forState:state placeHolder:holderImage finishAction:nil];
}

- (void)kw_setWebImageWithUrl:(NSString *)urlStr forState:(UIControlState)state placeHolder:(UIImage *)holderImage finishAction:(void (^)(UIImage *, NSString *))finish
{
    [self setImage:holderImage forState:state];
    __weak typeof(self) weakSelf = self;
    [[KWWebImageManager shareManager] loadImageWithUrlString:urlStr cache:KWWebCacheTypeLow finish:^(UIImage *image, NSError *error) {
        __strong typeof(weakSelf) safeSelf = weakSelf;
        [safeSelf setImage:image forState:state];
        if (finish) {
            finish(image,urlStr);
        }
    }];
}

- (void)kw_setWebBackgroundImageWithUrl:(NSString *)urlStr forState:(UIControlState)state placeHolder:(UIImage *)holderImage
{
    [self kw_setWebImageWithUrl:urlStr forState:state placeHolder:holderImage finishAction:nil];
}

- (void)kw_setWebBackgroundImageWithUrl:(NSString *)urlStr forState:(UIControlState)state placeHolder:(UIImage *)holderImage finishAction:(void (^)(UIImage *, NSString *))finish
{
    [self setBackgroundImage:holderImage forState:state];
    __weak typeof(self) weakSelf = self;
    [[KWWebImageManager shareManager] loadImageWithUrlString:urlStr cache:KWWebCacheTypeLow finish:^(UIImage *image, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            __strong typeof(weakSelf) safeSelf = weakSelf;
            [safeSelf setBackgroundImage:image forState:state];
            if (finish) {
                finish(image,urlStr);
            }
        });
    }];
}
@end
