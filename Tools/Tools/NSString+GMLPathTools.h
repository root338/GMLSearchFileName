//
//  NSString+GMLPathTools.h
//  YMSearchFile
//
//  Created by GML on 2019/1/6.
//  Copyright © 2019 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GMLPathDefineTypeHeader.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSString (GMLPathTools)

@property (nonatomic, readonly) GMLPathType pathType;

@property (nonatomic, readonly) GMLFileType fileType;
@property (nonatomic, readonly) GMLFolderType folderType;

/**
 * 从 fromPath 到 toPath 的文件夹数组
 */
+ (nullable NSArray<NSString *> *)folderListAtFromPath:(NSString *)fromPath toPath:(NSString *)toPath;


@property (nonatomic, readonly) NSRange rangeOfAll;

@end

NS_ASSUME_NONNULL_END
