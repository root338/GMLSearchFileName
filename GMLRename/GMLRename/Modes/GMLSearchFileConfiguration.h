//
//  GMLSearchFileConfiguration.h
//  GMLRename
//
//  Created by apple on 2019/1/15.
//  Copyright © 2019 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GMLSearchFileConfiguration : NSObject
/// 忽略的扩展名
@property (nullable, nonatomic, strong) NSSet<NSString *> *ignorePathExtensionSet;
/// 忽略名字(文件/文件夹)的前缀
@property (nullable, nonatomic, strong) NSSet<NSString *> *ignoreNamePrefixSet;
/// 忽略名字(文件/文件夹)的后缀
@property (nullable, nonatomic, strong) NSSet<NSString *> *ignoreNameSuffixSet;

@end

NS_ASSUME_NONNULL_END
