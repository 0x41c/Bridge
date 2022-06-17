// ===----------------------------------------------------------------------===
//
//  AnyMetadata.swift
//  BSRuntime
//
//  Created by 0x41c on 2022-06-15.
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



public protocol AnyMetadata: StructureRepresentation {
    associatedtype MetadataStructure = InternalRepresentation
}

public extension AnyMetadata {
    
    ///
    /// The type that the metadata represents.
    ///
    var type: Any.Type {
        unsafeBitCast(`_`, to: Any.Type.self)
    }
    
    ///
    /// The types VWT located right before the base of the type structure.
    ///
    var valueWitnessTable: ValueWitnessTable {
        `_`.raw.offset(by: -1).assumingMemoryBound(to: ValueWitnessTable.self).pointee
    }
    
    ///
    /// The kind of the metadata
    ///
    var kind: TypeMetadataKind {
        TypeMetadataKind(raw: _autoReinterpretCast(`_`).pointee)
    }
    
    ///
    /// Initializes the representation of the metadata with the type it's
    /// representing.
    ///
    /// - Parameters:
    ///   - _type: The type to represent the metadata of.
    ///
    init(withType _type: Any.Type) {
        self = _autoReinterpretCast(_type).mutating.pointee
    }
    
}
