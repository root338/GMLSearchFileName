//
//  GMLClassFileProtocol.h
//  YMSearchFile
//
//  Created by apple on 2019/1/8.
//  Copyright © 2019 apple. All rights reserved.
//

#import "GMLFileSetProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@protocol GMLClassProtocol;

typedef NS_ENUM(NSInteger, GMLClassLanguageType) {
    GMLClassLanguageTypeOC,
    GMLClassLanguageTypeSwift,
};

typedef NS_ENUM(NSInteger, GMLPermissionType) {
    GMLPermissionTypePublic,
    GMLPermissionTypePrivate,
};

@protocol GMLClassFileProtocol <GMLFileSetProtocol>

@required
@property (nonatomic, strong, readonly) NSString *name;
@property (nonatomic, assign, readonly) GMLClassLanguageType classLanguageType;

/// 引用的所有文件列表
@property (nullable, nonatomic, strong, readonly) NSArray<id<GMLClassFileProtocol>> *importClassFileList;
/// 私有的文件列表 (在.m 文件中引用)
@property (nullable, nonatomic, strong, readonly) NSArray<id<GMLClassFileProtocol>> *privateClassFileList;
/// 公开的类文件列表(在.h 文件中引用)
@property (nullable, nonatomic, strong, readonly) NSArray<id<GMLClassFileProtocol>> *publicClassFileList;
/// 包含的类列表
@property (nullable, nonatomic, strong, readonly) NSArray<id<GMLClassProtocol>> *containClassList;

- (void)addImportClassFile:(id<GMLClassFileProtocol>)importClassFile permissionType:(GMLPermissionType)permissionType;
- (void)addCitedImportClassFile:(id<GMLClassFileProtocol>)importClassFile;



@end

NS_ASSUME_NONNULL_END
