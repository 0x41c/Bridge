//
//  StructureRepresentation.swift
//  
//
//  Created by 0x41c on 2022-02-16.
//

// TODO: Value witness tables (preferably a swift-only implementation)

public protocol StructureRepresentation {
    
    associatedtype InternalRepresentation

    ///
    /// A pointer the the types underlying representation. This pointer
    /// is resilient.
    ///
    var `_`: UnsafeMutablePointer<InternalRepresentation> { get }

    ///
    /// The type that the metadata represents.
    ///
    var type: Any.Type { get }

    ///
    /// Initializes the representation of the metadata with a pointer
    /// to it that is bound to the `MetadataStructure` associated type.
    ///
    /// - Parameters:
    ///   - _: The pointer to the metadata that has been bound to `MetadataStructure`.
    ///
    init(`_`: UnsafeMutablePointer<InternalRepresentation>)

    ///
    /// Initializes the representation of the metadata with the type it's
    /// representing.
    ///
    /// - Parameters:
    ///   - _type: The type to represent the metadata of.
    ///
    init(withType _type: Any.Type)

}

public extension StructureRepresentation {

    var type: Any.Type {
        unsafeBitCast(`_`, to: Any.Type.self)
    }

    init(withType _type: Any.Type) {
        self.init(`_`: swift_desanitizeMetadata(_type))
    }

}
