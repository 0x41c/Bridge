// ===----------------------------------------------------------------------===
//
//  RuntimeModifiable.swift
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

typealias TupleType = (Bool, Int)

struct ConformingStruct: RuntimeModifiable {
    var bool: Bool = true
    var string: String = "A"
    var number: Int = 1
}

struct NonConformingStruct {
    var bool: Bool = true
    var string: String = "A"
    var number: Int = 1
}

enum ExpectationType: Comparable {
    case read
    case write
}

final class KeyPathListableTests: XCTestCase {

    private var _backingTestObject: Any = false // Initialization stub

    var currentObjectDescription: Any {
        get {
            return String(describing: type(of: _backingTestObject))
        }
        set {
            _backingTestObject = newValue
        }
    }

    var currentTestType: ExpectationType = .read

    func testReadWriteFunctionality() {
        print("\n")
        let typeErasedNonConformingStruct: Any = NonConformingStruct()
        let structures: [AnyRuntimeModifiable] = [
            ConformingStruct(), RuntimeModifiableBuilder.from(anyValue: typeErasedNonConformingStruct)
        ]
        typealias CaseTuple = (String, Any.Type, Any)
        var testCases = [ExpectationType: [CaseTuple]]()
        testCases[.read] = [("bool", Bool.self, true), ("string", String.self, "A"), ("number", Int.self, 1)]
        testCases[.write] = [("bool", Bool.self, false), ("string", String.self, "B"), ("number", Int.self, 0)]
        // testCases = testCases.sorted { $0.key > $1.key }
        for var structure in structures {
            currentObjectDescription = structure
            print("- \(currentObjectDescription):")
            for (testType, tupleList) in testCases {
                currentTestType = testType
                for testCase in tupleList {
                    conductTest(
                        member: testCase.0,
                        type: testType,
                        currentValue: structure.get(testCase.0, testCase.1 as? AnyHashable.Type)!,
                        expectedValue: testCase.2 as? AnyHashable
                    ) {
                        structure.set(testCase.0, testCase.2)
                        return structure.get(testCase.0, testCase.1 as? AnyHashable.Type)!
                    }
                }
                structure.set("bool", true)
                structure.set("string", "A")
                structure.set("number", 1)
                print("\n")
            }
            print("\n")
        }
        waitForExpectations(timeout: 5)
    }

    func specializedExpectation(type: ExpectationType, expected: Any?, _ member: String) -> XCTestExpectation {
        let description = "  - (\(currentTestType == .read ? "read" : "write")) Testing member '\(member)' is '\(expected!)'"
        print(description)
        return expectation(
            description: description
        )
    }

    func fulfillExpectation(_ expectation: XCTestExpectation) {
        print("    - Success: ✅")
        expectation.fulfill()
    }

    func conductTest(
        member: String,
        type: ExpectationType,
        currentValue: AnyHashable,
        expectedValue: AnyHashable? = nil,
        setter: (() -> AnyHashable)? = nil
    ) {
        guard expectedValue != nil else {
            return
        }
        let expectation = specializedExpectation(type: type, expected: expectedValue, member)
        if type == .read {
            if currentValue == expectedValue! {
                fulfillExpectation(expectation)
                return
            }
        } else {
            guard setter != nil else {
                return
            }
            if setter!() == expectedValue! {
                fulfillExpectation(expectation)
                return
            }
        }
        print("     - Failure: ❌")
    }

}
