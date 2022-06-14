// ===----------------------------------------------------------------------===
//
//  TupleElementMetadata.swift
//  BSRuntime
//
//  Created by 0x41c on 2022-06-13.
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



public struct TupleElementMetadata: StructureRepresentation {
    
    public struct InternalRepresentation: InternalStructureBase {
        
        private var _type: Any.Type
        #if canImport(Darwin)
        private var _offset: Int
        #else
        private var _offset: UInt32
        private var _padding: UInt32
        #endif
        
    }
    
    public var `_`: UnsafeMutablePointer<InternalRepresentation>
    public var type: Any.Type { `_`.pointee.type! }
    public var offset: Int {
        #if canImport(Darwin)
        return `_`.pointee.offset!
        #else
        let uint: UInt32 = `_`.pointee.offset!
        return Int(uint)
        #endif
    }
    
}
