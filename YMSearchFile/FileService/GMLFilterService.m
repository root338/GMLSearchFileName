//
//  GMLFilterService.m
//  YMSearchFile
//
//  Created by GML on 2019/1/5.
//  Copyright © 2019 apple. All rights reserved.
//

#import "GMLFilterService.h"
#import "YMFileMode.h"

@implementation GMLFilterService

- (NSSet<YMFileMode *> *)fileModeSet:(NSSet<YMFileMode *> *)fileModeSet filterIncludePathExtensions:(NSSet<NSString *> *)filterIncludePathExtensions {
    NSMutableSet<YMFileMode *> *set = NSMutableSet.set;
    for (YMFileMode *fileMode in fileModeSet) {
        [filterIncludePathExtensions enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, BOOL * _Nonnull stop) {
            if ([fileMode containsPathExtension:obj]) {
                [set addObject:fileMode];
                *stop = YES;
            }
        }];
    }
    return set;
}

@end
