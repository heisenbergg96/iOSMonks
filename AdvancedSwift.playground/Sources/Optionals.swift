import Foundation

/// What optionals look like internally

// MARK: - Optional
//enum Optional<Wrapped> {
//
//    case none
//    case some(Wrapped)
//}


// MARK: - First Index
/// This is how first index is implemented internally using optional value
///Instead of sending sending sentinal values like -1 if index not found we optional values. Now there’s no way a user could mistakenly use the value before checking if it’s valid:
///This is why swift has Optionals
extension Collection where Element: Equatable {
    
    func firstIndex(of element: Element) -> Optional<Index> {
        
        var idx = startIndex
        
        while idx != endIndex {
            if self[idx] == element {
                return .some(idx)
            }
            formIndex(after: &idx)
        }
        
        // Not found, return .none.
        return .none
    }
}


// MARK: - Optional retrivals
/// How to get values from optionals
/// we all know if let let's not waste our time

public func whileLetDemo() {
    
    var iterator = Constants.integerArray.makeIterator()
    while let i = iterator.next() {
        print(i, terminator: " ")
    }
}

// MARK: - Doubly nested optional
///What’s returned from iterator.next() would be an Optional<Optional<Int>> — or Int?? — because next wraps each element in the sequence inside an optional.
public func doublyNestedOptionals() {
    
    let stringNumbers = ["1", "2", "three"]
    let maybeInts = stringNumbers.map { Int($0) } // [Optional(1), Optional(2), nil]
    
    var iterator = maybeInts.makeIterator()
    while let maybeInt = iterator.next() {
        print(maybeInt, terminator: " ") // Optional(1) Optional(2) nil
    }
}


// MARK: - Scoping of Unwrapped Optionals
public func scopeWithInIfBlock() {
    
    /// in all these examples the scope od the varibale is within the if block
    
    let array = [1,2,3]
    
    if !array.isEmpty {
        print(array[0]) // Outside the block, the compiler can't guarantee that array[0] is valid.
    }
    
    
    if let firstElement = array.first {
        print(firstElement) // // Outside the block, you can't use firstElement.
    }
    
    // // Now use a[0] or a.first! safely. But the syntax is not appealing --> not force unwrap
    if array.isEmpty {
        return
    }
}

extension String {
    
    /// the scope is outside this time...still the approach is pretty ugly
    var fileExtension1: String? {
        
        let period: String.Index
        
        if let idx = lastIndex(of: ".") {
            period = idx
        } else {
            return nil
        }
        let extensionStart = index(after: period)
        return String(self[extensionStart...])
    }
    
    /// scope of the unwrapped optional is outside and also code is pretty clean - ashte jeevna
    var fileExtension2: String? {
        
        guard let period = lastIndex(of: ".") else {
            return nil
        }
        let extensionStart = index(after: period)
        return String(self[extensionStart...])
    }
}


// MARK: - Optional Chaining
///delegate?.callback()  ---> optional chaining looks like this

public func optionalChaining() {
    
    let str: String? = "Never say never"
    // We want upper to be the uppercase string.
    let upper: String
    
    if str != nil {
        upper = str!.uppercased()
        print(upper)
    }
    else {
        // No reasonable action to take at this point.
        print("No idea what to do now...")
    }
    
    let upper2 = str?.uppercased() // Optional("NEVER SAY NEVER")
    ///As the name implies, you can chain calls on optional values:
    let lower = str?.uppercased().lowercased() // Optional("never say never")
    print(lower)
    print(upper2)
    
    
    ///FUN FACT
    ///
    ///If str?.uppercased() returned an optional and you called ?.lowercased() on it,
    ///then logically you’d get an optional optional.
    ///But you just want a regular optional,
    ///so instead we write the second chained call without the question mark to represent the fact that the optionality is already captured.
    ///
    
    // optional chaining
    print(10.half?.half?.half) /// Optional(2)
}

extension Int {
    var half: Int? {
        guard self < -1 || self > 1 else{ return nil }
        return self / 2
    }
}

 
// MARK: - The nil-Coalescing Operator
public func nilCoalescingOperations() {
    
    let stringteger = "1"
    let number = Int(stringteger) ?? 0
    
    // prints 1
    print(number)
    
    let array = [1,2,3]
    let firstElement = !array.isEmpty ? array[0] : 0
    
    
    /// Coalescing can also be chained — so if you have multiple possible optionals and you
    //want to choose the first non-nil value, you can write them in sequence:
    let i: Int? = nil
    let j: Int? = nil
    let k:Int? = 42
    let output = i ?? j ?? k ?? 0 // 42
    print(output)
    
    /// if you’re ever presented with a doubly nested optional and want to use the ?? operator,
    /// you must take care to distinguish between a ?? b ?? c (chaining) and (a ?? b) ?? c (unwrapping the inner and then outer layers):
    let s1: String?? = nil
    let output2 = (s1 ?? "inner") ?? "outer" // inner
    print(output2)
    
    let s2: String?? = .some(nil)
    let output3 = (s2 ?? "inner") ?? "outer" // outer
    print(output3)
}

///Unlike first and last, getting an element out of an array by its index doesn’t return an Optional.
///But it’s easy to extend Array to add this functionality:

extension Array {
    
    ///This now allows you to write the following:
    /// array[guarded: 5] ?? 0 // 0
    subscript(guarded idx: Int) -> Element? {
        
        guard (startIndex..<endIndex).contains(idx) else {
            return nil
        }
        return self[idx]
    }
}


// MARK: - Optional map

func getString() {
    
    let characters: [Character] = ["a", "b", "c"]
    
    var firstCharAsString: String? = nil
    
    if let char = characters.first {
        firstCharAsString = String(char)
    }
}

/// we can do this using map function as below
///
func optionalMap() {
    let characters: [Character] = ["a", "b", "c"]
    let firstChar = characters.first.map { String($0) } // Optional("a")}
}

/// map function implementation inside the 
extension Optional {
    func map<U>(transform: (Wrapped) -> U) -> U? {
        guard let value = self else { return nil }
        return transform(value)
    }
}
