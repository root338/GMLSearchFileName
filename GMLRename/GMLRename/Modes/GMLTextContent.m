//
//  GMLTextContent.m
//  GMLRename
//
//  Created by apple on 2019/1/16.
//  Copyright © 2019 apple. All rights reserved.
//

#import "GMLTextContent.h"
#import "GMLFileDefineTypeHeader.h"

@interface GMLTextContent ()
{
    NSString *_text;
    NSMutableString *_ignoreNoteText;
}

@property (nonatomic, strong) NSMutableDictionary<NSNumber *, NSArray<NSTextCheckingResult *> *> *findResultDict;

@end

@implementation GMLTextContent

- (instancetype)initWithText:(NSString *)text {
    self = [super init];
    if (self) {
        _text = text;
    }
    return self;
}

- (void)addNoteTextCheckingResults:(NSArray<NSTextCheckingResult *> *)textCheckingResults {
    self.findResultDict[@(GMLTextUnitNote)] = textCheckingResults;
    _ignoreNoteText = nil;
}

- (void)addEnumTextCheckingResults:(NSArray<NSTextCheckingResult *> *)textCheckingResults {
    self.findResultDict[@(GMLTextUnitEnum)] = textCheckingResults;
}

- (void)addImportTextCheckingResults:(NSArray<NSTextCheckingResult *> *)textCheckingResults {
    self.findResultDict[@(GMLTextUnitImport)] = textCheckingResults;
}

- (void)addClassTextCheckingResults:(NSArray<NSTextCheckingResult *> *)textCheckingResults {
    self.findResultDict[@(GMLTextUnitClass)] = textCheckingResults;
}

- (void)addTypedefTextCheckingResults:(NSArray<NSTextCheckingResult *> *)textCheckingResults {
    self.findResultDict[@(GMLTextUnitTypedef)] = textCheckingResults;
}

- (void)addClassText:(GMLClassText *)classText result:(NSTextCheckingResult *)result {
    
}

- (NSString *)ignoreNoteText {
    if (_ignoreNoteText != nil) {
        return [_ignoreNoteText copy];
    }
    
    _ignoreNoteText = NSMutableString.string;
    
    __block NSUInteger previousLocation = 0;
    NSArray<NSTextCheckingResult *> *textCheckingResults = _findResultDict[@(GMLTextUnitNote)];
    for (NSTextCheckingResult *result in textCheckingResults) {
        [_ignoreNoteText appendString:[_text substringWithRange:NSMakeRange(previousLocation, result.range.location - previousLocation)]];
        previousLocation = result.range.location + result.range.length;
    }
    if (previousLocation != _text.length) {
        [_ignoreNoteText appendString:[_text substringFromIndex:previousLocation]];
    }
    return [_ignoreNoteText copy];
}

- (NSMutableDictionary<NSNumber *,NSArray<NSTextCheckingResult *> *> *)findResultDict {
    if (_findResultDict == nil) {
        _findResultDict = NSMutableDictionary.dictionary;
    }
    return _findResultDict;
}

- (NSString *)debugDescription
{
    NSMutableString *logText = NSMutableString.string;
    NSString *ignoreNoteText = self.ignoreNoteText;
    [logText appendString:@"\n-----------------------开-----始---------------------------------"];
    void (^appendText) (NSString *, NSArray<NSTextCheckingResult *> *) = ^(NSString *text, NSArray<NSTextCheckingResult *> *results) {
        if (text == nil) {
            text = ignoreNoteText;
        }
        [logText appendString:@"\n--------------------分----割----线-------------------------------------"];
        for (NSTextCheckingResult *result in results) {
            [logText appendString:@"\n"];
            [logText appendString:[text substringWithRange:result.range]];
        }
    };
    
    [self.findResultDict enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, NSArray<NSTextCheckingResult *> * _Nonnull obj, BOOL * _Nonnull stop) {
        GMLTextUnit unit = key.integerValue;
        
        switch (unit) {
            case GMLTextUnitImport:
                appendText(nil, obj);
                break;
            case GMLTextUnitEnum:
                appendText(nil, obj);
                break;
            case GMLTextUnitTypedef:
                appendText(nil, obj);
                break;
            case GMLTextUnitClass:
                appendText(nil, obj);
                break;
            case GMLTextUnitNote:
                appendText(self.text, obj);
                break;
        }
    }];
    [logText appendString:@"\n-----------------------结-----束---------------------------------"];
    return [NSString stringWithFormat:@"<%@: %p> %@", [self class], self, logText];
}

@end
