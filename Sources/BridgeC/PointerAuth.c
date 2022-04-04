// ===----------------------------------------------------------------------===
//
//  PointerAuth.c
//  BridgeC
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

#include <stdint.h>
#include "include/PointerAuth.h"

SWIFT_INLINE const void *__ptrauth_strip(const void *ptr, uint32_t key) {
    return __builtin_ptrauth_strip(ptr, key);
}

SWIFT_INLINE uintptr_t __ptrauth_blend_discriminator(const void *ptr, uint64_t integer) {
    return __builtin_ptrauth_blend_discriminator(ptr, integer);
}

SWIFT_INLINE const void *__ptrauth_sign_constant(const void *value, uint32_t key, uint64_t data) {
    return __builtin_ptrauth_sign_constant(value, key, data);
}

SWIFT_INLINE const void *__ptrauth_sign_unauthenticated(const void *value, uint32_t key, uint64_t data) {
    return __builtin_ptrauth_sign_unauthenticated(value, key, data);
}

SWIFT_INLINE const void *__ptrauth_auth_and_resign(const void *value, uint32_t oldKey, uint64_t oldData, uint32_t newKey, uint64_t newData) {
    return __builtin_ptrauth_auth_and_resign(value, oldKey, oldData, newKey, newData);
}

SWIFT_INLINE const void *__ptrauth_auth_function(const void *value, uint32_t oldKey, uint64_t oldData) {
    return __builtin_ptrauth_auth_and_resign(value, oldKey, oldData, 0, 0);
}

SWIFT_INLINE const void *__ptrauth_auth_data(const void *value, uint32_t oldKey, uint64_t oldData) {
    return __builtin_ptrauth_auth(value, oldKey, oldData);
}

SWIFT_INLINE uint64_t __ptrauth_string_discriminator(char *string) {
    return __builtin_ptrauth_string_discriminator(string);
}

SWIFT_INLINE _ptrauth_generic_signature_t __ptrauth_sign_generic_data(const void *value, uint64_t data) {
    return __builtin_ptrauth_sign_generic_data(value, data);
}
