//
//  GMLTextContent.h
//  GMLRename
//
//  Created by apple on 2019/1/16.
//  Copyright © 2019 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class GMLClassText;

@interface GMLTextContent : NSObject

@property (nonatomic, copy, readonly) NSString *text;

@property (nonatomic, copy, readonly) NSString *ignoreNoteText;

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;

- (instancetype)initWithText:(NSString *)text;

- (void)addNoteTextCheckingResults:(NSArray<NSTextCheckingResult *> *)textCheckingResults;

#pragma mark -
// 以下方法都是排除注释之后的查询结果

/// 添加导入文件查询结果列表
- (void)addImportTextCheckingResults:(NSArray<NSTextCheckingResult *> *)textCheckingResults;
/// 添加 class 查询结果列表
- (void)addClassTextCheckingResults:(NSArray<NSTextCheckingResult *> *)textCheckingResults;
/// 添加 enum 查询结果列表
- (void)addEnumTextCheckingResults:(NSArray<NSTextCheckingResult *> *)textCheckingResults;
/// 添加 typedef 声明的类型查询结果列表
- (void)addTypedefTextCheckingResults:(NSArray<NSTextCheckingResult *> *)textCheckingResults;
/// 添加类信息
- (void)addClassText:(GMLClassText *)classText result:(NSTextCheckingResult *)result;

@end

NS_ASSUME_NONNULL_END
