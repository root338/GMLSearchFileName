//
//  GMLDeleteFileService.m
//  YMSearchFile
//
//  Created by GML on 2019/1/5.
//  Copyright © 2019 apple. All rights reserved.
//

#import "GMLDeleteFileService.h"

#import "YMFileMode.h"

@interface GMLDeleteFileService ()

@property (nonatomic, strong) NSString *fileIndexContent;

@end

@implementation GMLDeleteFileService

- (void)deleteFileSet:(NSSet<YMFileMode *> *)fileSet fileIndexPath:(nullable NSString *)fileIndexPath {
    
    NSMutableString *fileIndexContent = [NSMutableString stringWithContentsOfFile:fileIndexPath encoding:NSUTF8StringEncoding error:nil];
    
    for (YMFileMode *fileMode in fileSet) {
        NSSet<NSString *> *filePaths = fileMode.allRelationPathSet;
        [filePaths enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, BOOL * _Nonnull stop) {
            [[NSFileManager defaultManager] removeItemAtPath:obj error:nil];
        }];
        // \. 正则中单独的"."表示匹配任意字符，所以需要转义
        NSString *fileName = [fileMode.fileName stringByAppendingString:@"\\."];
        [self fileIndexContent:fileIndexContent deleteFileName:fileName fileExtension:nil];
    }
    // 替换项目索引内容
    [fileIndexContent writeToFile:fileIndexPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

- (void)fileIndexContent:(NSMutableString *)fileIndexPath deleteFileName:(NSString *)fileName fileExtension:(NSString *)fileExtension {
    
    NSString *fileFullName = nil;
    if (fileExtension) {
        fileFullName = [fileName stringByAppendingPathExtension:fileExtension];
    }else {
        fileFullName = fileName;
    }
    
    NSString *pattern = [NSString stringWithFormat:@"\\\n[^\\\n]*%@[^\\\n]*", fileFullName];
    NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:nil];
    
    for (; YES; ) {
        NSTextCheckingResult *result = [regularExpression firstMatchInString:fileIndexPath options:NSMatchingReportProgress range:NSMakeRange(0, fileIndexPath.length)];
        if (result == nil) {
            break;
        }
        [fileIndexPath replaceCharactersInRange:result.range withString:@""];
    }
}

@end
