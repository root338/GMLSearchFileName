//
//  GMLPathProtocol.h
//  YMSearchFile
//
//  Created by apple on 2019/1/7.
//  Copyright © 2019 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol GMLPathProtocol <NSObject>

@property (nonatomic, strong, readonly) NSURL *pathURL;

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;

- (nullable instancetype)initWithPathURL:(NSURL *)pathURL;

@end

@protocol GMLFileProtocol <GMLPathProtocol>

@end

@protocol GMLFolderProtocol <GMLPathProtocol>

@property (nullable, nonatomic, strong, readonly) NSArray<id<GMLFolderProtocol>> *folderArray;
@property (nullable, nonatomic, strong, readonly) NSArray<id<GMLFileProtocol>> *fileArray;

- (void)addFolder:(id<GMLFolderProtocol>)folder;
- (void)addFile:(id<GMLFileProtocol>)file;

- (nullable id<GMLFolderProtocol>)folderAtURL:(NSURL *)URL;
- (nullable id<GMLFileProtocol>)fileAtURL:(NSURL *)URL;

@end

NS_ASSUME_NONNULL_END
