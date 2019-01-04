//
//  YMParserFileImport.m
//  YMSearchFile
//
//  Created by apple on 2019/1/4.
//  Copyright © 2019 apple. All rights reserved.
//

#import "YMParserFileImport.h"

@interface YMParserFileImport ()

@property (nonatomic, strong) NSRegularExpression *regularExpression;

@end

@implementation YMParserFileImport

- (void)filePath:(NSString *)filePath result:(nonnull void (^)(NSSet<NSString *> *))result {
    NSString *content = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    NSMutableSet *includeFileNameList = NSMutableSet.set;
    NSString *originFileName = [[filePath lastPathComponent] stringByDeletingPathExtension];
    [self.regularExpression enumerateMatchesInString:content options:NSMatchingReportProgress range:NSMakeRange(0, content.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
        if (result != nil) {
            NSString *importText = [content substringWithRange:result.range];
            importText = [importText stringByReplacingOccurrencesOfString:@" " withString:@""];
            NSRange range = [importText rangeOfString:@"\""];
            NSString *fileName = [importText substringFromIndex:range.location + 1];
            fileName = [fileName substringToIndex:fileName.length - 3];
            if (![fileName isEqualToString:originFileName]) {
                [includeFileNameList addObject:fileName];
            }
        }
    }];
    result(includeFileNameList);
}

- (NSRegularExpression *)regularExpression {
    if (_regularExpression == nil) {
        NSString *pattern = @"#import[\\s]*\\\"[^\\\"\\s\\n\\r]*\\\"";
        _regularExpression = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
    }
    return _regularExpression;
}



@end