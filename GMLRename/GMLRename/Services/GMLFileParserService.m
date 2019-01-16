//
//  GMLFileParserService.m
//  GMLRename
//
//  Created by apple on 2019/1/15.
//  Copyright © 2019 apple. All rights reserved.
//

#import "GMLFileParserService.h"
#import "GMLTextContent.h"
#import "GMLFileContentService.h"
#import "GMLClassParserService.h"

#import "NSString+RE.h"
#import "NSString+GMLPathTools.h"

@interface GMLFileParserService ()

/// 查找注释
@property (nonatomic, strong) NSRegularExpression *findNoteRE;
/// 查找导入的文件
@property (nonatomic, strong) NSRegularExpression *findImportFileRE;
/// 查找类
@property (nonatomic, strong) NSRegularExpression *findClassRE;

@property (nonatomic, strong) GMLClassParserService *classParserService;

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
    [textContent addImportTextCheckingResults:[text runRE:self.findImportFileRE]];
    NSArray<NSTextCheckingResult *> *classResults = [text runRE:self.findClassRE];
    [textContent addClassTextCheckingResults:classResults];
    for (NSTextCheckingResult *result in classResults) {
        NSString *classText = [text substringWithRange:result.range];
        GMLClassSet *classSet = [self.classParserService parserOCClassText:classText];
        
    }
}

#pragma mark - Swift
- (void)parserSwiftFileContent:(NSString *)filePath {
    
}



- (GMLTextContent *)textContentWithFilePath:(NSString *)filePath {
    NSString *text = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    GMLTextContent *textContent = [[GMLTextContent alloc] initWithText:text];
    NSArray<NSTextCheckingResult *> *noteResultList = [text runRE:self.findNoteRE];
    noteResultList.count == 0?: [textContent addNoteTextCheckingResults:noteResultList];
    return textContent;
}

#pragma mark - Getter & Setter
- (NSRegularExpression *)findNoteRE {
    if (_findNoteRE == nil) {
        NSString *pattern = @"(//[^\\\n]*)|(/\\*((?!\\*/).)*\\*/)";
        _findNoteRE = [[NSRegularExpression alloc] initWithPattern:pattern options:NSRegularExpressionDotMatchesLineSeparators error:nil];
    }
    return _findNoteRE;
}

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

- (GMLClassParserService *)classParserService {
    if (_classParserService == nil) {
        _classParserService = GMLClassParserService.new;
    }
    return _classParserService;
}

@end
