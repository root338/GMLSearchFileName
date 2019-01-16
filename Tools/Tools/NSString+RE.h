//
//  NSString+RE.h
//  GMLRename
//
//  Created by GML on 2019/1/16.
//  Copyright © 2019 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (RE)

- (void)runRE:(NSRegularExpression *)targetRE usingBlock:(void (NS_NOESCAPE^) (NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop))block;

- (NSArray<NSTextCheckingResult *> *)runRE:(NSRegularExpression *)targetRE;

@end

NS_ASSUME_NONNULL_END
