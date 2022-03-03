//
//  FunctionMetadata.swift
//  BSRuntime
//
//  Created by 0x41c on 2022-02-27.
//

public struct FunctionMetadata: StructureRepresentation {

    public struct InternalRepresentation: InternalStructureBase {

        private var _kind: Int
        private var _flags: Int
        private var _argumentVector: UnsafeRawPointer // TODO: Vector

    }

    public var `_`: UnsafeMutablePointer<InternalRepresentation>
    public var kind: Int { `_`.pointee.kind! }
    public var flags: UnsafeRawPointer { `_`.pointee.flags! }
    public var argumentVector: UnsafeRawPointer { `_`.pointee.argumentVector! }

}
