//
//  FunctionMetadata.swift
//  
//
//  Created by 0x41c on 2022-02-27.
//

struct FunctionMetadata: StructureRepresentation {

    struct InternalRepresentation: InternalStructureBase {

        private var _kind: Int
        private var _flags: Int
        private var _argumentVector: UnsafeRawPointer // TODO: Vector

    }

    var `_`: UnsafeMutablePointer<InternalRepresentation>
    var kind: Int { `_`.pointee.kind! }
    var flags: UnsafeRawPointer { `_`.pointee.flags! }
    var argumentVector: UnsafeRawPointer { `_`.pointee.argumentVector! }

}
