//
//  GMLLogService.h
//  YMSearchFile
//
//  Created by GML on 2019/1/5.
//  Copyright © 2019 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class YMFileMode, GMLFolderGroupingMode;

@interface GMLLogService : NSObject
/// 日志文件格式 默认txt
@property (nonatomic, strong) NSString *logFileFormat;

- (void)outputCitedGroupingFileModeData:(NSDictionary<NSNumber *, NSSet<YMFileMode *> *> *)citedGroupingFileModeDict folderPath:(NSString *)folderPath;

- (void)outputFolderGroupingDict:(NSDictionary<NSString *, GMLFolderGroupingMode *> *)folderGroupDict folderPath:(NSString *)folderPath;
@end

NS_ASSUME_NONNULL_END
