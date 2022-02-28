//
//  ClassMetadata.swift
//  
//
//  Created by 0x41c on 2022-02-25.
//

struct ClassMetadata: StructureRepresentation {

    struct InternalRepresentation: InternalStructureBase {

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

    var `_`: UnsafeMutablePointer<InternalRepresentation>
    var kind: Int { `_`.pointee.kind! }
    var superclass: Any.Type? { `_`.pointee.superclass! }
    #if swift(>=5.4) || canImport(ObjectiveC)
    var reserved: (Int, Int) { `_`.pointee.reserved! }
    var rodata: UnsafeRawPointer { `_`.pointee.rodata! }
    #endif
    var flags: UInt32 { `_`.pointee.flags! }
    var instanceAddressPoint: UInt32 { `_`.pointee.instanceAddressPoint! }
    var instanceSize: UInt32 { `_`.pointee.instanceSize! }
    var instanceAlignment: UInt16 { `_`.pointee.instanceAlignment! }
    var runtimeReservedField: UInt16 { `_`.pointee.runtimeReservedField! }
    var classObjectSize: UInt32 { `_`.pointee.classObjectSize! }
    var classObjectAddressPoint: UInt32 { `_`.pointee.classObjectAddressPoint! }
    var nominalTypeDescriptor: UnsafeRawPointer { `_`.pointee.nominalTypeDescriptor! }
    var ivarDestroyer: UnsafeRawPointer { `_`.pointee.ivarDestroyer! }

}
