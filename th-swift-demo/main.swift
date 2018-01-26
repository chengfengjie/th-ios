//
//  main.swift
//  th-swift-demo
//
//  Created by chengfj on 2018/1/26.
//  Copyright © 2018年 wincode.com. All rights reserved.
//

import Foundation

print("Hello, World!")

class Person: NSObject {
    func doAction(action: @convention(swift)(String) -> Void, arg: String) {
        action(arg)
    }
    @objc func countNumber() {
        print("countNumber")
    }
}

let saySomething_c: @convention(c) (String) -> Void = {
    print("i said : \($0)")
}

let saySomething_oc: @convention(block) (String) -> Void = {
    print("i said: \($0)")
}

let saySomething_swift: @convention(swift) (String) -> Void = {
    print("i said: \($0)")
}

let person = Person()
person.doAction(action: saySomething_c, arg: "Hello word")
person.doAction(action: saySomething_oc, arg: "Hello word")
person.doAction(action: saySomething_swift, arg: "Hello word")

let method = class_getInstanceMethod(Person.self, #selector(Person.countNumber))
let oldImp = method_getImplementation(method!)
typealias Imp = @convention(c) (Person, Selector) -> Void

let oldImpBlock = unsafeBitCast(oldImp, to: Imp.self)


