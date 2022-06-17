// ===----------------------------------------------------------------------===
//
//  ClassMetadata.swift
//  BSRuntimeTests
//
//  Created by 0x41c on 2022-06-13.
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


import XCTest
import BSRuntime

// MARK: Test Structures


class Class {
    
    let int: Int
    let bool: Bool
    let string: String
    
    init(a: Int, b: Bool, c: String) {
        int = a
        bool = b
        string = c
    }
    
}

class GenericClass<A, B> {
    
    let a: A
    let b: B
    
    init(a: A, b: B) {
        self.a = a
        self.b = b
    }
    
}

class ResilientClass<A>: JSONEncoder {
    
    let a: A
    
    init(a: A) {
        self.a = a
    }
    
}


// MARK: Tests

extension BSRuntimeTests {
    
    func testClassMetadata() {
        
        let metadata = ClassMetadata(withType: Class.self)
        
        // XCTAssertEqual(metadata.superclass, _TtCs12_SwiftObject, "Superclass should be SwiftObject")
        XCTAssertEqual(metadata.kind, .class, "Class kind should be .class")
        XCTAssertNotNil(metadata.superclass, "Class should always have a superclass")
        XCTAssertEqual(metadata.flags.rawValue, 2, "Class should be swiftPreStableABI (2)")
        XCTAssertEqual(metadata.instanceAddressPoint, 0, "Class instance address point should be zero")
        XCTAssertEqual(metadata.instanceSize, 48, "Class instance size should be 48")
        XCTAssertEqual(metadata.instanceAlignment, 7, "Class instance alignment should be 7")
        XCTAssertEqual(metadata.classObjectSize, 128, "Class size should be 128")
        XCTAssertEqual(metadata.classObjectAddressPoint, 16, "Class object address point should be 16")
        XCTAssert(metadata.type == Class.self, "ClassMetadata type should cast back to Class")
        
        let vwt = metadata.valueWitnessTable
        typealias ClassLayout = MemoryLayout<Class>
        
        XCTAssertEqual(vwt.size, ClassLayout.size, "Class VWT should show the same size as MemoryLayout")
        XCTAssertEqual(vwt.stride, ClassLayout.stride, "Class VWT should show the same stride as MemoryLayout")
        XCTAssertEqual(vwt.extraInhabitantCount, 2147483647, "Class VWT should have an extraInhabitantCount of '2147483647'")
        XCTAssertEqual(vwt.flags.rawValue, 65543, "Class VWT should have the flags '65543'")
        
    }
    
    func testGenericClassMetadata() {
        
        typealias Generic = GenericClass<Int, Bool>
        let metadata = ClassMetadata(withType: Generic.self)
        
        _ = metadata
        
    }
    
}
