//
//  GMLStack.h
//  GMLRename
//
//  Created by apple on 2019/1/15.
//  Copyright © 2019 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GMLStack<__covariant ObjectType> : NSObject

@property (nullable, nonatomic, strong) ObjectType stackTopObj;

- (nullable ObjectType)push:(ObjectType)obj;
- (nullable ObjectType)pop;

@end

NS_ASSUME_NONNULL_END
