// ===----------------------------------------------------------------------===
//
//  ValueWitnessTable.swift
//  BSRuntime
//
//  Created by 0x41c on 2022-03-11.
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

import ptrauth

// Hey, confused? Find the discriminators here:  https://github.com/apple/swift/blob/main/include/swift/ABI/MetadataValues.h#L1177
// (ex: 0xda4a)

public struct ValueWitnessTable: StructureRepresentation {
    
    public struct InternalRepresentation: InternalStructureBase {
        
        private var _initializeBufferWithCopyOfBuffer: ibwcob_t
        private var _destroy: destroy_t
        private var _initializeWithCopy: iwc_t
        private var _assignWithCopy: awc_t
        private var _assignWithTake: awt_t
        private var _getEnumTagSinglePayload: getsp_t
        private var _setEnumtagSinglePayload: sestp_t
        private var _size: Int
        private var _stride: Int
        private var _flags: Flags
        private var _extraInhabitantCount: UInt32
        
    }
    
    public var `_`: UnsafeMutablePointer<InternalRepresentation>
    public var size: Int { `_`.pointee.size! }
    public var stride: Int { `_`.pointee.stride! }
    public var flags: Flags { `_`.pointee.flags! }
    public var _extraInhabitantCount: UInt32 { `_`.pointee.extraInhabitantCount! }
    
    
    public func initializeBufferWithCopyOfBuffer(
        _ destination: UnsafeMutableRawPointer,
        _ source: UnsafeMutableRawPointer
    )  {
        let _initializeBufferWithCopyOfBuffer: ibwcob_t = getSignedFunction(
            named: "initializeBufferWithCopyOfBuffer",
            with: 0xda4a
        )
        _ = _initializeBufferWithCopyOfBuffer(destination, source, `_`.trailing)
    }
    
    public func destroy(
        _ value: UnsafeMutableRawPointer
    ) {
        let _destroy: destroy_t = getSignedFunction(
            named: "destroy",
            with: 0x04f8
        )
        _destroy(value, `_`.trailing)
    }
    
    public func initializeWithCopy(
        _ destination: UnsafeMutableRawPointer,
        _ source: UnsafeMutableRawPointer
    ) {
        let _initializeWithCopy: iwc_t = getSignedFunction(
            named: "initializeWithCopy",
            with: 0xe3ba
        )
        _ = _initializeWithCopy(destination, source, `_`.trailing)
    }
    
    public func assignWithCopy(
        _ destination: UnsafeMutableRawPointer,
        _ source: UnsafeMutableRawPointer
    ) {
        let _assignWithCopy: awc_t = getSignedFunction(
            named: "assignWithCopy",
            with: 0x8751
        )
        _ = _assignWithCopy(destination, source, `_`.trailing)
    }
    
    public func getEnumTagSinglePayload(
        _ enumInstance: UnsafeRawPointer,
        _ numEmptyCases: UInt32
    ) -> UInt32 {
        let _getEnumTagSinglePayload: getsp_t = getSignedFunction(
            named: "getEnumTagSinglePayload",
            with: 0x60f0
        )
        return _getEnumTagSinglePayload(enumInstance, numEmptyCases, `_`.trailing)
    }
    
    public func storeEnumTagSinglePayload(
        _ enumInstance: UnsafeMutableRawPointer,
        _ tag: UInt32,
        _ numEmptyCases: UInt32
    ) {
        let _storeEnumTagSinglePayload: sestp_t = getSignedFunction(
            named: "storeEnumTagSinglePayload",
            with: 0xa0d1
        )
        _ = _storeEnumTagSinglePayload(enumInstance, tag, numEmptyCases, `_`.trailing)
    }
    
    private func getSignedFunction<T>(
        named name: String,
        with discriminator: UInt64
    ) -> T {
        let signedFunction = PointerAuthentication.signUnauthenticated(
            &`_`.pointee[dynamicMember: name]!,
            ptrauth_key_function_pointer,
            discriminator
        )
        return _autoReinterpretCast(signedFunction).pointee
    }
}

public extension ValueWitnessTable {
    
    struct Flags: OptionSet {
        
        static let nonPOD = Flags(rawValue: 1 << 16)
        static let nonInline = Flags(rawValue: 1 << 17)
        static let hasSpareBits = Flags(rawValue: 1 << 19)
        static let isNonBitwiseTakable = Flags(rawValue: 1 << 20)
        static let hasEnumWitness = Flags(rawValue: 1 << 21)
        static let incomplete = Flags(rawValue: 1 << 22)
        
        public var rawValue: UInt32
        
        // Azoy, I swear I didn't copy paste, obv
        // See? Different order :P
        
        public var alignmentMask: Int {
            Int(rawValue & 0xFF)
        }
        
        public var alignment: Int {
            alignmentMask + 1
        }
        
        public init(rawValue: UInt32) {
            self.rawValue = rawValue
        }
    }
}

extension ValueWitnessTable: Equatable {}


// _initializeBufferWithCopyOfBuffer
private typealias ibwcob_t = @convention(c) (
    UnsafeMutableRawPointer,
    UnsafeMutableRawPointer,
    UnsafeRawPointer
) -> UnsafeMutableRawPointer

// _destroy
private typealias destroy_t = @convention(c) (
    UnsafeMutableRawPointer,
    UnsafeRawPointer
) -> ()

// _initializeWithCopy
private typealias iwc_t = @convention(c) (
    UnsafeMutableRawPointer,
    UnsafeMutableRawPointer,
    UnsafeRawPointer
) -> UnsafeMutableRawPointer

// _assignWithCopy
private typealias awc_t = @convention(c) (
    UnsafeMutableRawPointer,
    UnsafeMutableRawPointer,
    UnsafeRawPointer
) -> UnsafeMutableRawPointer

// _assignWithTake
private typealias awt_t = @convention(c) (
    UnsafeMutableRawPointer,
    UnsafeMutableRawPointer,
    UnsafeRawPointer
) -> UnsafeMutableRawPointer

// _getEnumSingleTagPayload
private typealias getsp_t = @convention(c) (
    UnsafeRawPointer,
    UInt32,
    UnsafeRawPointer
) -> UInt32

// _setEnumSingleTagPayload
private typealias sestp_t = @convention(c) (
    UnsafeMutableRawPointer,
    UInt32,
    UInt32,
    UnsafeRawPointer
) -> ()


