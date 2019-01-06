//
//  GMLFolderService.h
//  YMSearchFile
//
//  Created by GML on 2019/1/6.
//  Copyright © 2019 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GMLPathDefineTypeHeader.h"

NS_ASSUME_NONNULL_BEGIN

@interface GMLFolderService : NSObject

@property (nonatomic, assign, readonly) GMLFolderType folderType;
@property (nonatomic, strong, readonly) NSString *folderPath;

@property (nonatomic, readonly) NSArray<NSString *> *filePathArrays;
@property (nonatomic, readonly) NSArray<GMLFolderService *> *folderModes;

- (BOOL)containsPath:(NSString *)path;
//- (BOOL)addFolderMode:(GMLFolderService *)folderMode;
//- (nullable NSString *)addFilePath:(NSString *)filePath;
//- (BOOL)addPath:(NSString *)path;

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;

- (nullable instancetype)initWithFolderPath:(NSString *)folderPath;

@end

NS_ASSUME_NONNULL_END
