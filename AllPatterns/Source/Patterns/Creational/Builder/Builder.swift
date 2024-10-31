//
//  Builder.swift
//  AllPatterns
//
//  Created by Austin's Macbook Pro M3 on 10/31/24.
//

import Foundation

protocol DomainModel {
}

private struct User: DomainModel {
    let id: Int
    let age: Int
    let email: String
}

class BaseQueryBuilder<Model: DomainModel> {
    typealias Predicate = (Model) -> (Bool)

    func limit(_ limit: Int) -> BaseQueryBuilder<Model> {
        return self
    }

    func filter(_ predicate: @escaping Predicate) -> BaseQueryBuilder<Model> {
        return self
    }

    func fetch() -> [Model] {
        preconditionFailure("Should be overridden in subclasss")
    }
}


