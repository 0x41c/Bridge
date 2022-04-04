// ===----------------------------------------------------------------------===
//
//  ReinterpretCast.c
//  BSRuntime
//
//  Created by 0x41c on 2022-03-09.
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
//   Hook into this function whenever you need to bypass asan
//   for out-of-bounds casting. To hook this, use @_silgen_name
//   and create a custom signature for this. During runtime, it should
//   use the signature and perfom basically a reinterpretCast
//   on the passthrough value.
//
// ===----------------------------------------------------------------------===

#include "include/ReinterpretCast.h"

uintptr_t swift_reinterpretCast(uintptr_t pointer) {
    return pointer;
}
