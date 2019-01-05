//
//  GMLDeleteFileService.h
//  YMSearchFile
//
//  Created by GML on 2019/1/5.
//  Copyright © 2019 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@class YMFileMode;
@class GMLDeleteFileService;

NS_ASSUME_NONNULL_BEGIN

@protocol GMLDeleteFileServiceDelegate <NSObject>

@required
///// 删除成功
//- (void)service:(GMLDeleteFileService *)service didDeleteFileMode:(YMFileMode *)fileMode;
///// 删除失败
//- (void)service:(GMLDeleteFileService *)service error:(NSError *)error;

@end

/**
 * 删除文件服务
 */
@interface GMLDeleteFileService : NSObject

@property (nonatomic, weak) id<GMLDeleteFileServiceDelegate> delegate;


/**
 删除集合中的文件，如果有索引，同时删除索引中的文件项
 @param fileIndexPath 文件索引
 */
- (void)deleteFileSet:(NSSet<YMFileMode *> *)fileSet fileIndexPath:(nullable NSString *)fileIndexPath;

@end

NS_ASSUME_NONNULL_END
