//
//  YMSearchFile.m
//  YMSearchFile
//
//  Created by apple on 2019/1/4.
//  Copyright © 2019 apple. All rights reserved.
//

#import "YMSearchFileService.h"

#import "YMFileMode.h"

@interface YMSearchFileService ()

@property (nonatomic, copy) NSMutableDictionary<NSString *, YMFileMode *> *(^saveContainer)(void);
@property (nonatomic, copy) NSSet<NSString *> *(^ignorePathSet)(void);

@end

@implementation YMSearchFileService

- (NSDictionary<NSString *,YMFileMode *> *)searchPath:(NSString *)path ignorePathSet:(NSSet<NSString *> *)ignorePathSet error:(NSError * _Nullable __autoreleasing *)error {
    NSMutableDictionary *result = NSMutableDictionary.dictionary;
    
    self.ignorePathSet = ^NSSet<NSString *> *{
        return ignorePathSet;
    };
    self.saveContainer = ^NSMutableDictionary<NSString *,YMFileMode *> *{
        return result;
    };
    [self searchAtPath:path];
    return result;
}

- (void)searchAtPath:(NSString *)path {
    if ([self.ignorePathSet() containsObject:path]) {
        return;
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDirectory = YES;
    if (![fileManager fileExistsAtPath:path isDirectory:&isDirectory]) {
        return;
    }
    if (!isDirectory) {
        [self addFilePath:path];
    }else {
        NSArray *list = [fileManager contentsOfDirectoryAtPath:path error:nil];
        for (NSString *name in list) {
            if ([name hasPrefix:@"."]) {
                continue;
            }
            [self searchAtPath:[path stringByAppendingPathComponent:name]];
        }
    }
}

- (void)addFilePath:(NSString *)filePath {
    
    NSString *fileName = [[filePath lastPathComponent] stringByDeletingPathExtension];
    YMFileMode *fileMode = [self fileModeAtFileName:fileName];
    [fileMode addFileRelationPath:filePath];
}

- (YMFileMode *)fileModeAtFileName:(NSString *)fileName {
    YMFileMode *fileMode = self.saveContainer()[fileName];
    if (fileMode == nil) {
        fileMode = [[YMFileMode alloc] initWithFileName:fileName];
        [self.saveContainer() setObject:fileMode forKey:fileName];
    }
    return fileMode;
}

@end
