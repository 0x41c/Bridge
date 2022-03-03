//
//  ClassMetadata.swift
//  BSRuntime
//
//  Created by 0x41c on 2022-02-25.
//

public struct ClassMetadata: StructureRepresentation {

    public struct InternalRepresentation: InternalStructureBase {

        private var _kind: Int
        private var _superclass: Any.Type?
        #if swift(>=5.4) || canImport(ObjectiveC)
        private var _reserved: (Int, Int)
        private var _rodata: UnsafeRawPointer
        #endif
        private var _flags: UInt32
        private var _instanceAddressPoint: UInt32
        private var _instanceSize: UInt32
        private var _instanceAlignment: UInt16
        private var _runtimeReservedField: UInt16
        private var _classObjectSize: UInt32
        private var _classObjectAddressPoint: UInt32
        private var _nominalTypeDescriptor: UnsafeRawPointer // TODO: This is a signed pointer.
        private var _ivarDestroyer: UnsafeRawPointer

    }

    public var `_`: UnsafeMutablePointer<InternalRepresentation>
    public var kind: Int { `_`.pointee.kind! }
    public var superclass: Any.Type? { `_`.pointee.superclass! }
    #if swift(>=5.4) || canImport(ObjectiveC)
    public var reserved: (Int, Int) { `_`.pointee.reserved! }
    public var rodata: UnsafeRawPointer { `_`.pointee.rodata! }
    #endif
    public var flags: UInt32 { `_`.pointee.flags! }
    public var instanceAddressPoint: UInt32 { `_`.pointee.instanceAddressPoint! }
    public var instanceSize: UInt32 { `_`.pointee.instanceSize! }
    public var instanceAlignment: UInt16 { `_`.pointee.instanceAlignment! }
    public var runtimeReservedField: UInt16 { `_`.pointee.runtimeReservedField! }
    public var classObjectSize: UInt32 { `_`.pointee.classObjectSize! }
    public var classObjectAddressPoint: UInt32 { `_`.pointee.classObjectAddressPoint! }
    public var nominalTypeDescriptor: UnsafeRawPointer { `_`.pointee.nominalTypeDescriptor! }
    public var ivarDestroyer: UnsafeRawPointer { `_`.pointee.ivarDestroyer! }

}
