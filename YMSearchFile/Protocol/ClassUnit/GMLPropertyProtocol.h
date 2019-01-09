//
//  GMLPropertyProtocol.h
//  YMSearchFile
//
//  Created by apple on 2019/1/9.
//  Copyright © 2019 apple. All rights reserved.
//

#import "GMLFileTextProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@protocol GMLPropertyProtocol <GMLFileTextProtocol>

@property (nonatomic, strong, readonly) NSStrng *propertyName;

- (void)addPropertyType:(NSString *)propertyType;


@end

NS_ASSUME_NONNULL_END
