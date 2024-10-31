//
//  BuilderExample.swift
//  AllPatterns
//
//  Created by Austin's Macbook Pro M3 on 10/31/24.
//

import Foundation

protocol Builder {
    func producePartA()
    func producePartB()
    func producePartC()
}

class ConcreteBuilder1: Builder {
    private var product = Product1()

    func reset() {
        product = Product1()
    }

    func producePartA() {
        product.add(part: "PartA")
    }

    func producePartB() {
        product.add(part: "PartB")
    }

    func producePartC() {
        product.add(part: "PartC")
    }

    /// Concrete Builders are supposed to provide their own methods for
    /// retrieving results. That's because various types of builders may create
    /// entirely different products that don't follow the same interface.
    /// Therefore, such methods cannot be declared in the base Builder interface
    /// (at least in a statically typed programming language).
    ///
    /// Usually, after returning the end result to the client, a builder
    /// instance is expected to be ready to start producing another product.
    /// That's why it's a usual practice to call the reset method at the end of
    /// the `getProduct` method body. However, this behavior is not mandatory,
    /// and you can make your builders wait for an explicit reset call from the
    /// client code before disposing of the previous result.
    func retrieveProduct() -> Product1 {
       let result = self.product
       reset()
       return result
   }
}

class Director {
    private var builder: Builder?

    func updated(builder: Builder) {
        self.builder = builder
    }

    func buildMinimalViableProduct() {
        builder?.producePartA()
    }

    func buildFullFeaturedProduct() {
        builder?.producePartA()
        builder?.producePartB()
        builder?.producePartC()
    }
}

class Product1 {
    private var parts = [String]()

    func add(part: String) {
        self.parts.append(part)
    }

    func listParts() -> String {
        return "Product parts: " + parts.joined(separator: ", ") + "\n"
    }
}

private class Client {
    // ...
    static func someClientCode(director: Director) {
        let builder = ConcreteBuilder1()
        director.updated(builder: builder)

        print("Standard basic product:")
        director.buildMinimalViableProduct()
        print(builder.retrieveProduct().listParts())

        print("Standard full featured product:")
        director.buildFullFeaturedProduct()
        print(builder.retrieveProduct().listParts())

        // Remember, the Builder pattern can be used without a Director class.
        print("Custom product:")
        builder.producePartA()
        builder.producePartC()
        print(builder.retrieveProduct().listParts())
    }
}

private class Test {
    func textBuilderConceptual() {
        let director = Director()
        Client.someClientCode(director: director)
    }
}
