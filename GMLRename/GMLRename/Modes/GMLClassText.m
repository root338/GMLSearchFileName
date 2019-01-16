//
//  GMLClassText.m
//  GMLRename
//
//  Created by apple on 2019/1/16.
//  Copyright © 2019 apple. All rights reserved.
//

#import "GMLClassText.h"
#import "GMLFileDefineTypeHeader.h"

@interface GMLClassText ()

@property (nonatomic, strong, readwrite) NSString *mClassName;
@property (nonatomic, strong, readwrite) NSString *mSuperClassName;

@property (nonatomic, strong, readwrite) NSString *text;

@property (nonatomic, strong) NSMutableDictionary<NSNumber *, NSArray<NSTextCheckingResult *> *> *findResultDict;

@end

@implementation GMLClassText

- (instancetype)initWithClassName:(NSString *)className superClassName:(nonnull NSString *)superClassName text:(nonnull NSString *)text {
    self = [super init];
    if (self) {
        _mClassName = className;
        _mSuperClassName = superClassName;
        _text = text;
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
