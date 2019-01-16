//
//  GMLFileParserService.h
//  GMLRename
//
//  Created by apple on 2019/1/15.
//  Copyright © 2019 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class GMLFileParserService, GMLFileContentService;

@protocol GMLFileParserServiceDelegate <NSObject>

@required
- (void)service:(GMLFileParserService *)service filePath:(NSString *)filePath parserResult:(GMLFileContentService *)result;
- (void)service:(GMLFileParserService *)service filePath:(NSString *)filePath error:(NSError *)error;

@optional


@end

@interface GMLFileParserService : NSObject

@property (nonatomic, weak) id<GMLFileParserServiceDelegate> delegate;

- (nullable GMLFileContentService *)parserFilePath:(NSString *)filePath;

@end

NS_ASSUME_NONNULL_END
