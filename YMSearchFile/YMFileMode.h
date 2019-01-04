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

@property (nonatomic, copy) NSString *fileName;

@property (nonatomic, copy) NSString *mFilePath;
@property (nonatomic, copy) NSString *hFilePath;
@property (nonatomic, copy) NSString *xibFilePath;
@property (nonatomic, copy) NSString *swiftFilePath;
@property (nonatomic, copy) NSString *otherFilePath;

/// 被引用文件名
@property (nonatomic, strong) NSMutableSet *citedFileNameSets;
/// 引用文件名
@property (nonatomic, strong) NSMutableSet *includeFileNameSets;

@end

NS_ASSUME_NONNULL_END
