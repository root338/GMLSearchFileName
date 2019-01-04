//
//  YMSearchFile.h
//  YMSearchFile
//
//  Created by apple on 2019/1/4.
//  Copyright © 2019 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class YMFileMode;
@class YMSearchFile;

@protocol YMSearchFileDelegate <NSObject>

@required

/**
 解析 filePath 中的文件，block 返回该文件导入的头文件
 */
- (void)searchFile:(YMSearchFile *)searchFile parserFilePath:(NSString *)filePath result:(void(^)(NSSet<NSString *> *importFileNames))result;

@end

@interface YMSearchFile : NSObject

@property (nonatomic, copy) NSSet *ignoreSearchPathSet;

@property (nonatomic, weak) id<YMSearchFileDelegate> delegate;

- (NSDictionary<NSString *, YMFileMode *> *)searchPath:(NSString *)path;

@end

NS_ASSUME_NONNULL_END
