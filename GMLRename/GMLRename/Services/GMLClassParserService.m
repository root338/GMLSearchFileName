//
//  GMLClassParserService.m
//  GMLRename
//
//  Created by apple on 2019/1/16.
//  Copyright © 2019 apple. All rights reserved.
//

#import "GMLClassParserService.h"
#import "GMLClassSet.h"

@interface GMLClassParserService ()

@property (nonatomic, strong) NSRegularExpression *findClassInterfaceRE;
@property (nonatomic, strong) NSRegularExpression *findClassInterfaceCategoryRE;
@property (nonatomic, strong) NSRegularExpression *findClassImplementationRE;
@property (nonatomic, strong) NSRegularExpression *findClassImplementationCategoryRE;

/// 查找属性
@property (nonatomic, strong) NSRegularExpression *findPropertyRE;
/// 查找方法
@property (nonatomic, strong) NSRegularExpression *findMethodRE;
/// 查找方法名
@property (nonatomic, strong) NSRegularExpression *findMethodNameRE;
/// 查找方法体
@property (nonatomic, strong) NSRegularExpression *findMethodBodyRE;

@end

@implementation GMLClassParserService

- (GMLClassSet *)parserOCClassText:(NSString *)classText {
    
}

- (NSRegularExpression *)findClassInterfaceRE {
    if (_findClassInterfaceRE == nil) {
        NSString *pattern = @"@interface[\\s]+[\\w]+[\\s]*:[\\w]+";
        _findClassInterfaceRE = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
    }
    return _findClassInterfaceRE;
}

- (NSRegularExpression *)findClassInterfaceCategoryRE {
    if (_findClassInterfaceCategoryRE) {
        NSString *pattern = @"@interface[\\s]+[\\w]+[\\s]*(\\([\\w]*\\))";
        _findClassInterfaceCategoryRE = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
    }
    return _findClassInterfaceCategoryRE;
}

- (NSRegularExpression *)findClassImplementationRE {
    if (_findClassImplementationRE == nil) {
        NSString *pattern = @"@implementation[\\s]+[\\w]+";
        _findClassImplementationRE = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
    }
    return _findClassImplementationRE;
}

- (NSRegularExpression *)findClassImplementationCategoryRE {
    if (_findClassImplementationCategoryRE == nil) {
        NSString *pattern = @"@implementation[\\s]+[\\w]+[\\s]*(\\([\\w]*\\)";
        _findClassImplementationCategoryRE = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
    }
    return _findClassImplementationCategoryRE;
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

- (NSRegularExpression *)findMethodBodyRE {
    if (_findMethodBodyRE == nil) {
        NSString *pattern = @"\\{([^\\{\\}]|(\\{[^\\{\\}]*\\}))*\\}";
        _findMethodBodyRE = [[NSRegularExpression alloc] initWithPattern:pattern options:0 error:nil];
    }
    return _findMethodBodyRE;
}

@end
