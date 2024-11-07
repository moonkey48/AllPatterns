//
//  Adapter.swift
//  AllPatterns
//
//  Created by Austin's Macbook Pro M3 on 11/7/24.
//

import Foundation
import XCTest

class Target {
    func request() -> String {
        "Target: The default target's behavior."
    }
}

/// 호환이 필요한 Service
///
/// Adapter로 호환 가능하다.
class Adaptee {
    public func specificRequest() -> String {
        ".eetpadA eht fo roivaheb laicepS"
    }
}

class Adapter: Target {
    private var adaptee: Adaptee

    init(_ adaptee: Adaptee) {
        self.adaptee = adaptee
    }

    override func request() -> String {
        "Adapter: (Translated)" + adaptee.specificRequest().reversed()
    }
}

private class Client {
    static func someClientCode(target: Target) {
        print(target.request())
    }
}

class AdapterConceptual: XCTestCase {
    func testAdapterConceptual() {
        print("Client: I can work just fine with the Target objects:")
        Client.someClientCode(target: Target())

        let adaptee = Adaptee()
        print("Client: The Adaptee class has a weird interface. See, I don't understand it:")
        print("Adaptee: " + adaptee.specificRequest())

        print("Client: But I can work with it via the Adapter:")
        Client.someClientCode(target: Adapter(adaptee))
    }
}
