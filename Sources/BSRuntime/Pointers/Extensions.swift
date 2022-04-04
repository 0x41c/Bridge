// ===----------------------------------------------------------------------===
//
//  Extensions.swift
//  BSRuntime
//
//  Created by 0x41c on 2022-03-11.
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

extension UnsafePointer {
    
    /// Shortcut for a mutating pointer
    var mutating: UnsafeMutablePointer<Pointee> {
        UnsafeMutablePointer(mutating: self)
    }
    
    var raw: UnsafeRawPointer {
        UnsafeRawPointer(self)
    }
    
    var trailing: UnsafeRawPointer {
        (self + MemoryLayout<Pointee>.size).raw
    }
    
    func offset(
        by offset: Int
    ) -> UnsafePointer<Pointee> {
        advanced(by: MemoryLayout<Pointee>.size * offset)
    }
    
}

extension UnsafePointer where Pointee == CChar {
    
    /// Shortcut to get the string from a CString.
    var string: String {
        String(cString: self)
    }
    
}

extension UnsafeRawPointer {
    
    var mutating: UnsafeMutableRawPointer {
        UnsafeMutableRawPointer(mutating: self)
    }
    
    func offset(
        by offset: Int
    ) -> UnsafeRawPointer {
        advanced(by: MemoryLayout<Int>.size * offset)
    }
    
}

extension UnsafeMutablePointer {
    
    var raw: UnsafeMutableRawPointer {
        UnsafeMutableRawPointer(self)
    }
    
    var trailing: UnsafeMutableRawPointer {
        (self + MemoryLayout<Pointee>.size).raw
    }
    
    func offset(
        by offset: Int
    ) -> UnsafeMutablePointer<Pointee> {
        advanced(by: MemoryLayout<Int>.size * offset)
    }
    
}

extension UnsafeMutableRawPointer {
    
    func offset(
        by offset: Int
    ) -> UnsafeMutableRawPointer {
        advanced(by: MemoryLayout<Int>.size * offset)
    }
    
}
