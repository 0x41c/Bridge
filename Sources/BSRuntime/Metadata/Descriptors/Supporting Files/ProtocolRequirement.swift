// ===----------------------------------------------------------------------===
//
//  ProtocolRequirement.swift
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



public struct ProtocolRequirement: StructureRepresentation {
    
    public struct InternalRepresentation: InternalStructureBase {
        
        private var _flags: Flags
        private var _defaultImplementation: RelativePointer<Int32, Void>
        
    }
    
    public var `_`: UnsafeMutablePointer<InternalRepresentation>
    public var flags: Flags { `_`.pointee.flags! }
    
}

public extension ProtocolRequirement {
    
    struct Flags: OptionSet {
        
        public var rawValue: UInt32
        
        public var kind: Kind {
            Kind(rawValue: UInt8(rawValue & 0xF))!
        }
        
        public init(rawValue: UInt32) {
            self.rawValue = rawValue
        }
        
    }
    
}

public extension ProtocolRequirement {
    
    enum Kind: UInt8 {
        case baseProtocol
        case method
        case `init`
        case getter
        case setter
        case readCoroutine
        case modifyCoroutine
        case associatedTypeAccessFunction
        case associatedConformanceAccessFunction
    }
    
}

extension ProtocolRequirement: Equatable {}
