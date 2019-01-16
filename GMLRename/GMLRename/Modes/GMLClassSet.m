//
//  GMLClassSet.m
//  GMLRename
//
//  Created by GML on 2019/1/16.
//  Copyright © 2019 apple. All rights reserved.
//

#import "GMLClassSet.h"
#import "GMLClassText.h"
#import "GMLClassExtensionText.h"

@interface GMLClassSet ()

@property (nonatomic, strong, readwrite) NSString *mClassName;
@property (nonatomic, strong, readwrite) GMLClassText *interfaceSection;
@property (nonatomic, strong, readwrite) GMLClassText *implementationSection;
/// 类的匿名扩展(又叫类别)
@property (nonatomic, strong, readwrite) GMLClassExtensionText *interfaceCategory;

@property (nonatomic, strong) NSMutableDictionary<NSString *, GMLClassExtensionText *> *extensionInterfaceSectionDict;
@property (nonatomic, strong) NSMutableDictionary<NSString *, GMLClassExtensionText *> *extensionImplementationSectionDict;
@end

@implementation GMLClassSet

- (instancetype)initWithClassName:(NSString *)className {
    self = [super init];
    if (self) {
        _mClassName = className;
    }
    return self;
}

- (void)addClassText:(GMLClassText *)classText {
    if (![classText.mClassName isEqualToString:self.mClassName]) {
        return;
    }
    switch (classText.classSection) {
        case GMLClassSectionInterface:
            _interfaceSection = classText;
            break;
        case GMLClassSectionImplementation:
            _implementationSection = classText;
            break;
    }
}

- (void)addClassExtensionText:(GMLClassExtensionText *)extensionText {
    if (![extensionText.mClassName isEqualToString:self.mClassName]) {
        return;
    }
    switch (extensionText.classSection) {
        case GMLClassSectionInterface:
            if ([extensionText.extensionName isEqualToString:@""]) {
                self.interfaceCategory = extensionText;
            }else {
                [self.extensionInterfaceSectionDict setObject:extensionText forKey:extensionText.extensionName];
            }
            break;
        case GMLClassSectionImplementation:
            [self.extensionImplementationSectionDict setObject:extensionText forKey:extensionText.extensionName];
            break;
    }
}

- (NSMutableDictionary<NSString *,GMLClassExtensionText *> *)extensionInterfaceSectionDict {
    if (_extensionInterfaceSectionDict == nil) {
        _extensionInterfaceSectionDict = NSMutableDictionary.dictionary;
    }
    return _extensionInterfaceSectionDict;
}

- (NSMutableDictionary<NSString *,GMLClassExtensionText *> *)extensionImplementationSectionDict {
    if (_extensionImplementationSectionDict == nil) {
        _extensionImplementationSectionDict = NSMutableDictionary.dictionary;
    }
    return _extensionImplementationSectionDict;
}

@end
