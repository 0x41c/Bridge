// ===----------------------------------------------------------------------===
//
//  ExtensionDescriptor.swift
//  BSRuntime
//
//  Created by 0x41c on 2022-06-09.
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



public struct ExtensionDescriptor: AnyContextDescriptor, StructureRepresentation {
    
    public struct InternalRepresentation: InternalStructureBase {
        
        private var _base: ContextDescriptor.InternalRepresentation
        private var _extendedContext: RelativePointer<Int32, CChar>
        
    }
    
    public var `_`: UnsafeMutablePointer<InternalRepresentation>
    public var base: ContextDescriptor { _autoReinterpretCast(self).pointee }
    public var extendedContext: UnsafeRawPointer {
        let _extendedContext: RelativePointer<Int32, CChar> = `_`.pointee.extendedContext!
        return _extendedContext.indirectOffset.raw
    }
    
}

extension ExtensionDescriptor: Equatable {}
