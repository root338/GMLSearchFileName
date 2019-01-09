//
//  GMLFolderProtocol.h
//  YMSearchFile
//
//  Created by apple on 2019/1/8.
//  Copyright © 2019 apple. All rights reserved.
//

#import "GMLPathProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@protocol GMLFileProtocol;

@protocol GMLFolderProtocol <GMLPathProtocol>

@property (nullable, nonatomic, strong, readonly) NSArray<id<GMLFolderProtocol>> *folderArray;
@property (nullable, nonatomic, strong, readonly) NSArray<id<GMLFileProtocol>> *fileArray;

- (void)addFolder:(id<GMLFolderProtocol>)folder;
- (void)addFile:(id<GMLFileProtocol>)file;

- (nullable id<GMLFolderProtocol>)addFolderWithName:(NSString *)folderName;

/// 添加路径, 并创建路径中涉及的所有文件夹
- (id<GMLFolderProtocol>)addFolderWithPath:(NSURL *)path isDirectory:(nullable BOOL *)isDirectory;

/// 获取指定 URL 在该文件夹中最近的文件夹
- (nullable id<GMLFolderProtocol>)getOfLateFolderAtURL:(NSURL *)URL;
- (nullable id<GMLFolderProtocol>)folderAtURL:(NSURL *)URL;
- (nullable id<GMLFileProtocol>)fileAtURL:(NSURL *)URL;

- (nullable id<GMLFolderProtocol>)folderAtName:(NSString *)folderName;
- (nullable id<GMLFileProtocol>)fileAtName:(NSString *)fileName;

@end

NS_ASSUME_NONNULL_END
