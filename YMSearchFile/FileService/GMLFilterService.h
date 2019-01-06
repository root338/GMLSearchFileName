//
//  GMLFilterService.h
//  YMSearchFile
//
//  Created by GML on 2019/1/5.
//  Copyright © 2019 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class YMFileMode;
@interface GMLFilterService : NSObject

- (NSSet<YMFileMode *> *)fileModeSet:(NSSet<YMFileMode *> *)fileModeSet filterIncludePathExtensions:(NSSet<NSString *> *)filterIncludePathExtensions;

@end

NS_ASSUME_NONNULL_END
