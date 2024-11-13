//
//  Decorator.swift
//  AllPatterns
//
//  Created by Austin's Macbook Pro M3 on 11/13/24.
//

import Foundation
import XCTest

/// 기본 구성 요소 인터페이스는 데코레이터에 의해 변경될 수 있는 작업을 정의합니다.
private protocol Component {

    func operation() -> String
}

/// 구체적인 구성 요소는 작업의 기본 구현을 제공합니다.
/// 이러한 클래스의 여러 변형이 있을 수 있습니다.
private class ConcreteComponent: Component {

    func operation() -> String {
        return "ConcreteComponent"
    }
}

/// 기본 데코레이터 클래스는 다른 구성 요소와 동일한 인터페이스를 따릅니다.
/// 이 클래스의 주요 목적은 모든 구체적인 데코레이터에 대한 래핑 인터페이스를 정의하는 것입니다.
/// 래핑 코드의 기본 구현에는 래핑된 구성 요소를 저장하기 위한 필드와 초기화 수단이 포함될 수 있습니다.
private class Decorator: Component {

    private var component: Component

    init(_ component: Component) {
        self.component = component
    }

    /// 데코레이터는 모든 작업을 래핑된 구성 요소에 위임합니다.
    func operation() -> String {
        return component.operation()
    }
}

/// 구체적인 데코레이터는 래핑된 객체를 호출하고 그 결과를 어떤 방식으로든 변경합니다.
private class ConcreteDecoratorA: Decorator {

    /// 데코레이터는 래핑된 객체를 직접 호출하는 대신 부모 구현의 작업을 호출할 수 있습니다.
    /// 이 접근 방식은 데코레이터 클래스의 확장을 단순화합니다.
    override func operation() -> String {
        return "ConcreteDecoratorA(" + super.operation() + ")"
    }
}

/// 데코레이터는 래핑된 객체를 호출하기 전 또는 후에 자신만의 동작을 실행할 수 있습니다.
private class ConcreteDecoratorB: Decorator {

    override func operation() -> String {
        return "ConcreteDecoratorB(" + super.operation() + ")"
    }
}

/// 클라이언트 코드는 Component 인터페이스를 사용하여 모든 객체와 작업합니다.
/// 이렇게 하면 구체적인 구성 요소 클래스에 독립적으로 작업할 수 있습니다.
private class Client {
    // ...
    static func someClientCode(component: Component) {
        print("결과: " + component.operation())
    }
    // ...
}

/// 모든 것이 함께 작동하는 방식을 살펴봅시다.
private class DecoratorConceptual: XCTestCase {

    func testDecoratorConceptual() {
        // 이렇게 하면 클라이언트 코드는 간단한 구성 요소를 지원할 수 있습니다.
        print("클라이언트: 간단한 구성 요소를 받았습니다.")
        let simple = ConcreteComponent()
        Client.someClientCode(component: simple)

        // ...뿐만 아니라 데코레이터가 적용된 구성 요소도 지원합니다.
        //
        // 데코레이터가 단순한 구성 요소뿐만 아니라 다른 데코레이터도 래핑할 수 있는지 확인해보세요.
        let decorator1 = ConcreteDecoratorA(simple)
        let decorator2 = ConcreteDecoratorB(decorator1)
        print("\n클라이언트: 이제 데코레이터가 적용된 구성 요소를 받았습니다.")
        Client.someClientCode(component: decorator2)
    }
}
