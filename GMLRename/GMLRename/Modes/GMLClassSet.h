//
//  GMLClassSet.h
//  GMLRename
//
//  Created by GML on 2019/1/16.
//  Copyright © 2019 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class GMLClassText, GMLClassExtensionText;

@interface GMLClassSet : NSObject

@property (nonatomic, strong, readonly) NSString *mClassName;
@property (nonatomic, strong, readonly) GMLClassText *interfaceSection;
@property (nonatomic, strong, readonly) GMLClassText *implementationSection;
/// 类的匿名扩展(又叫类别)
@property (nonatomic, strong, readonly) GMLClassExtensionText *interfaceCategory;

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;

- (instancetype)initWithClassName:(NSString *)className ;

- (void)addClassText:(GMLClassText *)classText;
- (void)addClassExtensionText:(GMLClassExtensionText *)extensionText;

@end

NS_ASSUME_NONNULL_END
