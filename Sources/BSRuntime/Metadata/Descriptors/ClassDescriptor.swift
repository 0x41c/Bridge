// ===----------------------------------------------------------------------===
//
//  ClassDescriptor.swift
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

// TODO: Complete this

public struct ClassDescriptor: AnyContextDescriptor, StructureRepresentation {
    
    public struct InternalRepresentation: InternalStructureBase {
        
        private var _base: TypeDescriptor.InternalRepresentation
        private var _superclass: RelativePointer<Int32, CChar>
        private var _negativeSizeOrResilientBounds: UInt32
        private var _positiveSizeOrExtraFlags: UInt32
        private var _numImmediateMembers: UInt32
        private var _numFields: UInt32
        private var _fieldOffsetVectorOffset: UInt32
        
    }
    
    public var `_`: UnsafeMutablePointer<InternalRepresentation>
    
    public var base: TypeDescriptor { _autoReinterpretCast(self).pointee }
    
    public var superclass: String {
        let _superclass: RelativePointer<Int32, CChar> = `_`.pointee.superclass!
        return _superclass.string
    }
    
    public var negativeSizeOrResilientBounds: UInt32 { `_`.pointee.negativeSizeOrResilientBounds! }
    public var positiveSizeOrResilientBounds: UInt32 { `_`.pointee.positiveSizeOrResilientBounds! }
    public var numImmediateMembers: UInt32 { `_`.pointee.numImmediateMembers! }
    public var numFields: UInt32 { `_`.pointee.numFields! }
    public var fieldOffsetVectorOffset: UInt32 { `_`.pointee.fieldOffsetVectorOffset! }
}

extension ClassDescriptor: Equatable {}
