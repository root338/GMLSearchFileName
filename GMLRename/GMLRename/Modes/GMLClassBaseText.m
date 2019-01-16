//
//  GMLClassBaseText.m
//  GMLRename
//
//  Created by GML on 2019/1/16.
//  Copyright © 2019 apple. All rights reserved.
//

#import "GMLClassBaseText.h"
#import "GMLFileDefineTypeHeader.h"

@interface GMLClassBaseText ()
@property (nonatomic, assign, readwrite) GMLClassSection classSection;
@property (nonatomic, strong, readwrite) NSString *mClassName;
@property (nonatomic, strong, readwrite) NSTextCheckingResult *textResult;
@property (nonatomic, strong) NSMutableDictionary<NSNumber *, NSArray<NSTextCheckingResult *> *> *findResultDict;

@end

@implementation GMLClassBaseText

- (instancetype)initWithClassSection:(GMLClassSection)classSection name:(NSString *)className result:(NSTextCheckingResult *)result {
    self = [super init];
    if (self) {
        _classSection = classSection;
        _mClassName = className;
        _textResult = result;
    }
    return self;
}

- (void)addPropertyTextCheckingResults:(NSArray<NSTextCheckingResult *> *)textCheckingResults {
    self.findResultDict[@(GMLClassTextUnitProperty)] = textCheckingResults;
}

- (void)addMethodTextCheckingResults:(NSArray<NSTextCheckingResult *> *)textCheckingResults {
    self.findResultDict[@(GMLClassTextUnitMethod)] = textCheckingResults;
}

- (NSMutableDictionary<NSNumber *,NSArray<NSTextCheckingResult *> *> *)findResultDict {
    if (_findResultDict == nil) {
        _findResultDict = NSMutableDictionary.dictionary;
    }
    return _findResultDict;
}

@end
