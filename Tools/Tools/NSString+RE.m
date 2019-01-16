//
//  NSString+RE.m
//  GMLRename
//
//  Created by GML on 2019/1/16.
//  Copyright © 2019 apple. All rights reserved.
//

#import "NSString+RE.h"
#import "NSString+GMLPathTools.h"

@implementation NSString (RE)

- (void)runRE:(NSRegularExpression *)targetRE usingBlock:(void (NS_NOESCAPE^) (NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop))block {
    [targetRE enumerateMatchesInString:self options:NSMatchingReportProgress range:self.rangeOfAll usingBlock:block];
}

- (NSArray<NSTextCheckingResult *> *)runRE:(NSRegularExpression *)targetRE {
    return [targetRE matchesInString:self options:NSMatchingReportCompletion range:self.rangeOfAll];
}

@end
