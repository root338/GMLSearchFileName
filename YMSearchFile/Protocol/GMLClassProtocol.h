//
//  GMLClassProtocol.h
//  YMSearchFile
//
//  Created by apple on 2019/1/8.
//  Copyright © 2019 apple. All rights reserved.
//

#import "GMLFileSetProtocol.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, GMLClassLanguageType) {
    GMLClassLanguageTypeOC,
    GMLClassLanguageTypeSwift,
};

@protocol GMLClassProtocol <GMLFileSetProtocol>

@property (nonatomic, assign, readonly) GMLClassLanguageType classLanguageType;

@property (nullable, nonatomic, strong, readonly) NSArray<id<GMLClassProtocol>> *includeClassList;
@property (nullable, nonatomic, strong, readonly) NSArray<id<GMLClassProtocol>> *privateClassList;
@property (nullable, nonatomic, strong, readonly) NSArray<id<GMLClassProtocol>> *publicClassList;

@end

NS_ASSUME_NONNULL_END
