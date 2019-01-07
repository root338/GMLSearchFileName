//
//  GMLProjectParser.h
//  YMSearchFile
//
//  Created by GML on 2019/1/6.
//  Copyright © 2019 apple. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GMLPathDefineTypeHeader.h"

NS_ASSUME_NONNULL_BEGIN
@class GMLProjectParser, YMProjectMode;
@protocol GMLFileProtocol;

typedef NS_ENUM(NSInteger, GMLParserOption) {
    GMLParserOptionStop = -1,
    GMLParserOptionResume = 0,
    GMLParserOptionPause = 1,
};

@protocol GMLProjectParserDelegate <NSObject>

@required
- (void)parser:(GMLProjectParser *)service projectMode:(YMProjectMode *)projectMode;
- (void)parser:(GMLProjectParser *)service file:(id<GMLFileProtocol>)file;

@optional
/// 是否解析指定文件夹
- (BOOL)parser:(GMLProjectParser *)service shouldParserFolderURL:(NSURL *)folderURL;

@end

@interface GMLProjectParser : NSObject

@property (nonatomic, weak) id<GMLProjectParserDelegate> delegate;
/// 解析 cocoaPods 文件夹, 默认为 NO
@property (nonatomic, assign) BOOL parserCocoaPodsFolder;
/// 解析隐藏文件, 默认为 NO
@property (nonatomic, assign) BOOL parserHiddenPath;
/// 解析以Tests结尾的文件夹 (一般以Tests结尾的文件夹为测试类), 默认为 NO
@property (nonatomic, assign) BOOL parserSuffixIsTestsFolder;
/// 解析 .xcodeproj 扩展名的文件夹 (xcode 工程入口，包含配置，文件索引信息), 默认为 NO
@property (nonatomic, assign) BOOL parserXcodeprojFolder;

//@property (nonatomic, assign, readonly) GMLFolderType folderType;
//@property (nonatomic, strong, readonly) NSString *folderPath;

//@property (nonatomic, readonly) NSArray<NSString *> *filePathArrays;
//@property (nonatomic, readonly) NSArray<GMLProjectParser *> *folderModes;
/// 暂时无用
@property (nonatomic, assign) GMLParserOption parserOption;

@property (nullable, nonatomic, copy) BOOL (^handleParserError)(NSURL * _Nonnull url, NSError * _Nonnull error);

//- (BOOL)containsPath:(NSString *)path;
//- (BOOL)addFolderMode:(GMLProjectParser *)folderMode;
//- (nullable NSString *)addFilePath:(NSString *)filePath;
//- (BOOL)addPath:(NSString *)path;

//- (instancetype)init UNAVAILABLE_ATTRIBUTE;
//+ (instancetype)new UNAVAILABLE_ATTRIBUTE;

//- (nullable instancetype)initWithFolderPath:(NSString *)folderPath;

//- (void)enumerateFilesUsingBlock:(void (NS_NOESCAPE ^)(NSString *filePath, NSString *folderPath, BOOL *stop))block;
//- (void)enumerateFoldersUsingBlock:(void (NS_NOESCAPE ^)(NSString *folderPath, NSArray<NSString *> *filePaths, BOOL *stop))block;

- (BOOL)parserWithProjectPath:(NSURL *)projectPath;

@end

NS_ASSUME_NONNULL_END
