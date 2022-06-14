// ===----------------------------------------------------------------------===
//
//  TupleMetadata.swift
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

public struct TupleMetadata: TypeMetadata {

    public struct MetadataStructure: InternalStructureBase {

        private var _kind: Int
        private var _numberOfElements: Int
        private var _labelsString: UnsafeMutablePointer<CChar>?
        private var _elementInfo: UnsafeMutablePointer<TupleElement>

    }

    public var `_`: UnsafeMutablePointer<MetadataStructure>
    public var numberOfElements: Int { `_`.pointee.numberOfElements! }
    public var labelsString: UnsafeMutablePointer<CChar> { `_`.pointee.labelsString! }
    public var elementInfo: UnsafeMutablePointer<TupleElement> { `_`.pointee.elementInfo! }
    
    public var labels: [String] {
        var ret = [String]()
        let cString: UnsafeMutablePointer<CChar>? = `_`.pointee.labelsString
        let splitString = cString?.string.split(
            separator: " ",
            maxSplits: numberOfElements,
            omittingEmptySubsequences: false
        )
        
        
        for i in 0..<numberOfElements {
            if let splitString = splitString, splitString[i] != "" {
                ret.append(String(splitString[i]))
            } else {
                ret.append("\(i)")
            }
        }
        
        return ret
    }
    
    public var elements: [TupleElementMetadata] {
        Array(unsafeUninitializedCapacity: numberOfElements) { buffer, initializedCount in
            for i in 0..<numberOfElements {
                buffer[i] = _autoReinterpretCast(
                    `_`.trailing.offset(by: i * TupleElementMetadata.structureSize)
                ).pointee
            }
            initializedCount = numberOfElements
        }
    }
    
}

public extension TupleMetadata {
    struct TupleElement {
        public var type: Any.Type
        public var offset: Int
    }
}

extension TupleMetadata: Equatable {}
