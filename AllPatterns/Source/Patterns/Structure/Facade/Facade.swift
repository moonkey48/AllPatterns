//
//  Facade.swift
//  AllPatterns
//
//  Created by Austin's Macbook Pro M3 on 11/14/24.
//

import Foundation
import XCTest

/// 퍼사드(Facade) 클래스는 하나 이상의 하위 시스템의 복잡한 논리를 단순화된 인터페이스로 제공합니다.
/// 퍼사드는 클라이언트 요청을 적절한 하위 시스템 객체에 위임하며, 하위 시스템의 수명 주기를 관리합니다.
/// 이를 통해 클라이언트는 하위 시스템의 불필요한 복잡성으로부터 보호받을 수 있습니다.
private class Facade {

    private var subsystem1: Subsystem1
    private var subsystem2: Subsystem2

    /// 애플리케이션의 필요에 따라, 퍼사드에 기존 하위 시스템 객체를 제공하거나,
    /// 퍼사드가 스스로 객체를 생성하도록 강제할 수 있습니다.
    init(subsystem1: Subsystem1 = Subsystem1(),
         subsystem2: Subsystem2 = Subsystem2()) {
        self.subsystem1 = subsystem1
        self.subsystem2 = subsystem2
    }

    /// 퍼사드의 메서드는 하위 시스템의 복잡한 기능에 대한 편리한 단축키 역할을 합니다.
    /// 하지만 클라이언트는 하위 시스템 기능의 일부만 접근할 수 있습니다.
    func operation() -> String {

        var result = "퍼사드가 하위 시스템을 초기화합니다:"
        result += " " + subsystem1.operation1()
        result += " " + subsystem2.operation1()
        result += "\n" + "퍼사드가 하위 시스템에 작업 수행을 지시합니다:\n"
        result += " " + subsystem1.operationN()
        result += " " + subsystem2.operationZ()
        return result
    }
}

/// 하위 시스템은 퍼사드 또는 클라이언트로부터 직접 요청을 받을 수 있습니다.
/// 어쨌든 하위 시스템 입장에서 퍼사드는 또 다른 클라이언트일 뿐이며,
/// 퍼사드는 하위 시스템의 일부가 아닙니다.
private class Subsystem1 {

    func operation1() -> String {
        return "하위 시스템 1: 준비 완료!\n"
    }

    // ...

    func operationN() -> String {
        return "하위 시스템 1: 진행 중!\n"
    }
}

/// 일부 퍼사드는 동시에 여러 하위 시스템과 함께 작업할 수 있습니다.
private class Subsystem2 {

    func operation1() -> String {
        return "하위 시스템 2: 준비 중!\n"
    }

    // ...

    func operationZ() -> String {
        return "하위 시스템 2: 발사!\n"
    }
}

/// 클라이언트 코드는 복잡한 하위 시스템을 퍼사드가 제공하는 단순한 인터페이스를 통해 사용합니다.
/// 퍼사드가 하위 시스템의 수명 주기를 관리하는 경우,
/// 클라이언트는 하위 시스템의 존재조차 알지 못할 수 있습니다.
/// 이러한 접근 방식은 복잡성을 통제할 수 있도록 도와줍니다.
private class Client {
    // ...
    static func clientCode(facade: Facade) {
        print(facade.operation())
    }
    // ...
}

/// 모든 것이 함께 어떻게 작동하는지 확인해봅시다.
private class FacadeConceptual: XCTestCase {

    func testFacadeConceptual() {

        /// 클라이언트 코드는 일부 하위 시스템 객체를 이미 생성했을 수 있습니다.
        /// 이 경우, 퍼사드가 새 인스턴스를 생성하도록 두기보다, 해당 객체들로 퍼사드를 초기화하는 것이 좋을 수 있습니다.

        let subsystem1 = Subsystem1()
        let subsystem2 = Subsystem2()
        let facade = Facade(subsystem1: subsystem1, subsystem2: subsystem2)
        Client.clientCode(facade: facade)
    }
}
