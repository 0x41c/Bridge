//
//  RuntimeModifiable.swift
//  
//
//  Created by 0x41c on 2022-02-16.
//

import Foundation

// See https://forums.swift.org/t/getting-keypaths-to-members-automatically-using-mirror/21207

///
/// A protocol to which all `RuntimeModifiable` structures conform
///
public protocol AnyRuntimeModifiable {

    ///
    /// Dynamically retrieves a stored property value defined on this struct.
    ///
    /// Depending on the need, you can optionally use the `type` parameter to implicity define
    /// the generic return value.
    ///
    /// - Parameters:
    ///   - member: The name of the member you would like to retreive.
    ///   - type: Optionally, the type of the member you would like to retreive.
    ///
    /// - Returns: The dynamically retreived member if found. Otherwise, `nil`
    ///
    func get<MemberType>(
        _ member: String,
        _ type: MemberType.Type?
    ) -> MemberType?

    ///
    /// Dynamically retrieves a stored property value defined on this struct.
    ///
    /// Depending on the need, you can optionally use the `type` parameter to implicity define
    /// the generic return value.
    ///
    /// - Parameters:
    ///   - member: The name of the member you would like to retreive.
    ///   - type: Optionally, the type of the member you would like to retreive.
    ///
    /// - Returns: The dynamically retreived member if found. Otherwise, `nil`
    ///
    mutating func set<MemberType>(
        _ member: String,
        _ newValue: MemberType
    )

    ///
    /// Creates an interface for getting and setting members of the provided value.
    ///
    /// The provided value must be a struct, or else this will fail.
    ///
    /// - Parameters:
    ///   - anyValue: The struct to read and modify
    ///   - returnType: The return type of the body, which defaults to `AnyRuntimeModifiable`
    ///   - body: A body with the  `AnyRuntimeModifiable` passed in. This is ommitted by default,
    ///           but can be added when needed.
    ///
    static func from(
        anyValue: Any
    ) -> AnyRuntimeModifiable

}

extension AnyRuntimeModifiable {

    public static func from(
        anyValue: Any
    ) -> AnyRuntimeModifiable {
        func _general<T>(casted: T) -> AnyRuntimeModifiable {
            return ProxiedRuntimeModifiable<T>(value: casted)
        }
        return _openExistential(anyValue, do: _general)
    }

}

///
/// A type to create a RuntimeModifiable from.
///
/// `get` and `set` functions can't be called because this struct
/// has no initializers.
///
@frozen
public struct RuntimeModifiableBuilder: AnyRuntimeModifiable {

    public func get<MemberType>(_ member: String, _ type: MemberType.Type?) -> MemberType? {
        fatalError()
    }

    public mutating func set<MemberType>(_ member: String, _ newValue: MemberType) {
        fatalError()
    }

}

///
/// A structure that allows the dynamic get/set of a swift structs stored properties.
///
/// This exists for the purpose of internal use, but is public for limited use as seen fit.
///
public protocol RuntimeModifiable: AnyRuntimeModifiable {

    ///
    /// All the keypaths belonging to the structure.
    ///
    /// Every variable marked with `let` or `var` wil be included in this list. However,
    /// computed variables are not on the list as the API retreiving them doesn't have
    /// enough metadata to do so.
    ///
    static var allKeyPaths: [String: PartialKeyPath<Self>] { get }

    ///
    /// All the writable key paths belonging to the structure
    ///
    /// A filtered version of `allKeyPaths` that only includes ones that are castable
    /// to `WritableKeyPath`. This directly corelates to the `var`s defined on the
    /// structure.
    ///
    var writableKeyPaths: [String: PartialKeyPath<Self>] { get }

    ///
    /// All the read only keypaths belonging to the structure
    ///
    /// A filtered version of `allKeyPaths` that only includes ones that aren't castable
    /// to `WritableKeyPath`. This directly corelates to the `let`s defined on the
    /// structure.
    ///
    var readOnlyKeyPaths: [String: PartialKeyPath<Self>] { get }

}

public extension RuntimeModifiable {

    static var allKeyPaths: [String: PartialKeyPath<Self>] {
        return getKeypaths(ofType: Self.self)
    }

    var writableKeyPaths: [String: PartialKeyPath<Self>] {
        return Self.allKeyPaths.filter { _, val in
            String(describing: val).contains("WritableKeyPath")
        }
    }

    var readOnlyKeyPaths: [String: PartialKeyPath<Self>] {
        return Self.allKeyPaths.filter { _, val in
            !String(describing: val).contains("WritableKeyPath")
        }
    }

    func get<MemberType>(
        _ member: String,
        _ type: MemberType.Type? = nil
    ) -> MemberType? {
        guard let keypath = Self.allKeyPaths[member] else {
            return nil
        }
        return self[keyPath: keypath] as? MemberType
    }

    mutating func set<MemberType>(
        _ member: String,
        _ newValue: MemberType
    ) {
        guard let keypath = writableKeyPaths[member] else {
            return
        }
        if MemberType.self == Any.self {
            func _generic<U>(_:U) {
                guard let internalCasted = newValue as? U else {
                    return
                }
                self[keyPath: keypath as! WritableKeyPath] = internalCasted
            }
            _openExistential(self[keyPath: keypath], do: _generic)
        } else {
            self[keyPath: keypath as! WritableKeyPath] = newValue
        }
    }

}

///
/// A structure that takes any other structure and allows the dynamic get/set of it's stored properties
///
@dynamicMemberLookup
struct ProxiedRuntimeModifiable<T>: AnyRuntimeModifiable {

    var value: T

    ///
    /// All the keypaths belonging to the structure.
    ///
    /// Every variable marked with `let` or `var` wil be included in this list. However,
    /// computed variables are not on the list as the API retreiving them doesn't have
    /// enough metadata to do so.
    ///
    var allKeyPaths: [String: PartialKeyPath<T>] {
        return getKeypaths(ofType: T.self)
    }

    ///
    /// All the writable key paths belonging to the structure
    ///
    /// A filtered version of `allKeyPaths` that only includes ones that are castable
    /// to `WritableKeyPath`. This directly corelates to the `var`s defined on the
    /// structure.
    ///
    var writableKeyPaths: [String: PartialKeyPath<T>] {
        return allKeyPaths.filter { _, val in
            String(describing: val).contains("WritableKeyPath")
        }
    }

    ///
    /// All the read only keypaths belonging to the structure
    ///
    /// A filtered version of `allKeyPaths` that only includes ones that aren't castable
    /// to `WritableKeyPath`. This directly corelates to the `let`s defined on the
    /// structure.
    ///
    var readOnlyKeyPaths: [String: PartialKeyPath<T>] {
        return allKeyPaths.filter { _, val in
            !String(describing: val).contains("WritableKeyPath")
        }
    }

    func get<MemberType>(
        _ member: String,
        _ type: MemberType.Type? = nil
    ) -> MemberType? {
        guard let keypath = allKeyPaths[member] else {
            return nil
        }
        return value[keyPath: keypath] as? MemberType
    }

    mutating func set<MemberType>(
        _ member: String,
        _ newValue: MemberType
    ) {
        guard let keypath = writableKeyPaths[member] else {
            return
        }
        if MemberType.self == Any.self {
            func _generic<U>(_:U) {
                guard let internalCasted = newValue as? U else {
                    return
                }
                value[keyPath: keypath as! WritableKeyPath] = internalCasted
            }
            _openExistential(value[keyPath: keypath], do: _generic)
        } else {
            value[keyPath: keypath as! WritableKeyPath] = newValue
        }
    }

    subscript<MemberType>(dynamicMember member: String) -> MemberType? {
        get {
            return get(member)
        }
        set {
            set(member, newValue)
        }
    }

}

///
/// Internal bit mask for determining options passed into the other
/// internal function, ` _forEachFieldWithKeyPath`
///
internal struct _EachFieldOptions: OptionSet {

    var rawValue: UInt32

    public init(rawValue: UInt32) {
        self.rawValue = rawValue
    }

    ///
    /// Require the top-level type to be a class.
    ///
    /// If this is not set, the top-level type is required to be a struct or
    /// tuple.
    ///
    public static var classType = _EachFieldOptions(rawValue: 1 << 0)

    ///
    /// Ignore fields that can't be introspected.
    ///
    /// If not set, the presence of things that can't be introspected causes
    /// the function to immediately return `false`.
    ///
    public static var ignoreUnknown = _EachFieldOptions(rawValue: 1 << 1)

}


///
/// Gets all the keypaths of a type
///
private func getKeypaths<T>(
    ofType _type: T.Type
) -> [String: PartialKeyPath<T>] {
    var membersToKeyPaths = [String: PartialKeyPath<T>]()
    var options: _EachFieldOptions = swift_isClassType(T.self) ? [.ignoreUnknown, .classType] : [.ignoreUnknown]
    _ = _forEachFieldWithKeyPath(of: T.self, options: &options) { name, keypath in
        membersToKeyPaths[String(cString: name)] = keypath as PartialKeyPath
        return true
    }
    return membersToKeyPaths
}
