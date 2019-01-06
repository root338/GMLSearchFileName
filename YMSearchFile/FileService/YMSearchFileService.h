//
//  YMSearchFileService.h
//  YMSearchFile
//
//  Created by apple on 2019/1/4.
//  Copyright © 2019 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class YMFileMode;
@class YMSearchFileService;

@protocol YMSearchFileServiceDelegate <NSObject>

@required

/**
 解析 filePath 中的文件，block 返回该文件导入的头文件
 */
//- (void)searchFile:(YMSearchFileService *)searchFile parserFilePath:(NSString *)filePath result:(void(^)(NSSet<NSString *> *importFileNames))result;

//- (void)service:(YMSearchFileService *)service identifier:(NSString *)identifier result:(NSMutableDictionary<NSString *, YMFileMode *> *)result;

@end

/**
 * 搜索指定路径下的所有文件
 */
@interface YMSearchFileService : NSObject

@property (nonatomic, strong) NSSet *ignorePathExtensionSet;
@property (nonatomic, weak) id<YMSearchFileServiceDelegate> delegate;

- (nullable NSDictionary<NSString *, YMFileMode *> *)searchPath:(NSString *)path ignorePathSet:(NSSet<NSString *> *)ignorePathSet error:(NSError **_Nullable)error;



@end

NS_ASSUME_NONNULL_END
