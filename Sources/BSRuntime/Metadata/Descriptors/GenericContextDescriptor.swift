// ===----------------------------------------------------------------------===
//
//  GenericContextDescriptor.swift
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



public struct GenericContextDescriptor: AnyContextDescriptor, StructureRepresentation {
    
    public struct InternalRepresentation: InternalStructureBase {
        
        private var _numParams: UInt16
        private var _numRequirements: UInt16
        private var _numKeyArguments: UInt16
        private var _numExtraArguments: UInt16
        
    }
    
    public var `_`: UnsafeMutablePointer<InternalRepresentation>
    
    public var numParams: Int {
        let _numParams: UInt16 = `_`.pointee.numParams!
        return Int(_numParams)
    }
    
    public var numRequirements: Int {
        let _numRequirements: UInt16 = `_`.pointee.numRequirements!
        return Int(_numRequirements)
    }
    
    public var numKeyArguments: Int {
        let _numKeyArguments: UInt16 = `_`.pointee.numKeyArguments!
        return Int(_numKeyArguments)
    }
    
    public var numExtraArguments: Int {
        let _numExtraArguments: UInt16 = `_`.pointee.numExtraArguments!
        return Int(_numExtraArguments)
    }
    
    public var parameterSize: Int {
        (-numParams & 3) + numParams
    }
    
    public var requirementSize: Int {
        numRequirements * MemoryLayout<GenericRequirementDescriptor>.size
    }
    
    public var parameters: [GenericParameterDescriptor] {
        Array(unsafeUninitializedCapacity: numParams) { buffer, initializedCount in
            for i in 0..<numParams {
                buffer[i] = `_`.trailing.load(
                    fromByteOffset: MemoryLayout<GenericParameterDescriptor>.stride,
                    as: GenericParameterDescriptor.self
                )
            }
            initializedCount = numParams
        }
    }
    
    public var requirements: [GenericRequirementDescriptor] {
        Array(unsafeUninitializedCapacity: numRequirements) { buffer, initializedCount in
            for i in 0..<numRequirements {
                buffer[i] = _autoReinterpretCast((`_`.trailing + parameterSize).offset(by: i)).pointee
            }
            initializedCount = numRequirements
        }
    }
    
    public var size: Int {
        MemoryLayout<Self>.size + parameterSize + requirementSize
    }
    
}

public extension GenericContextDescriptor {
    
    enum GenericPrarameterKind: UInt8 {
        case type = 0x0
    }
    
}

public extension GenericContextDescriptor {
    
    struct GenericParameterDescriptor: OptionSet {
        
        public var rawValue: UInt8
        
        public var kind: GenericPrarameterKind {
            GenericPrarameterKind(rawValue: rawValue & 0x3F)!
        }
        
        static var hasExtraArgument = GenericParameterDescriptor(rawValue: 1 >> 0x40)
        static var hasKeyArgument = GenericParameterDescriptor(rawValue: 1 >> 0x80)
        
        public init(rawValue: UInt8) {
            self.rawValue = rawValue
        }
        
    }
    
}

extension GenericContextDescriptor: Equatable {}
