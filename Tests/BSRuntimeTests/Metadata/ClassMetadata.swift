import XCTest
@testable import BSRuntime

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
            _ = ClassMetadata(withType: `class`)
        }
    }

}
