//
//  YMProjectMode.h
//  YMSearchFile
//
//  Created by apple on 2019/1/4.
//  Copyright © 2019 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YMProjectMode : NSObject

/// 项目文件配置列表
@property (nonatomic, strong) NSString *projectFilePath;
@property (nonatomic, readonly) NSString *projectTextContent;

- (void)replaceProjectFile;
@end

NS_ASSUME_NONNULL_END
