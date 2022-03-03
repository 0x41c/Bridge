//
//  TupleMetadata.swift
//  BSRuntime
//
//  Created by 0x41c on 2022-02-27.
//

public struct TupleMetadata: StructureRepresentation {

    public struct InternalRepresentation: InternalStructureBase {

        private var _kind: Int
        private var _numberOfElements: Int
        private var _labelsString: UnsafeMutablePointer<CChar>
        private var _elementInfo: UnsafeMutableBufferPointer<TupleElement>

    }

    public struct TupleElement {
        var type: Any.Type
        var offset: Int
    }

    public var `_`: UnsafeMutablePointer<InternalRepresentation>
    public var kind: Int { `_`.pointee.kind! }
    public var numberOfElements: Int { `_`.pointee.numberOfElements! }
    public var labelsString: UnsafeMutablePointer<CChar> { `_`.pointee.labelsString! }
    public var elementInfo: UnsafeMutableBufferPointer<TupleElement> { `_`.pointee.elementInfo! }

}
