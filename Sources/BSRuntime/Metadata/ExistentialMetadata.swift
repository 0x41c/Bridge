// ===----------------------------------------------------------------------===
//
//  ExistentialMetadata.swift
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


public struct ExistentialMetadata: StructureRepresentation {
    
    public struct InternalRepresentation: InternalStructureBase {
        
        private var _kind: Int
        private var _flags: Flags
        private var _numProtos: UInt32
        
    }
    
    public var `_`: UnsafeMutablePointer<InternalRepresentation>
    public var flags: Flags { `_`.pointee.flags! }
    
}

public extension ExistentialMetadata {
    
    struct Flags: OptionSet {
        
        public var rawValue: UInt32
        
        public init(rawValue: UInt32) {
            self.rawValue = rawValue
        }
    }
    
}
