//
//  CoreFunctions.swift
//  
//
//  Created by 0x41c on 2022-02-23.
//

@_silgen_name("$ss24_forEachFieldWithKeyPath2of7options4bodySbxm_s01_bC7OptionsVSbSPys4Int8VG_s07PartialeF0CyxGtXEtlF")
internal func _forEachFieldWithKeyPath<Root>(
    of type: Root.Type,
    options: UnsafePointer<_EachFieldOptions>,
    body: (UnsafePointer<CChar>, PartialKeyPath<Root>) -> Bool
) -> Bool

// A cool little trick to make asan and swift do our bidding,
// which works because the signature is truth to @_silgen_name
@_silgen_name("swift_dynamicCastMetatype")
private func _getResilientPointer<T>(
    _ type: Any.Type,
    _ duplicate: Any.Type
) -> T

///
/// Given some metadata, this will pass it through a cast in C++
/// to give back a pointer to the metadata, and allow it to by bound to
/// a custom type. This allows asan to be happy about reading what could
/// potentially be out of bounds memory.
///
/// - Parameters:
///   - metadata: The metadata to desanitize from asan.
///
/// - Returns: A pointer to whatever type you want to bind the metadata to.
///
@_silgen_name("swift_desanitizeMetadata")
public func swift_desanitizeMetadata<T>(_ metadata: Any.Type) -> UnsafeMutablePointer<T> {
    return _getResilientPointer(metadata, metadata)
}
