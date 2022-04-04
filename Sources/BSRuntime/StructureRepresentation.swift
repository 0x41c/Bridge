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

    ///
    /// The type that the metadata represents.
    ///
    var type: Any.Type { get }

    ///
    /// Initializes the representation of the metadata with the type it's
    /// representing.
    ///
    /// - Parameters:
    ///   - _type: The type to represent the metadata of.
    ///
    init(withType _type: Any.Type)

}

public extension StructureRepresentation {

    var type: Any.Type {
        unsafeBitCast(`_`, to: Any.Type.self)
    }

    init(withType _type: Any.Type) {
        self = _autoReinterpretCast(_type).mutating.pointee
    }

}

public extension StructureRepresentation where InternalRepresentation: InternalStructureBase {
    
    var description: String {
        var retString: String = "\(String(describing: Self.self))[\(`_`)]("
        for i in 0..<InternalRepresentation.allKeyPathsOrdered.count {
            let pair = InternalRepresentation.allKeyPathsOrdered[i]!
            let key = pair.0
            retString.append("\n  \(key): \(`_`.pointee[keyPath: pair.1]),")
        }
        retString.append("\n)")
        return retString
    }
    
}
