//
//  GMLClassBaseText.h
//  GMLRename
//
//  Created by GML on 2019/1/16.
//  Copyright © 2019 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, GMLClassSection) {
    GMLClassSectionInterface,
    GMLClassSectionImplementation,
};

@interface GMLClassBaseText : NSObject

@property (nonatomic, assign, readonly) GMLClassSection classSection;
@property (nonatomic, strong, readonly) NSString *mClassName;
@property (nonatomic, strong, readonly) NSTextCheckingResult *textResult;

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;

- (instancetype)initWithClassSection:(GMLClassSection)classSection name:(NSString *)className result:(NSTextCheckingResult *)result;

/// 添加 property 查询结果列表
- (void)addPropertyTextCheckingResults:(NSArray<NSTextCheckingResult *> *)textCheckingResults;
/// 添加 方法 查询结果
- (void)addMethodTextCheckingResults:(NSArray<NSTextCheckingResult *> *)textCheckingResults;

@end

NS_ASSUME_NONNULL_END
