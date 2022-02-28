//
//  Protocol.swift
//  
//
//  Created by 0x41c on 2022-02-27.
//

struct ProtocolMetadata: StructureRepresentation {

    struct InternalRepresentation: InternalStructureBase {

        private var _kind: Int
        private var _layoutFlags: Int
        private var _numberOfProtocols: Int
        private var _nominalTypeDescriptor: UnsafeRawPointer // TODO: Mutable + Vector

    }

    var `_`: UnsafeMutablePointer<InternalRepresentation>
    var kind: Int { `_`.pointee.kind! }
    var layoutFlags: Int { `_`.pointee.layoutFlags! }
    var numberOfProtocols: Int { `_`.pointee.numberOfProtocols! }
    var nominalTypeDescriptor: UnsafeRawPointer { `_`.pointee.nominalTypeDescriptor! }

}
