//
//  YMProjectMode.m
//  YMSearchFile
//
//  Created by apple on 2019/1/4.
//  Copyright © 2019 apple. All rights reserved.
//

#import "YMProjectMode.h"

@interface YMProjectMode ()

@property (nonatomic, strong) NSMutableString *projectContent;
@end

@implementation YMProjectMode

- (void)deleteFileName:(NSString *)fileName fileExtension:(NSString *)fileExtension {
    
    NSString *fileFullName = nil;
    if (fileExtension) {
        fileFullName = [fileName stringByAppendingPathExtension:fileExtension];
    }else {
        fileFullName = fileName;
    }
    
    NSString *pattern = [NSString stringWithFormat:@"\\\n[^\\\n]*%@[^\\\n]*", fileFullName];
    NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:nil];
    
    NSMutableString *projectContent = self.projectContent;
    for (; YES; ) {
        NSTextCheckingResult *result = [regularExpression firstMatchInString:projectContent options:NSMatchingReportProgress range:NSMakeRange(0, projectContent.length)];
        if (result == nil) {
            break;
        }
        [projectContent replaceCharactersInRange:result.range withString:@""];
    }
}

- (NSMutableString *)projectContent {
    if (_projectContent == nil) {
        _projectContent = [NSMutableString stringWithContentsOfFile:self.projectFilePath encoding:NSUTF8StringEncoding error:nil];
    }
    return _projectContent;
}

- (void)setProjectFilePath:(NSString *)projectFilePath {
    if (![_projectFilePath isEqualToString:projectFilePath]) {
        _projectFilePath = projectFilePath;
        _projectContent = nil;
    }
}

- (NSString *)projectTextContent {
    return self.projectContent;
}

@end
