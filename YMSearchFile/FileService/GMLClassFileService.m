//
//  GMLClassFileService.m
//  YMSearchFile
//
//  Created by apple on 2019/1/9.
//  Copyright © 2019 apple. All rights reserved.
//

#import "GMLClassFileService.h"

#import "NSURL+GMLPathAdd.h"
#import "GMLFolderUnitsHeader.h"

@interface GMLClassFileService ()

/// 查找注释
@property (nonatomic, strong) NSRegularExpression *findNoteRE;
/// 查找导入的文件
@property (nonatomic, strong) NSRegularExpression *findImportFileRE;
/// 查找类
@property (nonatomic, strong) NSRegularExpression *findClassRE;
@end

@implementation GMLClassFileService

- (void)parserClassFile:(id<GMLClassFileProtocol>)classFile {
    switch (classFile.classLanguageType) {
        case GMLClassLanguageTypeOC:
            [self handleOCClassFile:classFile];
            break;
        case GMLClassLanguageTypeSwift:
            [self handleSwiftClass:classFile];
            break;
            
        default:
            break;
    }
}

- (NSURL *)handleFolderWithFile:(id<GMLFileProtocol>)file {
    for (NSURL *folderURL in _folderArray) {
        if ([file.pathURL isIncludeURL:folderURL]) {
            return folderURL;
        }
    }
    return nil;
}

#pragma mark - OC
- (void)handleOCClassFile:(id<GMLClassFileProtocol>)targetClassFile {
    BOOL endSearchExistPath = NO;
    NSURL *existPathURL = nil;
    for (id<GMLFileProtocol> file in targetClassFile.fileArray) {
        
        if (_folderArray.count && !endSearchExistPath) {
            NSURL *tmpExistPathURL = [self handleFolderWithFile:file];
            if (existPathURL == nil) {
                existPathURL = tmpExistPathURL;
            }
            if (tmpExistPathURL == nil || ![existPathURL isEqual:tmpExistPathURL]) {
                endSearchExistPath = YES;
                existPathURL = nil;
            }
        }
        
        NSURL *pathURL = file.pathURL;
        NSString *originContent = [NSString stringWithContentsOfURL:pathURL encoding:NSUTF8StringEncoding error:nil];
        if (originContent == nil) {
            continue;
        }
        NSString *content = [self filterNoteWithContent:originContent];
        GMLFileType fileType = pathURL.fileType;
        GMLPermissionType permissionType = fileType == GMLFileTypeH ? GMLPermissionTypePublic : GMLPermissionTypePrivate;
        [self findImportFileWithContent:content usingBlock:^(NSString *importName) {
            
            if (![importName isEqualToString:targetClassFile.name]) {
                id<GMLClassFileProtocol> classFileObj = [self.delegate service:self sourceClassFile:targetClassFile importFileName:importName];
                if (classFileObj) {
                    [targetClassFile addImportClassFile:classFileObj permissionType:permissionType];
                    [classFileObj addCitedImportClassFile:targetClassFile];
                }
            }
        }];        
    }
    if ([self.delegate respondsToSelector:@selector(service:sourceClassFile:existFolder:)]) {
        [self.delegate service:self sourceClassFile:targetClassFile existFolder:existPathURL];
    }
    
}

- (void)findImportFileWithContent:(NSString *)content usingBlock:(void (NS_NOESCAPE ^) (NSString *importName))block {
    
    [self.findImportFileRE enumerateMatchesInString:content options:NSMatchingReportCompletion range:NSMakeRange(0, content.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
        if (result) {
            NSString *importContent = [content substringWithRange:result.range];
            importContent = [importContent stringByReplacingOccurrencesOfString:@" " withString:@""];
            NSRange range = [importContent rangeOfString:@"\""];
            NSString *fileName = [importContent substringFromIndex:range.location + 1];
            fileName = [[fileName substringToIndex:fileName.length - 1] stringByDeletingPathExtension];
            !block?: block(fileName);
        }
    }];
}

- (NSString *)filterNoteWithContent:(NSString *)content {
    NSMutableString *newFileContent = NSMutableString.new;
    __block NSUInteger previousLocation = 0;
    [self runRE:self.findNoteRE matchesInString:content usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
        if (result != nil) {
            [newFileContent appendString:[content substringWithRange:NSMakeRange(previousLocation, result.range.location - previousLocation)]];
            previousLocation = result.range.location + result.range.length;
        }
    }];
    if (previousLocation != content.length) {
        [newFileContent appendString:[content substringFromIndex:previousLocation]];
    }
    return newFileContent;
}

- (NSString *)importFileNameWithContent:(NSString *)content {
    
    content = [content stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSRange range = [content rangeOfString:@"\""];
    NSString *fileName = [content substringFromIndex:range.location + 1];
    fileName = [fileName substringToIndex:fileName.length - 3];
    return fileName;
}

#pragma mark - Swift
- (void)handleSwiftClass:(id<GMLClassFileProtocol>)targetClass {
    
}

- (void)runRE:(NSRegularExpression *)targetRE matchesInString:(NSString *)string usingBlock:(void (^) (NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop))block {
    [targetRE enumerateMatchesInString:string options:NSMatchingReportProgress range:NSMakeRange(0, string.length) usingBlock:block];
}

#pragma mark - Getter & Setter

- (NSRegularExpression *)findImportFileRE {
    if (_findImportFileRE == nil) {
        NSString *pattern = @"#import[\\s]*\\\"[^\\\"]*\\\"";
        _findImportFileRE = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
    }
    return _findImportFileRE;
}

- (NSRegularExpression *)findClassRE {
    if (_findClassRE == nil) {
        NSString *pattern = @"(@interface|@implementation)((?!@end).)*@end";
        _findClassRE = [[NSRegularExpression alloc] initWithPattern:pattern options:NSRegularExpressionDotMatchesLineSeparators error:nil];
    }
    return _findClassRE;
}

- (NSRegularExpression *)findNoteRE {
    if (_findNoteRE == nil) {
        NSString *pattern = @"(//[^\\\n]*)|(/\\*((?!\\*/).)*\\*/)";
        _findNoteRE = [[NSRegularExpression alloc] initWithPattern:pattern options:NSRegularExpressionDotMatchesLineSeparators error:nil];
    }
    return _findNoteRE;
}
@end
