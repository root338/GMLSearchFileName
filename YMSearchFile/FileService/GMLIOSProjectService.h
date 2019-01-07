//
//  GMLXcodeFileService.h
//  YMSearchFile
//
//  Created by GML on 2019/1/6.
//  Copyright © 2019 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class YMFileMode, GMLProjectParser;

@interface GMLIOSProjectService : NSObject

/// 项目路径
@property (nonatomic, strong, readonly) NSURL *projectPath;
/// 项目索引路径
@property (nonatomic, strong, readonly) NSString *projectIndexPath;

//- (nullable YMFileMode *)fileModeAtPath:(NSString *)path;
//- (nullable GMLProjectParser *)folderModeAtPath:(NSString *)path;

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;

- (nullable instancetype)initWithProjectURL:(NSURL *)projectURL;
- (nullable instancetype)initWithProjectPath:(NSString *)projectPath;

@end

NS_ASSUME_NONNULL_END
