//
//  Singleton.swift
//  AllPatterns
//
//  Created by Austin's Macbook Pro M3 on 11/5/24.
//

import Foundation
import XCTest

/// The Singleton class defines the `shared` field that lets clients access the
/// unique singleton instance.
private class Singleton {

    /// The static field that controls the access to the singleton instance.
    ///
    /// This implementation let you extend the Singleton class while keeping
    /// just one instance of each subclass around.
    static var shared: Singleton = {
        let instance = Singleton()
        // ... configure the instance
        // ...
        return instance
    }()

    /// The Singleton's initializer should always be private to prevent direct
    /// construction calls with the `new` operator.
    private init() {}

    /// Finally, any singleton should define some business logic, which can be
    /// executed on its instance.
    func someBusinessLogic() -> String {
        // ...
        return "Result of the 'someBusinessLogic' call"
    }
}

/// Singletons should not be cloneable.
private extension Singleton: NSCopying {

    func copy(with zone: NSZone? = nil) -> Any {
        return self
    }
}

/// The client code.
private class ClientSingleton {
    // ...
    static func someClientCode() {
        let instance1 = Singleton.shared
        let instance2 = Singleton.shared

        if (instance1 === instance2) {
            print("Singleton works, both variables contain the same instance.")
        } else {
            print("Singleton failed, variables contain different instances.")
        }
    }
    // ...
}

/// Let's see how it all works together.
private class SingletonConceptual: XCTestCase {

    func testSingletonConceptual() {
        Singleton.shared.someBusinessLogic()
    }
}
