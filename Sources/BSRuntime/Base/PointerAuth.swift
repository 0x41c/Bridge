// ===----------------------------------------------------------------------===
//
//  PointerAuth.swift
//  BSRuntime
//
//  Created by 0x41c on 2022-03-02.
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
//
// TODO: Rewrite documentation to be clear as apple's ptrauth docs are vague.
//
// ===----------------------------------------------------------------------===

import ptrauth
import BridgeC
import Foundation

///
/// A namespace for the pointer authentication builtins.
///
/// This should be considered an extension of the ptrauth module.
///
public struct PointerAuthentication {
    
    ///
    /// Strip the signature from a value without authenticating it.
    ///
    /// If the value is a function pointer, the result will not be a
    /// legal function pointer because of the missing signature, and
    /// attempting to call it will result in an authentication failure.
    ///
    /// - Parameters:
    ///   - pointer: The value to strip the signature from.
    ///   - key: The `ptrauth_key` used to stip the signature.
    ///
    /// - Returns: The stripped pointer.
    ///
    @inline(__always)
    public static func strip(
        _ pointer: UnsafeRawPointer,
        _ key: ptrauth_key
    ) -> UnsafeRawPointer {
        __ptrauth_strip(
            pointer,
            key.rawValue
        )
    }
    
    ///
    /// Blend a pointer and a small integer to form a new extra-data
    /// discriminator.  Not all bits of the inputs are guaranteed to
    /// contribute to the result.
    ///
    /// On ARM64, only the low 16 bits of the integer will be considered.
    ///
    /// - Parameters:
    ///   - pointer: The pointer to perform the operation on.
    ///   - integer: The integer to blend into the pointer.
    ///
    /// - Returns: The new extra-data-discriminator.
    ///
    @inline(__always)
    public static func blendDiscriminator(
        _ pointer: UnsafeRawPointer,
        _ integer: UInt64
    ) -> UInt {
        __ptrauth_blend_discriminator(
            pointer,
            integer
        )
    }
    
    ///
    /// Add a signature to the given pointer value using a specific key,
    /// using the given extra data as a salt to the signing process.
    ///
    /// - Parameters:
    ///   - value: The value pointer to sign.
    ///   - key: The key to sign the pointer with.
    ///   - data: Extra data to be used as a salt.
    ///
    /// - Returns: The constant passed in through `value`.
    ///
    @inline(__always)
    public static func signConstant(
        _ value: UnsafeRawPointer,
        _ key: ptrauth_key,
        _ data: UInt64
    ) -> UnsafeRawPointer {
        __ptrauth_sign_constant(
            value,
            key.rawValue,
            data
        )
    }
    
    ///
    /// Add a signature to the given pointer value using a specific key,
    /// using the given extra data as a salt to the signing process.
    ///
    /// This operation does not authenticate the original value and is
    /// therefore potentially insecure if an attacker could possibly
    /// control that value.
    ///
    /// - Parameters:
    ///   - value: The value pointer to sign.
    ///   - key: The key to sign the pointer with.
    ///   - data: Extra data to be used as a salt.
    ///
    /// - Returns: The constant passed in through `value`.
    ///
    @inline(__always)
    public static func signUnauthenticated(
        _ value: UnsafeRawPointer,
        _ key: ptrauth_key,
        _ data: UInt64
    ) -> UnsafeRawPointer {
        __ptrauth_sign_unauthenticated(
            value,
            key.rawValue,
            data
        )
    }
    
    ///
    /// Authenticate a pointer using one scheme and resign it using
    /// another.
    ///
    /// If the result is subsequently authenticated using the new scheme,
    /// that authentication is gauranteed to fail if and only if the initial
    /// authentication failed.
    ///
    /// This operation is guarunteed to not leave the intermediate value
    /// available for attack before it is re-signed.
    ///
    /// - Parameters:
    ///   - value: The value pointer to sign.
    ///   - oldKey: The old `ptrauth_key` the value was signed with.
    ///   - oldData: The old salt used in signing the value pointer.
    ///   - newKey: The new key to resign the value with.
    ///   - newData: New salt to be used in signing the value pointer.
    ///
    /// - Returns: The newly signed value.
    ///
    @inline(__always)
    public static func authAndResign(
        _ value: UnsafeRawPointer,
        _ oldKey: ptrauth_key,
        _ oldData: UInt64,
        _ newKey: ptrauth_key,
        _ newData: UInt64
    ) -> UnsafeRawPointer {
        __ptrauth_auth_and_resign(
            value,
            oldKey.rawValue,
            oldData,
            newKey.rawValue,
            newData
        )
    }
    
    ///
    /// Authenticate a pointer using one scheme and resign it as a C
    /// function pointer.
    ///
    /// If the result is subsequently authenticated using the new scheme,
    /// that authentication is gauranteed to fail if and only if the initial
    /// authentication failed.
    ///
    /// This operation is guarunteed to not leave the intermediate value
    /// available for attack before it is re-signed.
    ///
    /// - Parameters:
    ///   - value: The value to resign as a C function pointer.
    ///   - oldKey: The old `ptrauth_key` the value was signed with.
    ///   - oldData: The old salt used in signing the value pointer.
    ///
    /// - Returns: The authenticated resigned value pointer signed
    ///            as a C function pointer.
    ///
    @inline(__always)
    public static func authFunction(
        _ value: UnsafeRawPointer,
        _ oldKey: ptrauth_key,
        _ oldData: UInt64
    ) -> UnsafeRawPointer {
        __ptrauth_auth_and_resign(
            value,
            oldKey.rawValue,
            oldData,
            ptrauth_key_function_pointer.rawValue,
            0
        )
    }
    
    ///
    /// Authenticate a data pointer
    ///
    /// If the authentication fails, dereferencing the resulting
    /// pointer will likewise fail.
    ///
    /// - Parameters:
    ///   - value: The data pointer to authenticate.
    ///   - oldKey: The `ptrauth_key` used to sign the pointer.
    ///   - oldData: The old salt used in signing the pointer.
    ///
    @inline(__always)
    public static func authData(
        _ value: UnsafeRawPointer,
        _ oldkey: ptrauth_key,
        _ oldData: UInt64
    ) -> UnsafeRawPointer {
        __ptrauth_auth_data(
            value,
            oldkey.rawValue,
            oldData
        )
    }
    
    ///
    /// Return an extra-discriminator value which can validly be used
    /// as the second argument to `blendDiscriminator`.
    ///
    /// - Parameters:
    ///   - string: The string to generate the discriminator from.
    ///
    /// - Returns: The custom discriminator generated from the string.
    ///
    @inline(__always)
    public static func stringDiscriminator(
        _ string: String
    ) -> UInt64 {
        __ptrauth_string_discriminator(
            UnsafeMutablePointer(mutating: (string as NSString).utf8String)
        )
    }
    
    ///
    /// Compute a full pointer-width generic signature for the given
    /// value, using the given data as a salt.
    ///
    /// This generic signature is process independant, but may not be
    /// consistent accross reboots.
    ///
    /// This can be used to validate the integrity of arbitrary data by storing
    /// the a signature for that data together with it. Because the signature
    /// is pointer-sized, if the signature matches the result of re-signing the
    /// current data, a match provides very strong evidence that the data
    /// has not been corrupted.
    ///
    /// - Parameters:
    ///   - value: The generic data pointer to generate the signature for.
    ///   - data: Extra data to use as a salt in the signing of the generic data.
    ///
    /// - Returns: A `ptrauth_generic_signature_t`
    ///
    @inline(__always)
    public static func signGenericData(
        _ value: UnsafeRawPointer,
        _ data: UInt64
    ) -> ptrauth_generic_signature_t {
        ptrauth_generic_signature_t(
            __ptrauth_sign_generic_data(
                value,
                data
            )
        )
    }
    
}


