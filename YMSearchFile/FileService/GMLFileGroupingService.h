//
//  GMLFileGroupingService.h
//  YMSearchFile
//
//  Created by GML on 2019/1/5.
//  Copyright © 2019 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class YMFileMode, GMLFolderGroupingMode;

/**
 * 文件分组服务
 * 对文件按规定的规则进行分组
 */
@interface GMLFileGroupingService : NSObject
///根据被引用的数量分组
- (nullable NSDictionary<NSNumber *, NSSet<YMFileMode *> *> *)accordingToCitedGroupingFileWithFileModeSet:(NSSet<YMFileMode *> *)fileModeSet completion:(void (NS_NOESCAPE ^ _Nullable) (NSUInteger minCitedCount, NSUInteger p))completion;

///根据基础目录分组
- (nullable NSDictionary<NSString *, GMLFolderGroupingMode *> *)accordingToBasePathGroupingFileWithFileModeSet:(NSSet<YMFileMode *> *)fileModeSet basePathSet:(NSSet<NSString *> *)basePathSet;

- (nullable NSDictionary<NSString *, GMLFolderGroupingMode *> *)accordingToBasePathGroupingFileWithFileModeSet:(NSSet<YMFileMode *> *)fileModeSet basePathSet:(NSSet<NSString *> *)basePathSet ignoreBasePathSet:(nullable NSSet<NSString *> *)ignoreBasePathSet;

- (NSSet<YMFileMode *> *)accordingToBasePathGroupingFileWithFileModeSet:(nullable NSSet<YMFileMode *> *)fileModeSet shouldDeletePathSet:(nullable NSSet<NSString *> *)shouldDeletePathSet;

@end

NS_ASSUME_NONNULL_END
