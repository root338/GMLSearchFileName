//
//  GMLProtocolProtocol.h
//  YMSearchFile
//
//  Created by apple on 2019/1/9.
//  Copyright © 2019 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol GMLPropertyProtocol, GMLMethodProtocol;

@protocol GMLProtocolProtocol <NSObject>

@property (nonatomic, strong, readonly) NSStrng *protocolName;

@property (nullable, nonatomic, strong, readonly) NSArray<id<GMLPropertyProtocol>> *propertyList;

@property (nullable, nonatomic, strong, readonly) NSArray<id<GMLMethodProtocol>> *methodList;

- (void)addProperty:(id<GMLPropertyProtocol>)property;
- (void)addMethod:(id<GMLMethodProtocol>)method;

@end

NS_ASSUME_NONNULL_END
