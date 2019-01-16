//
//  GMLClassText.h
//  GMLRename
//
//  Created by apple on 2019/1/16.
//  Copyright © 2019 apple. All rights reserved.
//

#import "GMLClassBaseText.h"

NS_ASSUME_NONNULL_BEGIN
@class GMLClassExtensionText;

@interface GMLClassText : GMLClassBaseText

@property (nonatomic, strong, readonly) NSString *mSuperClassName;

- (instancetype)initWithClassSection:(GMLClassSection)classSection name:(NSString *)className result:(NSTextCheckingResult *)result UNAVAILABLE_ATTRIBUTE;

- (instancetype)initWithClassSection:(GMLClassSection)classSection name:(NSString *)className superClassName:(NSString *)superClassName result:(NSTextCheckingResult *)result;

@end

NS_ASSUME_NONNULL_END
