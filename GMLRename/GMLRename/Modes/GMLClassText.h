//
//  GMLClassText.h
//  GMLRename
//
//  Created by apple on 2019/1/16.
//  Copyright © 2019 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GMLClassText : NSObject

@property (nonatomic, strong, readonly) NSString *mClassName;
@property (nonatomic, strong, readonly) NSString *mSuperClassName;

@property (nonatomic, strong, readonly) NSString *text;

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;

- (instancetype)initWithClassName:(NSString *)className superClassName:(NSString *)superClassName text:(NSString *)text;

/// 添加 property 查询结果列表
- (void)addPropertyTextCheckingResults:(NSArray<NSTextCheckingResult *> *)textCheckingResults;
/// 添加 方法 查询结果
- (void)addMethodTextCheckingResults:(NSArray<NSTextCheckingResult *> *)textCheckingResults;

@end

NS_ASSUME_NONNULL_END
