//
//  GMLPathDefineTypeHeader.h
//  YMSearchFile
//
//  Created by GML on 2019/1/6.
//  Copyright © 2019 apple. All rights reserved.
//

#ifndef GMLPathDefineTypeHeader_h
#define GMLPathDefineTypeHeader_h

typedef NS_ENUM(NSInteger, GMLPathType) {
    GMLPathTypeNotFound,
    GMLPathTypeFolder = 1,
    GMLPathTypeFile = 2,
};

typedef NS_ENUM(NSInteger, GMLFolderType) {
    GMLFolderTypeNotFound = -3,
    GMLFolderTypeNotDirectory = -2,
    GMLFolderTypeUnknown = -1,
    GMLFolderTypeNormal,
    GMLFolderTypeFramework,
    GMLFolderTypeBundle,
};

#endif /* GMLPathDefineTypeHeader_h */
