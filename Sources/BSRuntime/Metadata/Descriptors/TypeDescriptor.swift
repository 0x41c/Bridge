// ===----------------------------------------------------------------------===
//
//  TypeDescriptor.swift
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

public struct TypeDescriptor: AnyContextDescriptor, StructureRepresentation {
    
    public struct InternalRepresentation: InternalStructureBase {
        private var _base: ContextDescriptor.InternalRepresentation
        private var _name: RelativePointer<Int32, CChar>
        private var _accessor: RelativePointer<Int32, UnsafeRawPointer>
        private var _fields: RelativePointer<Int32, UnsafeRawPointer> // FieldDescriptor
    }
    
    public var `_`: UnsafeMutablePointer<InternalRepresentation>
    public var base: ContextDescriptor { _autoReinterpretCast(self).pointee }
    
    public var name: String {
        let _name: RelativePointer<Int32, CChar> = `_`.pointee.name!
        return _name.string
    }
    
    public var isReflectable: Bool {
        let _fields: RelativePointer<Int32, UnsafeRawPointer> = `_`.pointee.fields!
        return !_fields.isNull
    }
    
    public var typeFlags: Flags {
        Flags(rawValue: UInt64(base.flags.kindSpecificFlags))
    }
    
}

public extension TypeDescriptor {
    
    struct Flags: OptionSet {
        
        public var rawValue: UInt64
        
        static var hasImportInfo = Flags(rawValue: 1 << 4)
        static var classHasNegativeImmediateMembers = Flags(rawValue: 1 << 0x1000)
        static var classHasResilientSuperclass = Flags(rawValue: 1 << 0x2000)
        static var classHasOverrideTable = Flags(rawValue: 1 << 0x4000)
        static var classHasVWT = Flags(rawValue: 1 << 0x8000)
        
        public var resilientSuperclassRefKind: TypeReferenceKind {
            TypeReferenceKind(rawValue: UInt16(rawValue) & 0xE00)!
        }
        
        public init(rawValue: UInt64) {
            self.rawValue = rawValue
        }
        
    }
    
    enum TypeReferenceKind: UInt16 {
        case directTypeDescriptor = 0x0
        case indirectTypeDescriptor = 0x1
        case directObjcClass = 0x2
        case indirectObjcClass = 0x3
    }
    
}

extension TypeDescriptor: Equatable {}
