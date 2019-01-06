//
//  YMFileMode.h
//  YMSearchFile
//
//  Created by apple on 2019/1/4.
//  Copyright © 2019 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YMFileMode : NSObject

@property (nonatomic, copy, readonly) NSString *fileName;

@property (nullable, nonatomic, copy, readonly) NSString *hFilePath;
@property (nullable, nonatomic, copy, readonly) NSString *mFilePath;
@property (nullable, nonatomic, copy, readonly) NSString *xibFilePath;
@property (nullable, nonatomic, copy, readonly) NSString *swiftFilePath;

@property (nonatomic, strong, readonly) NSSet<NSString *> *allRelationPathSet;

/// 被引用文件名
@property (nonatomic, strong) NSHashTable<YMFileMode *> *citedFileNameTable;
/// 引用文件名
@property (nonatomic, strong) NSHashTable<YMFileMode *> *includeFileNameTable;

- (nullable NSSet<NSString *> *)filePathsWithTypes:(NSArray<NSString *> *)types;
- (void)addFileRelationPath:(NSString *)path;
- (void)removePath:(NSString *)path;

- (BOOL)containsPath:(NSString *)path;
- (BOOL)containsPathExtension:(NSString *)pathExtension;

- (instancetype)initWithFileName:(NSString *)fileName;
+ (instancetype)createWithFilePath:(NSString *)filePath;
@end

NS_ASSUME_NONNULL_END
