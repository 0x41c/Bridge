// ===----------------------------------------------------------------------===
//
//  ContextDescriptor.swift
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

import ptrauth

public protocol AnyContextDescriptor {
    
    var flags: ContextDescriptor.Flags { get }
    
}

extension AnyContextDescriptor {
    
    public var flags: ContextDescriptor.Flags { _autoReinterpretCast(self).pointee }
    
    
    public var moduleDescriptor: ModuleDescriptor { checkKind(.module)
        return _autoReinterpretCast(self).pointee
    }
    
    public var extensionDescriptor: ExtensionDescriptor { checkKind(.extension)
        return _autoReinterpretCast(self).pointee
    }
    
    public var anonymousDescriptor: ContextDescriptor { checkKind(.anonymous)
        return _autoReinterpretCast(self).pointee
    }
    
    public var protocolDescriptor: ProtocolDescriptor { checkKind(.protocol)
        return _autoReinterpretCast(self).pointee
    }
    
    public var classDescriptor: ClassDescriptor { checkKind(.class)
        return _autoReinterpretCast(self).pointee
    }
    
    public var structDescriptor: StructDescriptor { checkKind(.struct)
        return _autoReinterpretCast(self).pointee
    }
    
    public var enumDescriptor: EnumDescriptor { checkKind(.enum)
        return _autoReinterpretCast(self).pointee
    }
    
    
    private func checkKind(_ kind: ContextDescriptor.Kind) {
        guard flags.kind == kind else {
            fatalError("Tried to get \(kind) descriptor from descriptor of kind \"\(flags.kind)\"")
        }
    }
}

public struct ContextDescriptor: AnyContextDescriptor, StructureRepresentation {
    
    public struct InternalRepresentation: InternalStructureBase {
        private var _flags: Flags
        private var _parent: RelativePointer<Int32, InternalRepresentation>
    }
    
    public var `_`: UnsafeMutablePointer<InternalRepresentation>
    
    public var parent: AnyContextDescriptor? {
        let _parent: RelativePointer<Int32, Void> = `_`.pointee.parent!
        if _parent.isNull {
            return nil
        }
        
        return _autoReinterpretCast(_parent.directOffset).pointee
    }
}

public extension ContextDescriptor {
    
    struct Flags: OptionSet {
        
        public var rawValue: UInt32
        
        static let unique = Flags(rawValue: 1 << 6)
        static let generic = Flags(rawValue: 1 << 7)
        
        public var kind: Kind {
            Kind(rawValue: Int(rawValue) & 0x1F)!
        }
        
        public var version: UInt8 {
            UInt8((rawValue >> 0x8) & 0xFF)
        }
        
        var kindSpecificFlags: UInt16 {
            UInt16((rawValue >> 0x10) & 0xFFFF)
        }
        
        public init(rawValue: UInt32) {
            self.rawValue = rawValue
        }
        
    }
}

public extension ContextDescriptor {
    
    enum Kind: Int {
        
        case module = 0
        case `extension` = 1
        case anonymous = 2
        case `protocol` = 3
        case opaqueType = 4
        case `class` = 16
        case `struct` = 17
        case `enum` = 18
        
    }
    
}

extension ContextDescriptor: Equatable {}


func getContextDescriptor(
    from pointer: UnsafeRawPointer
) -> AnyContextDescriptor {
    _autoReinterpretCast(pointer).pointee
}

