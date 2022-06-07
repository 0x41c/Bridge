// ===----------------------------------------------------------------------===
//
//  ContextDescriptor.swift
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


public struct ContextDescriptor: StructureRepresentation {
    
    public struct InternalRepresentation: InternalStructureBase {
        private var _flags: UInt32
    }
    
    public var `_`: UnsafeMutablePointer<InternalRepresentation>
    public var flags: Flags { Flags(rawValue: `_`.pointee.flags!) }
}

public extension ContextDescriptor {
    
    struct Flags: OptionSet {
        
        public var rawValue: UInt32
        
        static let unique = Flags(rawValue: 1 << 6)
        static let generic = Flags(rawValue: 1 << 7)
        
        public var kind: Kind {
            Kind(rawValue: Int(rawValue) & 0x1F)!
        }
        
        public init(rawValue: UInt32) {
            self.rawValue = rawValue
        }
        
    }
}

public extension ContextDescriptor {
    
    enum Kind: Int {
        
        case module = 0
        case `extension` = 1
        case anonymous = 2
        case `protocol` = 3
        case opaqueType = 4
        case `class` = 16
        case `struct` = 17
        case `enum` = 18
        
    }
    
}
