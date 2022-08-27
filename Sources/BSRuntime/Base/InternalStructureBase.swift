// ===----------------------------------------------------------------------===
//
//  MetadataStructureBase.swift
//  BSRuntime
//
//  Created by 0x41c on 2022-02-16.
//
// ===----------------------------------------------------------------------===
//
//  Copyright 2022 0x41c
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
// ===----------------------------------------------------------------------===

private var _mutatingMetadataCache: [UnsafeRawPointer] = [UnsafeRawPointer]()

@dynamicMemberLookup
public protocol InternalStructureBase: RuntimeModifiable {}

///
/// Base structure to which all metadata structures conform.
///
/// This regulates mutating access to the structure, while providing
/// an easy calling convention.
///
public extension InternalStructureBase {

    fileprivate var mutable: Bool {
        mutating get {
            return _mutatingMetadataCache.contains(&self)
        }
        set {
            if newValue && !_mutatingMetadataCache.contains(&self) {
                _mutatingMetadataCache.append(&self)
            } else if !newValue && _mutatingMetadataCache.contains(&self) {
                _mutatingMetadataCache.remove(at: _mutatingMetadataCache.firstIndex(of: &self)!)
            }
        }
    }

    ///
    /// Enables mutable access to the underlying memory located
    /// in the structure.
    ///
    mutating func beginUnsafeMutableAccess() {
        if !mutable {
            mutable = true
        }
    }

    ///
    /// Disables mutable access to the underlying memory located
    /// in the structure.
    ///
    mutating func endUnsafeMutableAccess() {
        if mutable {
            mutable = false
        }
    }

    subscript<T>(dynamicMember member: String) -> T? {
        get {
            return self.get(member) ?? self.get("_" + member)
        }
        set {
            guard newValue != nil, mutable == true else { return }
            if self.get(member) != nil {
                self.set(member, newValue!)
            } else if self.get("_" + member) != nil {
                self.set("_" + member, newValue!)
            }
        }
    }
}
