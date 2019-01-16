//
//  GMLFileParserService.m
//  GMLRename
//
//  Created by apple on 2019/1/15.
//  Copyright © 2019 apple. All rights reserved.
//

#import "GMLFileParserService.h"
#import "NSString+GMLPathTools.h"
#import "GMLFileContentService.h"
#import "GMLTextContent.h"

@interface GMLFileParserService ()

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

@implementation GMLFileParserService

- (GMLFileContentService *)parserFilePath:(NSString *)filePath {
    GMLFileType fileType = filePath.fileType;
    
    GMLFileContentService *fileContentService = nil;
    switch (fileType) {
        case GMLFileTypeH:
        case GMLFileTypeM:
        case GMLFileTypeMM:
        case GMLFileTypeSwift: {
            
            GMLTextContent *textContent = [self textContentWithFilePath:filePath];
            
            if (fileType == GMLFileTypeSwift) {
                
            }else {
                [self parserOCFile:textContent];
            }
            NSLog(@"%@", [textContent debugDescription]);
            fileContentService = [[GMLFileContentService alloc] initWithFilePath:filePath text:textContent];
        }
            break;
        default:
            
            break;
    }
    
    return fileContentService;
}

#pragma mark - OC
- (void)parserOCFile:(GMLTextContent *)textContent {
    
    NSString *text = textContent.ignoreNoteText;
    [textContent addImportTextCheckingResults:[self runRE:self.findImportFileRE matchesInString:text]];
    NSArray<NSTextCheckingResult *> *classResults = [self runRE:self.findClassRE matchesInString:text];
    [textContent addClassTextCheckingResults:classResults];
    for (NSTextCheckingResult *result in classResults) {
        NSString *classText = [text substringWithRange:result.range];
        
//        [textContent addPropertyTextCheckingResults:[self runRE:self.findPropertyRE matchesInString:classText] inClassResult:result];
//        [textContent addMethodTextCheckingResults:[self runRE:self.findMethodRE matchesInString:classText] inClassResult:result];
    }
}

#pragma mark - Swift
- (void)parserSwiftFileContent:(NSString *)filePath {
    
}

- (void)runRE:(NSRegularExpression *)targetRE matchesInString:(NSString *)string usingBlock:(void (^) (NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop))block {
    [targetRE enumerateMatchesInString:string options:NSMatchingReportProgress range:string.rangeOfAll usingBlock:block];
}

- (NSArray<NSTextCheckingResult *> *)runRE:(NSRegularExpression *)targetRE matchesInString:(NSString *)string {
    return [targetRE matchesInString:string options:NSMatchingReportCompletion range:string.rangeOfAll];
}

- (GMLTextContent *)textContentWithFilePath:(NSString *)filePath {
    NSString *text = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    GMLTextContent *textContent = [[GMLTextContent alloc] initWithText:text];
    NSArray<NSTextCheckingResult *> *noteResultList = [self runRE:self.findNoteRE matchesInString:text];
    noteResultList.count == 0?: [textContent addNoteTextCheckingResults:noteResultList];
    return textContent;
}

#pragma mark - Getter & Setter

- (NSRegularExpression *)findImportFileRE {
    if (_findImportFileRE == nil) {
        NSString *pattern = @"#import[ ]*\\\"[^\\\"\\\n#]*[ ]*\\\"";
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
