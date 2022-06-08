// ===----------------------------------------------------------------------===
//
//  ClassMetadata.swift
//  BSRuntime
//
//  Created by 0x41c on 2022-02-25.
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

public struct ClassMetadata: TypeMetadata {

    public struct InternalRepresentation: InternalStructureBase {

        private var _kind: Int
        private var _superclass: Any.Type?
        #if swift(>=5.4) || canImport(ObjectiveC)
        private var _reserved: (Int, Int)
        private var _rodata: UnsafeRawPointer
        #endif
        private var _flags: Flags
        private var _instanceAddressPoint: UInt32
        private var _instanceSize: UInt32
        private var _instanceAlignment: UInt16
        private var _runtimeReservedField: UInt16
        private var _classObjectSize: UInt32
        private var _classObjectAddressPoint: UInt32
        private var _nominalTypeDescriptor: SignedPointer<ClassDescriptor.InternalRepresentation> // ClassTypeContextDescriptor
        private var _ivarDestroyer: UnsafeRawPointer? // If this pointer is to 0x0 we don't want to access it.

    }

    public var `_`: UnsafeMutablePointer<InternalRepresentation>
    public var superclass: Any.Type? { `_`.pointee.superclass! }
    #if swift(>=5.4) || canImport(ObjectiveC)
    public var reserved: (Int, Int) { `_`.pointee.reserved! }
    public var rodata: UnsafeRawPointer { `_`.pointee.rodata! }
    #endif
    public var flags: Flags { `_`.pointee.flags! }
    public var instanceAddressPoint: UInt32 { `_`.pointee.instanceAddressPoint! }
    public var instanceSize: UInt32 { `_`.pointee.instanceSize! }
    public var instanceAlignment: UInt16 { `_`.pointee.instanceAlignment! }
    public var runtimeReservedField: UInt16 { `_`.pointee.runtimeReservedField! }
    public var classObjectSize: UInt32 { `_`.pointee.classObjectSize! }
    public var classObjectAddressPoint: UInt32 { `_`.pointee.classObjectAddressPoint! }
    
    public var nominalTypeDescriptor: ClassDescriptor {
        let signedPtr: SignedPointer<ClassDescriptor.InternalRepresentation> = `_`.pointee.nominalTypeDescriptor!
        return ClassDescriptor(withStructure: signedPtr.stripped.mutating)
    }
    
    public var ivarDestroyer: UnsafeRawPointer? { `_`.pointee.ivarDestroyer }

}

extension ClassMetadata: Equatable {}

public extension ClassMetadata {
    struct Flags: OptionSet {
        
        public var rawValue: UInt32
        
        static var isSwiftPreStableABI = Flags(rawValue: 1 << 0x1)
        static var useSwiftRefCounting = Flags(rawValue: 1 << 0x2)
        static var hasCustomObjcName = Flags(rawValue: 1 << 0x4)
        
        public init(rawValue: UInt32) {
            self.rawValue = rawValue
        }
        
    }
}
