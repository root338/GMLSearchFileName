//
//  GMLFileService.h
//  YMSearchFile
//
//  Created by GML on 2019/1/6.
//  Copyright © 2019 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class YMFileMode, GMLFolderService;

@interface GMLFileService : NSObject

//- (nullable YMFileMode *)fileModeAtPath:(NSString *)path;
//- (nullable GMLFolderService *)folderModeAtPath:(NSString *)path;

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;

- (nullable instancetype)initWithPath:(NSString *)path;

@end

NS_ASSUME_NONNULL_END
