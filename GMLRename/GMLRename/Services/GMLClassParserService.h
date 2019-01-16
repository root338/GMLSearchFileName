//
//  GMLClassParserService.h
//  GMLRename
//
//  Created by apple on 2019/1/16.
//  Copyright © 2019 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class GMLClassSet;

@interface GMLClassParserService : NSObject

- (nullable GMLClassSet *)parserOCClassText:(NSString *)classText;

@end

NS_ASSUME_NONNULL_END
