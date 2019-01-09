//
//  GMLClassProtocol.h
//  YMSearchFile
//
//  Created by apple on 2019/1/9.
//  Copyright © 2019 apple. All rights reserved.
//

#import "GMLFileTextProtocol.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, GMLClassBlockType) {
    GMLClassBlockTypeInterface,
    GMLClassBlockTypeImplementation,
};

@protocol GMLPropertyProtocol, GMLMethodProtocol, GMLProtocolProtocol;

@protocol GMLBaseClassProtocol <GMLFileTextProtocol>
@property (nonatomic, strong, readonly) NSURL *interfaceFileURL;
@property (nonatomic, strong, readonly) NSURL *implementationFileURL;

@property (nullable, nonatomic, strong, readonly) NSArray<id<GMLPropertyProtocol>> *publicPropertyList;
@property (nullable, nonatomic, strong, readonly) NSArray<id<GMLPropertyProtocol>> *privatePropertyList;
@property (nullable, nonatomic, strong, readonly) NSArray<id<GMLMethodProtocol>> *publicMethodList;
@property (nullable, nonatomic, strong, readonly) NSArray<id<GMLMethodProtocol>> *privateMethodList;

@property (nullable, nonatomic, strong, readonly) NSArray<id<GMLMethodProtocol>> *publicProtocolList;
@property (nullable, nonatomic, strong, readonly) NSArray<id<GMLProtocolProtocol>> *privateProtocolList;

- (void)addInterfaceProperty:(id<GMLPropertyProtocol>)property;
- (void)addImplementationProperty:(id<GMLPropertyProtocol>)property;

- (void)addMethod:(id<GMLMethodProtocol>)method isExistInterface:(BOOL)isExistInterface;
- (void)addProtocol:(id<GMLProtocolProtocol>)protocol isExistInterface:(BOOL)isExistInterface;

@end

@protocol GMLClassCategoryProtocol <GMLBaseClassProtocol>

@property (nullable, nonatomic, strong, readonly) NSString *classCategoryName;


@end

@protocol GMLClassProtocol <GMLBaseClassProtocol>

@property (nonatomic, strong, readonly) NSString *className;

@property (nullable, nonatomic, strong, readonly) id<GMLClassProtocol> superClassProtocol;

@property (nullable, nonatomic, strong, readonly) id<GMLClassCategoryProtocol> incognitoCategory;

- (nullable instancetype)initWithClassName:(NSString *)className;

@end

NS_ASSUME_NONNULL_END
