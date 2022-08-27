// ===----------------------------------------------------------------------===
//
//  FunctionMetadata.swift
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

public struct FunctionMetadata: AnyMetadata {

    public struct MetadataStructure: InternalStructureBase {

        private var _kind: Int
        private var _flags: Int
        private var _returnType: Any.Type

    }

    public var `_`: UnsafeMutablePointer<MetadataStructure>
    public var flags: FunctionTypeFlags { FunctionTypeFlags(rawValue: `_`.pointee.flags!) }
    public var returnType: Any.Type { `_`.pointee.returnType! }
    
    public var paramTypes: [Any.Type] {
        Array(unsafeUninitializedCapacity: flags.numParams) { buffer, initializedCount in
            for i in 0..<flags.numParams {
                buffer[i] = _autoReinterpretCast(
                    `_`.trailing + (i * MemoryLayout<Any.Type>.size)
                ).pointee
            }
            initializedCount = flags.numParams
        }
    }
    
    public var paramFlags: [FunctionParameterFlags] {
        Array(unsafeUninitializedCapacity: flags.numParams) { buffer, initializedCount in
            let start = `_`.trailing + (flags.numParams * MemoryLayout<Any.Type>.size)
            for i in 0..<flags.numParams {
                buffer[i] = _autoReinterpretCast(
                    start + (i * MemoryLayout<FunctionParameterFlags>.size)
                ).pointee
            }
        }
    }
    
    public var parameters: [FunctionParameter] {
        let types = paramTypes
        let pflags = paramFlags
        
        var ret = [FunctionParameter]()
        for i in 0..<flags.numParams {
            ret.append(
                FunctionParameter(
                    type: types[i],
                    flags: pflags[i]
                )
            )
        }
        return ret
    }
    
}

public extension FunctionMetadata {
    
    struct FunctionTypeFlags: OptionSet {
        
        public var rawValue: Int
        
        public static var throwAttribute = FunctionTypeFlags(rawValue: 1 << 25)
        public static var paramFlags = FunctionTypeFlags(rawValue: 1 << 26)
        public static var escapingAttribute = FunctionTypeFlags(rawValue: 1 << 27)
        
        public var numParams: Int {
            rawValue & 0xFFFF
        }
        
        public var callingConventionBits: UInt8 {
            UInt8((rawValue & 0xFF0000) >> 16)
        }
        
        public var callingConvention: FunctionCallingConvention {
            FunctionCallingConvention(rawValue: callingConventionBits)!
        }
        
        public init(rawValue: Int) {
            self.rawValue = rawValue
        }
        
    }
    
    enum FunctionCallingConvention: UInt8 {
        case swift = 0
        case block = 1
        case thin  = 2
        case c     = 3
    }
    
}


public extension FunctionMetadata {
    
    struct FunctionParameter {
        
        public var type: Any.Type
        public var flags: FunctionParameterFlags
        public var metadata: Metadata { Metadata(withType: type) }
        
    }
    
    
    struct FunctionParameterFlags: OptionSet {
        public let rawValue: UInt32
        
        public static var variadic = FunctionParameterFlags(rawValue: 1 << 8)
        public static var autoclosue = FunctionParameterFlags(rawValue: 1 << 9)
        
        public var paramValueOwnership: FunctionParameterValueOwnership {
            FunctionParameterValueOwnership(rawValue: UInt8(rawValue & 0x7F))!
        }
        
        public init(rawValue: UInt32) {
            self.rawValue = rawValue
        }
    }
    
    enum FunctionParameterValueOwnership: UInt8 {
        case `default` = 0
        case `inout`   = 1
        case shared    = 3
        case owned     = 4
    }
    
}

extension FunctionMetadata: Equatable {}
