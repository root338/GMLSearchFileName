//
//  GMLFolderGroupingMode.h
//  YMSearchFile
//
//  Created by GML on 2019/1/5.
//  Copyright © 2019 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class YMFileMode;

/**
 * 以文件夹为界限包含文件
 * 注意：！！！ 为了防止对象间循环引用，该对象不强引用包含的文件夹和被引用的文件夹
 */
@interface GMLFolderGroupingMode : NSObject

@property (nonatomic, copy, readonly) NSString *folderPath;
/// 包含的所有文件
@property (nullable, nonatomic, readonly) NSArray<YMFileMode *> *allFileMode;
/// 引用的所有文件
@property (nullable, nonatomic, readonly) NSDictionary<NSString *, NSArray<YMFileMode *> *> *includeFileModeDict;
/// 被引用的所有文件
@property (nullable, nonatomic, readonly) NSArray<YMFileMode *> *citedFileModeArray;
/// 仅在内部文件夹使用
@property (nullable, nonatomic, strong, readonly) NSArray<YMFileMode *> *onlyInternalUseFileModeArray;
/// 被其他文件夹引用相关联的文件
@property (nullable, nonatomic, strong, readonly) NSArray<YMFileMode *> *citedRelationFileModeArray;

/// 文件夹存在的文件
- (void)addFileMode:(YMFileMode *)fileMode;

/// 文件夹需要外部的文件
- (void)addIncludeFolder:(NSString *)includeFolder fileMode:(YMFileMode *)fileMode;

/// 被其他文件夹引用的文件
- (void)addCitedOtherFolderWithFileMode:(YMFileMode *)fileMode;

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;

- (nullable instancetype)initWithFolderPath:(NSString *)folderPath;

@end

NS_ASSUME_NONNULL_END
