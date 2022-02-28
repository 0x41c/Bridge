//
//  EnumMetadata.swift
//  
//
//  Created by 0x41c on 2022-02-27.
//

public struct EnumMetadata: StructureRepresentation {

    public struct InternalRepresentation: InternalStructureBase {

        private var _kind: Int
        private var _nominalTypeDescriptor: UnsafeRawPointer // TODO: This is a signed pointer.

    }

    public var `_`: UnsafeMutablePointer<InternalRepresentation>
    public var kind: Int { `_`.pointee.kind! }
    public var nominalTypeDescriptor: UnsafeRawPointer { `_`.pointee.nominalTypeDescriptor! }

}
