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



- (void)replaceProjectFile {
    // 替换项目索引内容
    [self.projectContent writeToFile:self.projectFilePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
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
