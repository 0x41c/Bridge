//
//  TupleMetadata.swift
//  
//
//  Created by 0x41c on 2022-02-27.
//

struct TupleMetadata: StructureRepresentation {

    struct InternalRepresentation: InternalStructureBase {

        private var _kind: Int
        private var _numberOfElements: Int
        private var _labelsString: UnsafeMutablePointer<CChar>
        private var _elementInfo: UnsafeMutableBufferPointer<TupleElement>

    }

    struct TupleElement {
        var type: Any.Type
        var offset: Int
    }

    var `_`: UnsafeMutablePointer<InternalRepresentation>
    var kind: Int { `_`.pointee.kind! }
    var numberOfElements: Int { `_`.pointee.numberOfElements! }
    var labelsString: UnsafeMutablePointer<CChar> { `_`.pointee.labelsString! }
    var elementInfo: UnsafeMutableBufferPointer<TupleElement> { `_`.pointee.elementInfo! }

}
