// ===----------------------------------------------------------------------===
//
//  StructureRepresentation.swift
//  BSRuntime
//
//  Created by 0x41c on 2022-02-16.
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

public protocol StructureRepresentation: CustomStringConvertible {

    associatedtype InternalRepresentation

    ///
    /// A pointer the the types underlying representation. This pointer
    /// is resilient.
    ///
    var `_`: UnsafeMutablePointer<InternalRepresentation> { get }

}

public extension StructureRepresentation {
    
    ///
    /// Initializes this representation with a raw pointer. This will
    /// be casted to the representation type.
    ///
    ///  - Parameters:
    ///     - pointer: The pointer to the metadata to represent.
    ///
    init(withPointer pointer: UnsafeRawPointer) {
        self = _autoReinterpretCast(pointer).mutating.pointee
    }
    
    ///
    /// Initializes this representation with a pointer to the already casted
    /// metadata representation.
    ///
    ///  - Parameters:
    ///     - structure: The structure to initialize this metadata wrapper with.
    ///
    init(withStructure structure: UnsafeMutablePointer<InternalRepresentation>) {
        self = _autoReinterpretCast(structure).mutating.pointee
    }
    
}

public extension StructureRepresentation where InternalRepresentation: InternalStructureBase {
    
    var description: String {
        var retString: String = "\(String(describing: Self.self))[\(`_`)]("
        for i in 0..<InternalRepresentation.allKeyPathsOrdered.count {
            let pair = InternalRepresentation.allKeyPathsOrdered[i]!
            let key = pair.0
            
            // This suffers an issue where it will crash on accessing a structure invalidly.
            // The reason for the crash can be trivial however, so in the future, we should
            // consider creating an issue on the swift repo to fix it.
            retString.append("\n  \(key): \(`_`.pointee[keyPath: pair.1]),")
        }
        retString.append("\n)")
        return retString
    }
    
}
