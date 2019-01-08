//
//  GMLXcodeFileService.h
//  YMSearchFile
//
//  Created by GML on 2019/1/6.
//  Copyright © 2019 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GMLIOSProjectService : NSObject

/// 项目索引路径
@property (nonatomic, strong) NSString *projectIndexPath;
/// swift 头文件
@property (nonatomic, strong) NSString *swiftHeaderName;

- (void)traversingPath:(NSURL *)pathURL;

@end

NS_ASSUME_NONNULL_END
