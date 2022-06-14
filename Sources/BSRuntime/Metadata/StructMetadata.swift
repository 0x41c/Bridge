// ===----------------------------------------------------------------------===
//
//  StructMetadata.swift
//  BSRuntime
//
//  Created by 0x41c on 2022-02-27.
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

public struct StructMetadata: TypeMetadata {

    public struct MetadataStructure: InternalStructureBase {

        private var _kind: Int
        private var _nominalTypeDescriptor: SignedPointer<ContextDescriptor>

    }

    public var `_`: UnsafeMutablePointer<MetadataStructure>
    public var nominalTypeDescriptor: SignedPointer<ContextDescriptor> { `_`.pointee.nominalTypeDescriptor! }

}

extension StructMetadata: Equatable {}
