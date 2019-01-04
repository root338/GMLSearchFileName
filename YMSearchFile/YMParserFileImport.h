//
//  YMParserFileImport.h
//  YMSearchFile
//
//  Created by apple on 2019/1/4.
//  Copyright © 2019 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YMParserFileImport : NSObject

- (void)parserImportWithFilePath:(NSString *)filePath result:(void (^) (NSSet<NSString *> *importFileNames))result;

@end

NS_ASSUME_NONNULL_END
