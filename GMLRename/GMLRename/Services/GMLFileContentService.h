//
//  GMLFileContentService.h
//  GMLRename
//
//  Created by apple on 2019/1/16.
//  Copyright © 2019 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class GMLTextContent;

/**
 * 存储文件内容
 */
@interface GMLFileContentService : NSObject

@property (nonatomic, strong, readonly) NSString *filePath;

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;

- (instancetype)initWithFilePath:(NSString *)filePath text:(GMLTextContent *)text;

@end

NS_ASSUME_NONNULL_END
