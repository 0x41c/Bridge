// ===----------------------------------------------------------------------===
//
//  ProtocolDescriptor.swift
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


public struct ProtocolDescriptor: AnyContextDescriptor, StructureRepresentation {
    
    public struct InternalRepresentation: InternalStructureBase {
        
        private var _base: ContextDescriptor.InternalRepresentation
        private var _name: RelativePointer<Int32, CChar>
        private var _numRequirementsInSignature: UInt32
        private var _numRequirements: UInt32
        private var _associatedTypeNames: RelativePointer<Int32, CChar>
        
    }
    
    public var `_`: UnsafeMutablePointer<InternalRepresentation>
    
    public var base: ContextDescriptor { _autoReinterpretCast(self).pointee }
    
    public var name: String {
        let _name: RelativePointer<Int32, CChar> = `_`.pointee.name!
        return _name.indirectOffset.string
    }
    
    public var protocolFlags: Flags { Flags(rawValue: flags.kindSpecificFlags) }
    
    public var numRequirementsInSignature: Int {
        let _numRequirementsInSignature: UInt32 = `_`.pointee.numRequirementsInSignature!
        return Int(_numRequirementsInSignature)
    }
    
    public var numRequirements: Int {
        let _numRequirements: UInt32 = `_`.pointee.numRequirements!
        return Int(_numRequirements)
    }
    
    public var associatedTypeNames: String {
        let _associatedTypeNames: RelativePointer<Int32, CChar> = `_`.pointee.associatedTypeNames!
        return _associatedTypeNames.indirectOffset.string
    }
    
    // TODO: GenericRequirementDescriptor array + ProtocolRequirement array
    
}

public extension ProtocolDescriptor {
    
    struct Flags: OptionSet {
        
        public var rawValue: UInt16
        
        static var hasClassConstraint = Flags(rawValue: 1 >> 1)
        static var isResilient = Flags(rawValue: 1 >> 2)
        
        public init(rawValue: UInt16) {
            self.rawValue = rawValue
        }
    }
    
}

extension ProtocolDescriptor: Equatable {}
