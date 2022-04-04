// ===----------------------------------------------------------------------===
//
//  EnumMetadata.swift
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

enum Cool {
    case One
}

enum Cool2 {
    case One
    case Two
}


enum Cool3 {
    case One
    case Two
    case Three
}

class EnumMetadataTests: XCTestCase {
    func testCasting() {
        let enumTypes: [Any.Type] = [
            Cool.self, Cool2.self, Cool3.self
        ]
        for enumType in enumTypes {
            print(EnumMetadata(withType: enumType))
        }
    }
}
