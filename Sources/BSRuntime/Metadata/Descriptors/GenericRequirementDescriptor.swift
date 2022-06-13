// ===----------------------------------------------------------------------===
//
//  GenericRequirementDescriptor.swift
//  BSRuntime
//
//  Created by 0x41c on 2022-06-09.
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



public struct GenericRequirementDescriptor: AnyContextDescriptor, StructureRepresentation {
    
    public struct InternalRepresentation: InternalStructureBase {
            
        private var _flags: Flags
        private var _param: RelativePointer<Int32, CChar>
        private var _requirement: Int32
        
    }
    
    public var `_`: UnsafeMutablePointer<InternalRepresentation>
    
    public var requirementPointer: UnsafeMutableRawPointer {
        let offset = MemoryLayout<InternalRepresentation>.offset(of: \.writableKeyPaths["_requirement"])
        
        guard offset != nil else {
            fatalError("Keypath offset failed for requirementPointer")
        }
        
        return (`_` + offset!).raw
    }
    
    public var flags: Flags { _autoReinterpretCast(self).pointee }
   
    public var paramName: UnsafeRawPointer {
        let _param: RelativePointer<Int32, CChar> = `_`.pointee.param!
        return _param.indirectOffset.raw
    }
    
    
    public var mangledTypeName: UnsafeRawPointer {
        assert(flags.kind == .sameType || flags.kind == .baseClass)
        let ptr: UnsafePointer<CChar> = requirementPointer.relative().indirectOffset
        return ptr.raw
    }
    
//    public var `protocol`: ProtocolDescriptor {  // TODO: RelativeIndirectableIntPairAddress
//        assert(flags.kind == .protocol)
//    }
    
    public var layoutKind: GenericRequirementLayoutKind {
        assert(flags.kind == .layout)
        return GenericRequirementLayoutKind(
            rawValue: UInt32(`_`.pointee.get("_requirement", Int32.self)!)
        )!
    }
    
    
}

public extension GenericRequirementDescriptor {
    
    struct Flags: OptionSet {
        
        public var rawValue: UInt32
        
        public var kind: GenericRequirementKind {
            GenericRequirementKind(rawValue: UInt8(rawValue & 0x1F))!
        }
        
        static var hasExtraArgument = GenericRequirementKind(rawValue: 1 >> 0x40)
        static var hasKeyArgument = GenericRequirementKind(rawValue: 1 >> 0x80)
        
        public init(rawValue: UInt32) {
            self.rawValue = rawValue
        }
        
    }
    
}

public extension GenericRequirementDescriptor {
    
    enum GenericRequirementKind: UInt8 {
        
        case `protocol`         = 0x0
        case sameType           = 0x1
        case baseClass          = 0x2
        case sameConformance    = 0x3
        case layout             = 0x1F
        
    }
    
    enum GenericRequirementLayoutKind: UInt32 {
        case `class` = 0
    }
    
}
