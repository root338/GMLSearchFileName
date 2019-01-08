//
//  GMLClassService.m
//  YMSearchFile
//
//  Created by apple on 2019/1/8.
//  Copyright © 2019 apple. All rights reserved.
//

#import "GMLClassService.h"
#import "GMLFileProtocol.h"
#import "GMLClassProtocol.h"
#import "NSURL+GMLPathAdd.h"

@interface GMLClassService ()



@end

@implementation GMLClassService

- (void)parserClass:(id<GMLClassProtocol>)targetClass {
    
    switch (targetClass.classLanguageType) {
        case GMLClassLanguageTypeOC:
            [self handleOCClass:targetClass];
            break;
        case GMLClassLanguageTypeSwift:
            [self handleSwiftClass:targetClass];
            break;
            
        default:
            break;
    }
}

#pragma mark - OC
- (void)handleOCClass:(id<GMLClassProtocol>)targetClass {
    
    
    for (id<GMLFileProtocol> file in targetClass.fileArray) {
        NSString *content = [NSString stringWithContentsOfURL:file.pathURL encoding:NSUTF8StringEncoding error:nil];
        if (content == nil) {
            continue;
        }
        
    }
}



#pragma mark - Swift
- (void)handleSwiftClass:(id<GMLClassProtocol>)targetClass {
    
}

@end
