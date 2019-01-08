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
    GMLPathTypeNotFound = -1,
    GMLPathTypeFolder = 1,
    GMLPathTypeFile = 2,
};

typedef NS_ENUM(NSInteger, GMLFolderType) {
    GMLFolderTypeNotFound = -3,
    GMLFolderTypeNotDirectory = -2,
    
    GMLFolderTypeNormal = 1,
    GMLFolderTypeFramework,
    GMLFolderTypeBundle,
    
    GMLFolderTypeUnknown,
};

typedef NS_ENUM(NSInteger, GMLFileType) {
    GMLFileTypeNotFound = -3,
    GMLFileTypeNotFile = -2,
    
// 类相关文件
    GMLFileTypeH = 1,
    GMLFileTypeM,
    GMLFileTypeSwift,
    GMLFileTypePCH,
    GMLFileTypeMM,
    GMLFileTypeXib,
    GMLFileTypeStoryboard,
    
// 静态库
    GMLFileTypeA,
    
// 图片
    GMLFileTypeJPG,
    GMLFileTypePNG,
    GMLFileTypeGIF,
    
    GMLFileTypeUnknown,
};

#endif /* GMLPathDefineTypeHeader_h */
