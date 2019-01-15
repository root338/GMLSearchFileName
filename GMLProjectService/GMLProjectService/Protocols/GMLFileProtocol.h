//
//  GMLFileProtocol.h
//  GMLProjectService
//
//  Created by apple on 2019/1/15.
//  Copyright © 2019 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@protocol GMLClassProtocol, GMLEnumProtocol;

@protocol GMLFileProtocol <NSObject>

@property (nonatomic, strong, readonly) NSURL *pathURL;

- (void)addClass:(id<GMLClassProtocol>)classValue;
- (void)addEnum:(id<GMLEnumProtocol>)enumValue;
- (void)add

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;
- (nullable instancetype)initWithPathURL:(NSURL *)pathURL;
@end

NS_ASSUME_NONNULL_END
