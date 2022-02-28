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
        let internalRepresentation: UnsafeMutablePointer<InternalRepresentation> = swift_desanitizeMetadata(_type)
        self = unsafeBitCast(internalRepresentation, to: Self.self)
    }

}
