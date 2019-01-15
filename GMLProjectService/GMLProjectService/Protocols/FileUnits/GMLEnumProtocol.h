//
//  GMLEnumProtocol.h
//  GMLProjectService
//
//  Created by apple on 2019/1/15.
//  Copyright © 2019 apple. All rights reserved.
//

#import "GMLTextProtocol.h"
#import "GMLEnumDefineHeader.h"

NS_ASSUME_NONNULL_BEGIN

@protocol GMLEnumProtocol <GMLTextProtocol>

@property (nonatomic, assign) GMLEnumType enumType;
@property (nonatomic, copy) NSString *enumTypeName;
@property (nonatomic, copy) NSString *enumName;



@end

NS_ASSUME_NONNULL_END
