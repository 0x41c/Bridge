// ===----------------------------------------------------------------------===
//
//  TypeMetadata.swift
//  BSRuntime
//
//  Created by 0x41c on 2022-03-09.
//
// ===----------------------------------------------------------------------===
//
//  Copyright 2022 0x41c
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
// ===----------------------------------------------------------------------===


public protocol TypeMetadata: AnyMetadata {}


public extension TypeMetadata {
    
    var nominalTypeDescriptor: TypeDescriptor {
        switch self {
        case let classMetadata as ClassMetadata:
            return classMetadata.nominalTypeDescriptor.base
        case let structMetadata as StructMetadata:
            return structMetadata.nominalTypeDescriptor.base
        case let enumMetadata as EnumMetadata:
            return enumMetadata.nominalTypeDescriptor.base
        default:
            fatalError("Couldn't get nominalTypeDescriptor from unknown metadata")
        }
        
    }
    
    var genericTypeArray: [Any.Type] {
        if !nominalTypeDescriptor.flags.contains(.generic) {
            return []
        }
        
        // TODO: Finish this
        
        return []
    }
    
}


public enum TypeMetadataKind: Int {
    
    case `struct`                   = 0x200
    case `enum`                     = 0x201
    case `optional`                 = 0x202
    case foreignClass               = 0x203
    case opaque                     = 0x300
    case tuple                      = 0x301
    case function                   = 0x302
    case existential                = 0x303
    case metatype                   = 0x304
    case objcClassWrapper           = 0x305
    case existentialMetatype        = 0x306
    case heapLocalVariable          = 0x400
    case genericHeapLocalVariable   = 0x500
    case error                      = 0x501
    case `class`
    
    public init(raw: Int) {
        self = TypeMetadataKind(rawValue: raw) ?? .class
    }
    
}
