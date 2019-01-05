//
//  GMLLogService.m
//  YMSearchFile
//
//  Created by GML on 2019/1/5.
//  Copyright © 2019 apple. All rights reserved.
//

#import "GMLLogService.h"

#import "YMFileMode.h"
#import "GMLFolderGroupingMode.h"

@interface GMLLogService ()

@end

@implementation GMLLogService

- (void)outputCitedGroupingFileModeData:(NSDictionary<NSNumber *,NSSet<YMFileMode *> *> *)citedGroupingFileModeDict folderPath:(nonnull NSString *)folderPath {
    // 输出日志
    NSString *logFileFormat = self.logFileFormat;
    NSString *logFolderPath = [self getLogFolderWithPath:folderPath];
    [citedGroupingFileModeDict enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, NSSet * _Nonnull obj, BOOL * _Nonnull stop) {
        NSString *filePath = [[logFolderPath stringByAppendingPathComponent:[key stringValue]] stringByAppendingPathExtension:logFileFormat];
        NSMutableString *text = NSMutableString.string;
        for (YMFileMode *fileMode in obj) {
            [text appendFormat:@"%@\n%@\n",fileMode.fileName, fileMode.hFilePath];
        }
        [text writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }];
}

- (void)outputFolderGroupingDict:(NSDictionary<NSString *,GMLFolderGroupingMode *> *)folderGroupDict folderPath:(NSString *)folderPath {
    
    NSString *logFolderPath = [self getLogFolderWithPath:folderPath];
    
    [folderGroupDict enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, GMLFolderGroupingMode * _Nonnull obj, BOOL * _Nonnull stop) {
        
        NSString *filePath = [self autoGeneratePathWithFolderPath:logFolderPath fileName:key.lastPathComponent];
        NSMutableString *logContent = [NSMutableString stringWithFormat:@"%@ 目录下内容:\n", key];
        
        void (^inputLog) (NSArray *) = ^(NSArray *tmpFileModeArray) {
            for (YMFileMode *fileMode in tmpFileModeArray) {
                [logContent appendFormat:@"%@\n",fileMode.fileName];
            }
        };
        void(^inputDictLog) (NSString *, NSDictionary<NSString *, NSArray<YMFileMode *> *> *) = ^(NSString *title, NSDictionary<NSString *, NSArray<YMFileMode *> *> *fileModeDict) {
            [logContent appendString:[self autoGenerateMarkWithText:@"=" title:title]];
            [fileModeDict enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull baseFilePath, NSArray<YMFileMode *> * _Nonnull fileArray, BOOL * _Nonnull stop) {
                [logContent appendFormat:@"<<<<< %@\n", baseFilePath];
                inputLog(fileArray);
            }];
        };
        
        [logContent appendString:[self autoGenerateMarkWithText:@"=" title:@"文件夹包含的文件"]];
        inputLog(obj.allFileMode);
        [logContent appendString:@"\n\n"];
        inputDictLog(@"引用的外部文件", obj.includeFileModeDict);
        [logContent appendString:@"\n\n"];
        inputDictLog(@"被外部文件引用的文件", obj.citedFileModeDict);
        
        [logContent writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }];
}

- (NSString *)autoGenerateMarkWithText:(NSString *)text title:(NSString *)title {
    NSInteger textTotal = 0;
    if (title.length % 2 == 0) {
        textTotal = 30;
    }else {
        textTotal = 31;
    }
    
    NSString *(^createMarkText) (NSUInteger, NSString *) = ^(NSUInteger count, NSString *markText){
        NSMutableString *tmpText = NSMutableString.string;
        for (NSInteger i = 0; i < count; i++) {
            [tmpText appendString:markText];
        }
        return tmpText;
    };
    
    NSMutableString *markText = NSMutableString.string;
    
    NSUInteger spaceTextCount = 5;
    NSUInteger markTextCount = (textTotal - title.length) / 2 - spaceTextCount;
    if (markTextCount < 0) {
        spaceTextCount = 0;
    }
    [markText appendString:createMarkText(textTotal, text)];
    [markText appendString:@"\n"];
    [markText appendString:createMarkText(markTextCount, text)];
    [markText appendString:createMarkText(spaceTextCount, @" ")];
    [markText appendString:title];
    [markText appendString:createMarkText(spaceTextCount, @" ")];
    [markText appendString:createMarkText(markTextCount, text)];
    [markText appendString:@"\n"];
    [markText appendString:createMarkText(markTextCount, text)];
    [markText appendString:@"\n"];
    
    return markText;
}

- (NSString *)autoGeneratePathWithFolderPath:(NSString *)folderPath fileName:(NSString *)fileName {
    NSInteger count = 0;
    NSString *filePath = nil;
    do {
        if (count == 0) {
            filePath = [[folderPath stringByAppendingPathComponent:fileName] stringByAppendingPathExtension:self.logFileFormat];
        }else {
            filePath = [[folderPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@-%li", fileName, (long)count]] stringByAppendingPathExtension:self.logFileFormat];
        }
        count++;
    } while ([[NSFileManager defaultManager] fileExistsAtPath:filePath]);
    return filePath;
}

- (NSString *)getLogFolderWithPath:(NSString *)path {
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay|NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond fromDate:[NSDate date]];
    NSString *folderName = [NSString stringWithFormat:@"%li-%02li-%02li %02li-%02li-%02li", (long)dateComponents.year, (long)dateComponents.month, (long)dateComponents.day, (long)dateComponents.hour, (long)dateComponents.minute, (long)dateComponents.second];
    NSString *logFolderPath = [path stringByAppendingPathComponent:folderName];
    [[NSFileManager defaultManager] createDirectoryAtPath:logFolderPath withIntermediateDirectories:YES attributes:nil error:nil];
    
    return logFolderPath;
}

- (NSString *)logFileFormat {
    if (_logFileFormat == nil) {
        _logFileFormat = @"txt";
    }
    return _logFileFormat;
}

@end
