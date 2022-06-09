// ===----------------------------------------------------------------------===
//
//  EnumDescriptor.swift
//  BSRuntime
//
//  Created by 0x41c on 2022-06-08.
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



public struct EnumDescriptor: AnyContextDescriptor, StructureRepresentation {
    
    public struct InternalRepresentation: InternalStructureBase {

        private var _base: TypeDescriptor
        private var _numPayloadCasesAndPayloadSizeOffset: UInt32
        private var _numEmptyCases: UInt32

    }
    
    public var `_`: UnsafeMutablePointer<InternalRepresentation>
    public var base: TypeDescriptor { _autoReinterpretCast(self).pointee }
    public var numPayloadCasesAndPayloadSizeOffset: UInt32 { `_`.pointee.numPayloadCasesAndPayloadSizeOffset! }
    public var numEmptyCases: UInt32 { `_`.pointee.numEmptyCases! }
    
    public var numPayloadCases: Int {
        Int(numPayloadCasesAndPayloadSizeOffset) & 0xFFFFFF
    }
    
    public var payloadSizeOffset: Int {
        Int((numPayloadCasesAndPayloadSizeOffset & 0xFF000000) >> 24)
    }
    
    public var numCases: Int {
       Int(numEmptyCases) + numPayloadCases
    }
    
    // TODO: Foreign Metadata / Singleton Metadata initialization

}

extension EnumDescriptor: Equatable {}
