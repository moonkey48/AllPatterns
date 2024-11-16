//
//  Flyweight.swift
//  AllPatterns
//
//  Created by Austin's Macbook Pro M3 on 11/16/24.
//

import Foundation
import XCTest

/// Flyweight는 여러 실제 비즈니스 엔티티에 속하는 공통 부분의 상태(내재 상태라고도 함)를 저장합니다.
/// Flyweight는 각 엔티티에 고유한 나머지 상태(외재 상태)를 메서드 매개변수를 통해 전달받습니다.
private class Flyweight {

    private let sharedState: [String]

    init(sharedState: [String]) {
        self.sharedState = sharedState
    }

    func operation(uniqueState: [String]) {
        print("Flyweight: Displaying shared (\(sharedState)) and unique (\(uniqueState)) state.\n")
    }
}

/// FlyweightFactory는 Flyweight 객체를 생성하고 관리합니다.
/// Flyweight가 올바르게 공유되도록 보장합니다. 클라이언트가 Flyweight를 요청할 때,
/// 팩토리는 기존 인스턴스를 반환하거나 존재하지 않을 경우 새로 생성합니다.
private class FlyweightFactory {

    private var flyweights: [String: Flyweight]

    init(states: [[String]]) {

        var flyweights = [String: Flyweight]()

        for state in states {
            flyweights[state.key] = Flyweight(sharedState: state)
        }

        self.flyweights = flyweights
    }

    /// 주어진 상태에 해당하는 기존 Flyweight를 반환하거나, 새로 생성합니다.
    func flyweight(for state: [String]) -> Flyweight {

        let key = state.key

        guard let foundFlyweight = flyweights[key] else {

            print("FlyweightFactory: Can't find a flyweight, creating new one.\n")
            let flyweight = Flyweight(sharedState: state)
            flyweights.updateValue(flyweight, forKey: key)
            return flyweight
        }
        print("FlyweightFactory: Reusing existing flyweight.\n")
        return foundFlyweight
    }

    func printFlyweights() {
        print("FlyweightFactory: I have \(flyweights.count) flyweights:\n")
        for item in flyweights {
            print(item.key)
        }
    }
}

private extension Array where Element == String {

    /// 주어진 상태의 Flyweight 문자열 해시를 반환합니다.
    var key: String {
        return self.joined()
    }
}

private class FlyweightConceptual: XCTestCase {

    func testFlyweight() {

        /// 클라이언트 코드는 보통 애플리케이션 초기화 단계에서 사전 정의된 여러 Flyweight를 생성합니다.

        let factory = FlyweightFactory(states:
        [
            ["Chevrolet", "Camaro2018", "pink"],
            ["Mercedes Benz", "C300", "black"],
            ["Mercedes Benz", "C500", "red"],
            ["BMW", "M5", "red"],
            ["BMW", "X6", "white"]
        ])

        factory.printFlyweights()

        /// ...

        addCarToPoliceDatabase(factory,
                "CL234IR",
                "James Doe",
                "BMW",
                "M5",
                "red")

        addCarToPoliceDatabase(factory,
                "CL234IR",
                "James Doe",
                "BMW",
                "X1",
                "red")

        factory.printFlyweights()
    }

    private func addCarToPoliceDatabase(
            _ factory: FlyweightFactory,
            _ plates: String,
            _ owner: String,
            _ brand: String,
            _ model: String,
            _ color: String) {

        print("Client: Adding a car to database.\n")

        let flyweight = factory.flyweight(for: [brand, model, color])

        /// 클라이언트 코드는 외재 상태를 저장하거나 계산하여
        /// Flyweight의 메서드에 전달합니다.
        flyweight.operation(uniqueState: [plates, owner])
    }
}


// 결과
//FlyweightFactory: I have 5 flyweights:
//
//Mercedes BenzC500red
//ChevroletCamaro2018pink
//Mercedes BenzC300black
//BMWX6white
//BMWM5red
//Client: Adding a car to database.
//
//FlyweightFactory: Reusing existing flyweight.
//
//Flyweight: Displaying shared (["BMW", "M5", "red"]) and unique (["CL234IR", "James Doe"] state.
//
//Client: Adding a car to database.
//
//FlyweightFactory: Can't find a flyweight, creating new one.
//
//Flyweight: Displaying shared (["BMW", "X1", "red"]) and unique (["CL234IR", "James Doe"] state.
//
//FlyweightFactory: I have 6 flyweights:
//
//Mercedes BenzC500red
//BMWX1red
//ChevroletCamaro2018pink
//Mercedes BenzC300black
//BMWX6white
//BMWM5red
