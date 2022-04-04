// ===----------------------------------------------------------------------===
//
//  PointerAuth.h
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

#ifndef PointerAuth_h
#define PointerAuth_h

#ifndef SWIFT_INLINE
#define SWIFT_INLINE __attribute__((always_inline))
#endif

#if !__has_feature(ptrauth_calls)

#define __builtin_ptrauth_strip(__pointer, __key) __pointer
#define __builtin_ptrauth_blend_discriminator(__pointer, __integer) ((uintptr_t)0)
#define __builtin_ptrauth_sign_constant(__value, __key, __data) __value
#define __builtin_ptrauth_sign_unauthenticated(__value, __key, data) __value
#define __builtin_ptrauth_auth_and_resign(__value, __old_key, __old_ptr, __new_ptr, __new_data) __value
#define __builtin_ptrauth_auth(__value, __old_key, __old_data) __value
#define __builtin_ptrauth_string_discriminator(__string) ((uint64_t)0)
#define __builtin_ptrauth_sign_generic_data(__value, __data) __value

#endif

#import <stdint.h>

typedef uint32_t _ptrauth_generic_signature_t;

SWIFT_INLINE const void *__ptrauth_strip(const void *ptr, uint32_t key);
SWIFT_INLINE uintptr_t __ptrauth_blend_discriminator(const void *ptr, uint64_t integer);
SWIFT_INLINE const void *__ptrauth_sign_constant(const void *value, uint32_t key, uint64_t data);
SWIFT_INLINE const void *__ptrauth_sign_unauthenticated(const void *value, uint32_t key, uint64_t data);
SWIFT_INLINE const void *__ptrauth_auth_and_resign(const void *value, uint32_t oldKey, uint64_t oldData, uint32_t newKey, uint64_t newData);
SWIFT_INLINE const void *__ptrauth_auth_function(const void *value, uint32_t oldKey, uint64_t oldData);
SWIFT_INLINE const void *__ptrauth_auth_data(const void *value, uint32_t oldKey, uint64_t oldData);
SWIFT_INLINE uint64_t __ptrauth_string_discriminator(char *string);
SWIFT_INLINE _ptrauth_generic_signature_t __ptrauth_sign_generic_data(const void *value, uint64_t data);

#endif /* PointerAuth_h */
