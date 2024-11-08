//
//  FactoryMethod.swift
//  AllPatterns
//
//  Created by Austin's Macbook Pro M3 on 10/31/24.
//

import Foundation

/// (1)
private protocol Product {
    func operation() -> String
}

/// (2)
private class ConcreteProductA: Product {
    func operation() -> String {
        "some result of operation with Product A"
    }
}

/// (2)
private class ConcreteProductB: Product {
    func operation() -> String {
        "some result of operation with Product B"
    }
}

/// (3)
private protocol Creator {
    /// 기본적으로 제공해야 하는 factoryMethod, 특정 객체를 리턴해야 한다.
    func factoryMethod() -> Product

    /// Creator이지만, 생성하는 객체에 대한 비지니스 로직을 포함한다는 것이 핵심!
    func someOperation() -> String
}

/// (4)
/// 기본적은 someOperatin에 대해 구현하고, subClass에서 오버라이드 하게 한다
extension Creator {
    func someOperation() -> String {
        let product = factoryMethod()
        return "Creator: some operation is implemented" + product.operation()
    }
}

/// (5)
private class ConcreteCreatorA: Creator {
    public func factoryMethod() -> Product {
        return ConcreteProductA()
    }
}

/// (5)
private class ConcreteCreatorB: Creator {
    public func factoryMethod() -> Product {
        return ConcreteProductB()
    }
}


private class Client {
    // ...
    static func someClientCode(creator: Creator) {
        print("Client: I'm not aware of the creator's class, but it still works" + creator.someOperation() )
    }
    // ...
}


private class FactoryMethodConceptual {
    func testFactoryMethodConceptual() {
        print("App: Launched with the ConcreateCreatorA")
        Client.someClientCode(creator: ConcreteCreatorA())
        
        print("App: Launched with the ConcreateCreatorB")
        Client.someClientCode(creator: ConcreteCreatorB())
    }
}
