//
//  Bridge.swift
//  AllPatterns
//
//  Created by Austin's Macbook Pro M3 on 11/8/24.
//

import Foundation
import XCTest

/// The Abstraction defines the interface for the "control" part of the two
/// class hierarchies. It maintains a reference to an object of the
/// Implementation hierarchy and delegates all of the real work to this object.
private class Abstraction {

    fileprivate var implementation: Implementation

    init(_ implementation: Implementation) {
        self.implementation = implementation
    }

    func operation() -> String {
        let operation = implementation.operationImplementation()
        return "Abstraction: Base operation with:\n" + operation
    }
}

/// You can extend the Abstraction without changing the Implementation classes.
private class ExtendedAbstraction: Abstraction {

    override func operation() -> String {
        let operation = implementation.operationImplementation()
        return "ExtendedAbstraction: Extended operation with:\n" + operation
    }
}

/// The Implementation defines the interface for all implementation classes. It
/// doesn't have to match the Abstraction's interface. In fact, the two
/// interfaces can be entirely different. Typically the Implementation interface
/// provides only primitive operations, while the Abstraction defines higher-
/// level operations based on those primitives.
private protocol Implementation {

    func operationImplementation() -> String
}

/// Each Concrete Implementation corresponds to a specific platform and
/// implements the Implementation interface using that platform's API.
private class ConcreteImplementationA: Implementation {

    func operationImplementation() -> String {
        return "ConcreteImplementationA: Here's the result on the platform A.\n"
    }
}

private class ConcreteImplementationB: Implementation {

    func operationImplementation() -> String {
        return "ConcreteImplementationB: Here's the result on the platform B\n"
    }
}

/// Except for the initialization phase, where an Abstraction object gets linked
/// with a specific Implementation object, the client code should only depend on
/// the Abstraction class. This way the client code can support any abstraction-
/// implementation combination.
private class Client {
    // ...
    static func someClientCode(abstraction: Abstraction) {
        print(abstraction.operation())
    }
    // ...
}

/// Let's see how it all works together.
private class BridgeConceptual: XCTestCase {

    func testBridgeConceptual() {
        // The client code should be able to work with any pre-configured
        // abstraction-implementation combination.
        let implementation = ConcreteImplementationA()
        Client.someClientCode(abstraction: Abstraction(implementation))

        let concreteImplementation = ConcreteImplementationB()
        Client.someClientCode(abstraction: ExtendedAbstraction(concreteImplementation))
    }
}
