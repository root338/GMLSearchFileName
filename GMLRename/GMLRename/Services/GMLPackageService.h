//
//  GMLPackageService.h
//  GMLRename
//
//  Created by apple on 2019/1/15.
//  Copyright © 2019 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class GMLFileService;
/**
 * 包管理服务
 * 将xcode项目中的 .framework .bundle 等扩展名文件夹也理解为包
 */
@interface GMLPackageService : NSObject

@property (nonatomic, strong, readonly) NSString *packagePath;

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;

- (instancetype)initWithPackagePath:(NSString *)packagePath;

- (void)addFileService:(GMLFileService *)fileService;
- (BOOL)containsFileService:(GMLFileService *)fileService;
@end

NS_ASSUME_NONNULL_END
