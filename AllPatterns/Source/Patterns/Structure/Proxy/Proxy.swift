//
//  Proxy.swift
//  AllPatterns
//
//  Created by Austin's Macbook Pro M3 on 11/17/24.
//

import Foundation
import XCTest

/// Subject 인터페이스는 RealSubject와 Proxy 모두에 공통된 작업을 선언합니다.
/// 클라이언트가 이 인터페이스를 사용하여 RealSubject와 작업하는 한, 실제 주제 대신 프록시를 전달할 수 있습니다.
private protocol Subject {

    func request()
}

/// RealSubject는 핵심 비즈니스 로직을 포함합니다. 보통 RealSubject는 유용한 작업을 수행할 수 있으며,
/// 이는 매우 느리거나 민감한 작업일 수 있습니다. 예를 들어 입력 데이터를 수정하는 경우입니다.
/// Proxy는 RealSubject 코드의 변경 없이 이러한 문제를 해결할 수 있습니다.
private class RealSubject: Subject {

    func request() {
        print("RealSubject: Handling request.")
    }
}

/// Proxy는 RealSubject와 동일한 인터페이스를 가집니다.
private class Proxy: Subject {

    private var realSubject: RealSubject

    /// Proxy는 RealSubject 클래스의 객체에 대한 참조를 유지합니다.
    /// 이는 지연 로드되거나 클라이언트에 의해 Proxy로 전달될 수 있습니다.
    init(_ realSubject: RealSubject) {
        self.realSubject = realSubject
    }

    /// Proxy 패턴의 가장 일반적인 용도는 지연 로딩, 캐싱, 접근 제어, 로깅 등입니다.
    /// Proxy는 이러한 작업 중 하나를 수행하고 결과에 따라 연결된 RealSubject 객체의
    /// 동일한 메서드로 실행을 전달할 수 있습니다.
    func request() {

        if checkAccess() {
            realSubject.request()
            logAccess()
        }
    }

    private func checkAccess() -> Bool {

        /// 실제 검증 로직이 여기에 들어가야 합니다.

        print("Proxy: Checking access prior to firing a real request.")

        return true
    }

    private func logAccess() {
        print("Proxy: Logging the time of request.")
    }
}

/// 클라이언트 코드는 주제와 프록시 모두를 지원하기 위해 Subject 인터페이스를 통해 모든 객체와
/// 작업해야 합니다. 실제로는 대부분의 클라이언트가 RealSubject와 직접 작업합니다.
/// 이 경우 패턴을 더 쉽게 구현하기 위해 프록시를 RealSubject 클래스에서 확장할 수 있습니다.
private class Client {
    // ...
    static func clientCode(subject: Subject) {
        // ...
        subject.request()
        // ...
    }
    // ...
}

/// 이제 모든 것이 어떻게 작동하는지 살펴보겠습니다.
private class ProxyConceptual: XCTestCase {

    func test() {
        print("Client: Executing the client code with a real subject:")
        let realSubject = RealSubject()
        Client.clientCode(subject: realSubject)

        print("\nClient: Executing the same client code with a proxy:")
        let proxy = Proxy(realSubject)
        Client.clientCode(subject: proxy)
    }
}
