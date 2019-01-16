//
//  GMLFileDefineTypeHeader.h
//  GMLRename
//
//  Created by apple on 2019/1/16.
//  Copyright © 2019 apple. All rights reserved.
//

#ifndef GMLFileDefineTypeHeader_h
#define GMLFileDefineTypeHeader_h

typedef NS_ENUM(NSInteger, GMLTextUnit) {
    GMLTextUnitNote,
    GMLTextUnitImport,
    GMLTextUnitEnum,
    GMLTextUnitTypedef,
    GMLTextUnitClass,
};

typedef NS_ENUM(NSInteger, GMLClassTextUnit) {
    GMLClassTextUnitProperty,
    GMLClassTextUnitMethod,
};

#endif /* GMLFileDefineTypeHeader_h */
