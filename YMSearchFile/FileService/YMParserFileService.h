//
//  YMParserFileService.h
//  YMSearchFile
//
//  Created by apple on 2019/1/4.
//  Copyright © 2019 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class YMFileMode;
@class YMParserFileService;

@protocol YMParserFileServiceDelegate <NSObject>

@required

@optional
//- (NSSet<NSString *> *)service:(YMParserFileService *)service fileMode:(YMFileMode *)fileMode importFileSet:(NSSet<NSString *> *)importFileSet;

@end

/**
 * 对文件进行解析
 * 解析文件
 */
@interface YMParserFileService : NSObject

@property (nonatomic, weak) id<YMParserFileServiceDelegate> delegate;

- (nullable NSSet<NSString *> *)parserImportFileWithFilePath:(NSString *)filePath;

@end

NS_ASSUME_NONNULL_END
