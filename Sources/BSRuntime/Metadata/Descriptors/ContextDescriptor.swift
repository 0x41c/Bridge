// ===----------------------------------------------------------------------===
//
//  ContextDescriptor.swift
//  BSRuntime
//
//  Created by 0x41c on 2022-03-13.
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

import ptrauth

public struct ContextDescriptor: StructureRepresentation {
    
    public struct InternalRepresentation: InternalStructureBase {
        private var _flags: UInt32
        private var _parent: RelativePointer<Int32, InternalRepresentation>
    }
    
    public var `_`: UnsafeMutablePointer<InternalRepresentation>
    public var flags: Flags { Flags(rawValue: `_`.pointee.flags!) }
    
    public var parent: ContextDescriptor? {
        let _parent: RelativePointer<Int32, InternalRepresentation> = `_`.pointee.parent!
        if _parent.isNull {
            return nil
        }
        
        return getContextDescriptor(from: _parent.indirectOffset.raw)
        
    }
}

public extension ContextDescriptor {
    
    struct Flags: OptionSet {
        
        public var rawValue: UInt32
        
        static let unique = Flags(rawValue: 1 << 6)
        static let generic = Flags(rawValue: 1 << 7)
        
        public var kind: Kind {
            Kind(rawValue: Int(rawValue) & 0x1F)!
        }
        
        public var version: UInt8 {
            UInt8((rawValue >> 0x8) & 0xFF)
        }
        
        var kindSpecificFlags: UInt16 {
            UInt16((rawValue >> 0x10) & 0xFFFF)
        }
        
        public init(rawValue: UInt32) {
            self.rawValue = rawValue
        }
        
    }
}

public extension ContextDescriptor {
    
    enum Kind: Int {
        
        case module = 0
        case `extension` = 1
        case anonymous = 2
        case `protocol` = 3
        case opaqueType = 4
        case `class` = 16
        case `struct` = 17
        case `enum` = 18
        
    }
    
}

public extension ContextDescriptor: Equatable {}


func getContextDescriptor(
    from pointer: UnsafeRawPointer
) -> ContextDescriptor {
    let pointer = PointerAuthentication.strip(pointer, ptrauth_key_asda)
    let flags = pointer.load(as: ContextDescriptor.Flags.self)
    
    switch flags.kind { // TODO: Implement the rest.
    case .class:
        return ClassDescriptor(withPointer: pointer)
    default:
        fatalError("Unimplemented descriptor type")
    }
}

