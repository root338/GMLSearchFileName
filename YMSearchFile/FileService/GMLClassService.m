//
//  GMLClassService.m
//  YMSearchFile
//
//  Created by apple on 2019/1/8.
//  Copyright © 2019 apple. All rights reserved.
//

#import "GMLClassService.h"
#import "GMLFileProtocol.h"
#import "GMLClassFileProtocol.h"
#import "NSURL+GMLPathAdd.h"

@interface GMLClassService ()
/// 查找注释
@property (nonatomic, strong) NSRegularExpression *findNoteRE;
/// 查找导入的文件
@property (nonatomic, strong) NSRegularExpression *findImportFileRE;
/// 查找类
@property (nonatomic, strong) NSRegularExpression *findClassRE;
/// 查找属性
@property (nonatomic, strong) NSRegularExpression *findPropertyRE;
/// 查找方法
@property (nonatomic, strong) NSRegularExpression *findMethodRE;
/// 查找方法名
@property (nonatomic, strong) NSRegularExpression *findMethodNameRE;
/// 查找方法体
@property (nonatomic, strong) NSRegularExpression *findMethodBodyRE;

@end

@implementation GMLClassService
- (void)parserClass:(id<GMLClassFileProtocol>)targetClass {
    
    switch (targetClass.classLanguageType) {
        case GMLClassLanguageTypeOC:
            [self handleOCClass:targetClass];
            break;
        case GMLClassLanguageTypeSwift:
            [self handleSwiftClass:targetClass];
            break;
            
        default:
            break;
    }
}

#pragma mark - OC
- (void)handleOCClass:(id<GMLClassFileProtocol>)targetClass {
    for (id<GMLFileProtocol> file in targetClass.fileArray) {
        NSURL *pathURL = file.pathURL;
        NSString *originContent = [NSString stringWithContentsOfURL:pathURL encoding:NSUTF8StringEncoding error:nil];
        if (originContent == nil) {
            continue;
        }
        NSString *content = [self filterNoteWithContent:originContent];
        [self findClassWithContent:content];
        GMLFileType fileType = pathURL.fileType;
        if (fileType == GMLFileTypeH) {
            
        }
    }
}

- (void)findClassWithContent:(NSString *)content {
    
    [self.findMethodRE enumerateMatchesInString:content options:NSMatchingReportCompletion range:NSMakeRange(0, content.length) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
        if (result) {
            NSString *subContent = [content substringWithRange:result.range];
            NSLog(@"%@", subContent);
        }
    }];
}

- (void)findPropertyWithContent:(NSString *)content {
    
//    NSArray<NSTextCheckingResult *> *result = [self.findPropertyRegularExpression matchesInString:content options:NSMatchingReportProgress range:NSMakeRange(0, content.length)];
//    [self.findPropertyRegularExpression enumerateMatchesInString:<#(nonnull NSString *)#> options:<#(NSMatchingOptions)#> range:<#(NSRange)#> usingBlock:<#^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop)block#>]
}

- (NSString *)filterNoteWithContent:(NSString *)content {
    NSMutableString *newFileContent = NSMutableString.new;
    __block NSUInteger previousLocation = 0;
    [self runRE:self.findNoteRE matchesInString:content usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
        if (result != nil) {
//            NSString *noteContent = [content substringWithRange:result.range];
            [newFileContent appendString:[content substringWithRange:NSMakeRange(previousLocation, result.range.location - previousLocation)]];
            previousLocation = result.range.location + result.range.length;
        }
    }];
    if (previousLocation != content.length) {
        [newFileContent appendString:[content substringFromIndex:previousLocation]];
    }
    return newFileContent;
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

- (NSRegularExpression *)findPropertyRE {
    if (_findPropertyRE == nil) {
        NSString *pattern = @"(@property|@synthesize|@dynamic)[^;]*;";
        _findPropertyRE = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
    }
    return _findPropertyRE;
}

- (NSRegularExpression *)findMethodRE {
    if (_findMethodRE == nil) {
        //(?<=\{).*(?=\})
        
        NSString *pattern = @"[^\n\\S]*(-|\\+)[\\s]*\\(([^\\(\\)\\{\\}]|(\\([^\\(\\)\\{\\}]*\\)))*\\)[^\\{\\};/@]+[\\s]*\\{([^\\{\\}]|(\\{[^\\{\\}]*\\}))*\\}";//@"\\n[^\\S\\\n]*(-|\\+)[\\s]*\\([^\\)\\.\\(\\n]*\\)[\\s]*\\{(?<=\\{).*(?=\\})";
        _findMethodRE = [[NSRegularExpression alloc] initWithPattern:pattern options:NSRegularExpressionDotMatchesLineSeparators error:nil];
    }
    return _findMethodRE;
}

- (NSRegularExpression *)findMethodNameRE {
    if (_findMethodNameRE == nil) {
        // 参考链接 https://m.aliyun.com/yunqi/ask/16378/
        NSString *pattern = @"[^\n\\S]*(-|\\+)[\\s]*\\(([^\\(\\)\\{\\}]|(\\([^\\(\\)\\{\\}]*\\)))*\\)[^\\{\\};/@]+";
        _findMethodNameRE = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
    }
    return _findMethodNameRE;
}

- (NSRegularExpression *)findNoteRE {
    if (_findNoteRE == nil) {
        NSString *pattern = @"(//[^\\\n]*)|(/\\*((?!\\*/).)*\\*/)";
        _findNoteRE = [[NSRegularExpression alloc] initWithPattern:pattern options:NSRegularExpressionDotMatchesLineSeparators error:nil];
    }
    return _findNoteRE;
}

- (NSRegularExpression *)findMethodBodyRE {
    if (_findMethodBodyRE == nil) {
        NSString *pattern = @"\\{([^\\{\\}]|(\\{[^\\{\\}]*\\}))*\\}";
        _findMethodBodyRE = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
    }
    return _findMethodBodyRE;
}

@end
