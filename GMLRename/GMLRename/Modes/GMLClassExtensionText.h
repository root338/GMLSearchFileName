//
//  GMLClassExtensionText.h
//  GMLRename
//
//  Created by GML on 2019/1/16.
//  Copyright © 2019 apple. All rights reserved.
//

#import "GMLClassBaseText.h"

NS_ASSUME_NONNULL_BEGIN

@interface GMLClassExtensionText : GMLClassBaseText

@property (nonatomic, strong, readonly) NSString *extensionName;

- (instancetype)initWithClassSection:(GMLClassSection)classSection name:(NSString *)className result:(NSTextCheckingResult *)result UNAVAILABLE_ATTRIBUTE;
- (instancetype)initWithClassSection:(GMLClassSection)classSection name:(NSString *)className categoryName:(NSString *)categoryName result:(NSTextCheckingResult *)result;

@end

NS_ASSUME_NONNULL_END
