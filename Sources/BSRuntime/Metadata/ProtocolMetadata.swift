//
//  Protocol.swift
//  
//
//  Created by 0x41c on 2022-02-27.
//

public struct ProtocolMetadata: StructureRepresentation {

    public struct InternalRepresentation: InternalStructureBase {

        private var _kind: Int
        private var _layoutFlags: Int
        private var _numberOfProtocols: Int
        private var _nominalTypeDescriptor: UnsafeRawPointer // TODO: Mutable + Vector

    }

    public var `_`: UnsafeMutablePointer<InternalRepresentation>
    public var kind: Int { `_`.pointee.kind! }
    public var layoutFlags: Int { `_`.pointee.layoutFlags! }
    public var numberOfProtocols: Int { `_`.pointee.numberOfProtocols! }
    public var nominalTypeDescriptor: UnsafeRawPointer { `_`.pointee.nominalTypeDescriptor! }

}
