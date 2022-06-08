// ===----------------------------------------------------------------------===
//
//  RelativePointer.swift
//  BSRuntime
//
//  Created by 0x41c on 2022-03-13.
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


struct RelativePointer<Offset: FixedWidthInteger, Pointee> {
    private var _offset: Offset
    
    var isNull: Bool { _offset == 0 }
    
    var directOffset: Pointee {
        let ourPtr: UnsafePointer<Self> = _autoReinterpretCast(self)
        return ourPtr.raw.offset(by: Int(_offset)).assumingMemoryBound(to: Pointee.self).pointee
    }
    
    var indirectOffset: UnsafePointer<Pointee> {
        _autoReinterpretCast(self).offset(by: Int(_offset))
    }
}

extension RelativePointer where Pointee == CChar {
    
    var string: String {
        _autoReinterpretCast(self).offset(by: Int(_offset)).string
    }
    
}
