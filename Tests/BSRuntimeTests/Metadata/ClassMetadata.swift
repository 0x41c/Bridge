// ===----------------------------------------------------------------------===
//
//  ClassMetadata.swift
//  BSRuntimeTests
//
//  Created by 0x41c on 2022-03-12.
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
@testable import BSRuntime

// TODO: Properly validate the metadata created with what is read by library.

class SomeClass {}
class SomeClassInherited: SomeClass {}
class SomeNSObject: NSObject {}
class InheritingNSObject: SomeNSObject {}

final class ClassMetadataTests: XCTestCase {

    func testCasting() {
        let classes: [Any.Type] = [
            SomeClass.self, SomeClassInherited.self, SomeNSObject.self, InheritingNSObject.self
        ]
        for `class` in classes {
            // This accesses `_` which will crash if it got messed up. Allows me to spot it faster XD
            let md = ClassMetadata(withType: `class`)
            print(md)
            print(md.nominalTypeDescriptor)
        }
    }

}
