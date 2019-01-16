//
//  GMLFileContentService.m
//  GMLRename
//
//  Created by apple on 2019/1/16.
//  Copyright © 2019 apple. All rights reserved.
//

#import "GMLFileContentService.h"

@interface GMLFileContentService ()

@property (nonatomic, strong, readwrite) NSString *filePath;
@property (nonatomic, strong) GMLTextContent *textContent;

@end

@implementation GMLFileContentService

- (instancetype)initWithFilePath:(NSString *)filePath text:(nonnull GMLTextContent *)text {
    self = [super init];
    if (self) {
        _filePath = filePath;
        _textContent = text;
    }
    return self;
}

@end
