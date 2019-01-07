//
//  YMXcodeProjectFileService.h
//  YMSearchFile
//
//  Created by apple on 2019/1/4.
//  Copyright © 2019 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface YMXcodeProjectFileService : NSObject

//@property (class, nonatomic, strong, readonly) YMXcodeProjectFileService *defaultManager;

/// 项目文件配置列表路径
@property (nonatomic, strong) NSString *fileIndexPath;

/// 搜索忽略的路径
@property (nonatomic, copy) NSSet *ignoreSearchPathSet;

/// 移除时忽略的文件名
@property (nonatomic, copy) NSSet *ignoreRemoveFileNameSet;

/// 移除时忽略的文件名，及其该文件名下引用的所有文件
@property (nonatomic, strong) NSSet *ignoreRemoveFileAndIncludeFileNameSet;

//@property (nullable, nonatomic, strong) NSSet<NSString *> *ignorePathExtension;

/// 遍历指定目录
- (void)traversingPath:(NSString *)path;
/**
 * 根据 <= maxCitedFileNumber(小于等于被引用的个数) 的条件 删除文件
 * 现在仅删除包含 .h 的文件
 */
- (void)removeFileAtMaxCitedFileNumber:(NSUInteger)maxCitedFileNumber;

- (void)removeFolderGroupingWithDeleteFolderSet:(NSSet<NSString *> *)deleteFolderSet;

/// 打印出遍历的文件结果
- (void)outputCitedNumberLogWithFolderPath:(NSString *)folderPath;
/// 输出按 baseFolderSet 分组的文件日志
- (void)outputFolderGroupingLogWithFolderPath:(NSString *)folderPath baseFolderSet:(NSSet<NSString *> *)baseFolderSet;

- (void)outputFolderGroupingLogWithFolderPath:(NSString *)folderPath baseFolderSet:(NSSet<NSString *> *)baseFolderSet ignoreFolderSet:(NSSet<NSString *> *)ignoreFolderSet;

@end

NS_ASSUME_NONNULL_END
