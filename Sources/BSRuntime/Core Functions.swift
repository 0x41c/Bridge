// ===----------------------------------------------------------------------===
//
//  CoreFunctions.swift
//  BSRuntime
//
//  Created by 0x41c on 2022-02-23.
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

@_silgen_name("$ss24_forEachFieldWithKeyPath2of7options4bodySbxm_s01_bC7OptionsVSbSPys4Int8VG_s07PartialeF0CyxGtXEtlF")
internal func _forEachFieldWithKeyPath<Root>(
    of type: Root.Type,
    options: UnsafePointer<_EachFieldOptions>,
    body: (UnsafePointer<CChar>, PartialKeyPath<Root>) -> Bool
) -> Bool

@_silgen_name("swift_reinterpretCast")
internal func _autoReinterpretCast<T>(
    _ val: Any
) -> UnsafePointer<T>
