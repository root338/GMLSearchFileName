//
//  GMLFileService.h
//  GMLRename
//
//  Created by apple on 2019/1/15.
//  Copyright © 2019 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
/**
 * 文件服务
 * 只有文件名相同的文件才可以添加
 */
@interface GMLFileService : NSObject

@property (nonatomic, strong, readonly) NSString *fileName;

- (nullable NSString *)getFilePathWithPathExtension:(NSString *)pathExtension;

- (BOOL)addFilePath:(NSString *)filePath;

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;

- (instancetype)initWithFileName:(NSString *)fileName;



@end

NS_ASSUME_NONNULL_END
