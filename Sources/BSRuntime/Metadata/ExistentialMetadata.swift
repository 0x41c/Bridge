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


public struct ExistentialMetadata: AnyMetadata {
    
    public struct InternalRepresentation: InternalStructureBase {
        
        private var _kind: Int
        private var _flags: Flags
        private var _numProtocols: UInt32
        
    }
    
    public var `_`: UnsafeMutablePointer<InternalRepresentation>
    public var flags: Flags { `_`.pointee.flags! }
    public var numProtocols: UInt32 { `_`.pointee.numProtocols! }
    
    public var superclass: Any.Type? {
        guard flags.contains(.hasSuperclassConstraint) else {
            return nil
        }
        return `_`.trailing.load(as: Any.Type.self)
    }
    
    // public var superclassMetadata: TypeMetadata? {} TODO: Generic metadata reflection given any value
    
    // TODO: Protocol List using ProtocolDescriptors
    
}

public extension ExistentialMetadata {
    
    struct Flags: OptionSet {
        
        public var rawValue: UInt32
        
        public var numWitnessTables: Int {
            Int(rawValue & 0xFFFFFF)
        }
        
        public var specialProtocol: SpecialProtocol {
            SpecialProtocol(rawValue: UInt8((rawValue & 0x3F000000) >> 24))!
        }
        
        static var hasSuperclassConstraint = Flags(rawValue: 1 << 0x40000000)
        static var isNotClassConstrained = Flags(rawValue: 1 << 0x80000000)
        
        public init(rawValue: UInt32) {
            self.rawValue = rawValue
        }
    }
    
    enum SpecialProtocol: UInt8 {
        case none = 0
        case error = 1 // Swift.Error
    }
    
}

extension ExistentialMetadata: Equatable {}
