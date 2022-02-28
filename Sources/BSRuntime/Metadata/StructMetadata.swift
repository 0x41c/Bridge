//
//  StructMetadata.swift
//  
//
//  Created by 0x41c on 2022-02-27.
//

struct StructMetadata: StructureRepresentation {

    struct InternalRepresentation: InternalStructureBase {

        private var _kind: Int
        private var _nominalTypeDescriptor: UnsafeRawPointer // TODO: This is a signed pointer.

    }

    var `_`: UnsafeMutablePointer<InternalRepresentation>
    var kind: Int { `_`.pointee.kind! }
    var nominalTypeDescriptor: UnsafeRawPointer { `_`.pointee.nominalTypeDescriptor! }

}
