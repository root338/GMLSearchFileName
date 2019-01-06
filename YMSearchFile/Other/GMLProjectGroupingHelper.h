//
//  GMLProjectGroupingHelper.h
//  YMSearchFile
//
//  Created by GML on 2019/1/5.
//  Copyright © 2019 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GMLProjectGroupingHelper : NSObject

/**
 给定path下的子级目录为基础文件夹

 @param paths 给定路径
 @param subpathLevel 获取的子目录层级，0 为当前目录, 1 为子级目录, 以此类推......
 @return 返回基础目录文件夹
 */
+ (NSSet<NSString *> *)baseFolderSetWithPaths:(NSSet<NSString *> *)paths subpathlevel:(NSUInteger)subpathLevel;

@end

NS_ASSUME_NONNULL_END
