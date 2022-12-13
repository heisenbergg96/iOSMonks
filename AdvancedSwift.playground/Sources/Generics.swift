import Foundation

// MARK: - GENERICS

public struct Stack<U> {
    
    var items: [U] = []
    
    mutating func push(_ item: U) {
        items.append(item)
    }
    
    mutating func pop() -> U {
        return items.removeLast()
    }
}

public struct Person {
    let age: Int
    let name: String
}
