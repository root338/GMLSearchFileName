//
//  GMLClassService.m
//  YMSearchFile
//
//  Created by apple on 2019/1/8.
//  Copyright © 2019 apple. All rights reserved.
//

#import "GMLClassService.h"
#import "GMLFileProtocol.h"
#import "GMLClassProtocol.h"
#import "NSURL+GMLPathAdd.h"

@interface GMLClassService ()
/// 查找注释
@property (nonatomic, strong) NSRegularExpression *findNoteRE;
/// 查找类
@property (nonatomic, strong) NSRegularExpression *findClassRE;
/// 查找属性
@property (nonatomic, strong) NSRegularExpression *findPropertyRE;
/// 查找方法
@property (nonatomic, strong) NSRegularExpression *findMethodRE;

@end

@implementation GMLClassService
- (void)parserClass:(id<GMLClassProtocol>)targetClass {
    
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
- (void)handleOCClass:(id<GMLClassProtocol>)targetClass {
    for (id<GMLFileProtocol> file in targetClass.fileArray) {
        NSString *content = [NSString stringWithContentsOfURL:file.pathURL encoding:NSUTF8StringEncoding error:nil];
        if (content == nil) {
            continue;
        }
        [self findClassWithContent:content];
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

#pragma mark - Swift
- (void)handleSwiftClass:(id<GMLClassProtocol>)targetClass {
    
}

#pragma mark - Getter & Setter

- (NSRegularExpression *)findClassRE {
    if (_findClassRE == nil) {
        NSString *pattern = @"(@interface|@implementation)((?!@end).)*@end";
        _findClassRE = [[NSRegularExpression alloc] initWithPattern:pattern options:NSRegularExpressionDotMatchesLineSeparators error:nil];
    }
    return _findClassRE;
}
- (NSRegularExpression *)findPropertyRE {
    if (_findPropertyRE == nil) {
        NSString *pattern = @"(@property|@synthesize|@dynamic)[^;\\\n]*;";
        _findPropertyRE = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
    }
    return _findPropertyRE;
}

- (NSRegularExpression *)findMethodRE {
    if (_findMethodRE == nil) {
        //(?<=\{).*(?=\})
        NSString *pattern = @"\\n[^\\S\\\n]*(-|\\+)[\\s]*\\([^\\)\\.\\(\\n]*\\)[\\s]*\\{(?<=\\{).*(?=\\})";
        _findMethodRE = [[NSRegularExpression alloc] initWithPattern:pattern options:NSRegularExpressionDotMatchesLineSeparators error:nil];
    }
    return _findMethodRE;
}

- (NSRegularExpression *)findNoteRE {
    if (_findNoteRE == nil) {
        NSString *pattern = @"(//[^\\\n]*)|(/\\*((?!\\*/).)*\\*/)";
        _findNoteRE = [[NSRegularExpression alloc] initWithPattern:pattern options:NSRegularExpressionDotMatchesLineSeparators error:nil];
    }
    return _findNoteRE;
}

@end
