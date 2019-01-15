//
//  GMLClassProtocol.h
//  GMLProjectService
//
//  Created by apple on 2019/1/15.
//  Copyright © 2019 apple. All rights reserved.
//

#import "GMLTextProtocol.h"
#import "GMLClassDefineHeader.h"

NS_ASSUME_NONNULL_BEGIN

@protocol GMLFileProtocol, GMLMethodProtocol, GMLPropertyProtocol;

@protocol GMLClassProtocol <GMLTextProtocol>

@property (nonatomic, strong, readonly) NSString *mClassName;
@property (nonatomic, strong, readonly) NSArray<id<GMLFileProtocol>> *yourselfFileList;

- (void)addMethod:(id<GMLMethodProtocol>)method unit:(GMLClassUnit)unit;
- (void)addProperty:(id<GMLPropertyProtocol>)property unit:(GMLClassUnit)unit;

@end

NS_ASSUME_NONNULL_END
