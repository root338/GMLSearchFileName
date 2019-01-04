//
//  YMFileManager.h
//  YMSearchFile
//
//  Created by apple on 2019/1/4.
//  Copyright © 2019 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@interface YMFileManager : NSObject

@property (class, nonatomic, strong, readonly) YMFileManager *defaultManager;
/// 项目文件配置列表路径
@property (nonatomic, strong) NSString *projectFilePath;
/// 获取文件配置列表内容
@property (nonatomic, readonly) NSString *projectTextContent;
/// 删除没有被引用的文件，默认为 NO
@property (nonatomic, assign) BOOL removeNotIncludeFileName;
/// 搜索路径的黑名单
@property (nonatomic, copy) NSSet *searchPathBlackList;
/// 移除文件名的黑名单
@property (nonatomic, copy) NSSet *removeFileNameBlackList;
/// 移除文件模型，及其引用类的来名单
@property (nonatomic, strong) NSSet *removeFileNameAndIncludeBlackList;

- (void)searchPath:(NSString *)path;

- (nullable NSMutableDictionary *)inputAllFileMode;
/// 遍历指定目录
- (void)traversingPath:(NSString *)path;
/// 根据被引用文件数对文件分级
- (void)citedFileNumberGrading;
/// 根据 < lessCitedFileNumber(小于被引用的个数) 的条件 删除文件
- (void)removeFileAtLessCitedFileNumber:(NSInteger)lessCitedFileNumber;

@end

NS_ASSUME_NONNULL_END
