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
        print(maybeInt as Any, terminator: " ") // Optional(1) Optional(2) nil
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
    print(lower as Any)
    print(upper2 as Any)
    
    
    ///FUN FACT
    ///
    ///If str?.uppercased() returned an optional and you called ?.lowercased() on it,
    ///then logically you’d get an optional optional.
    ///But you just want a regular optional,
    ///so instead we write the second chained call without the question mark to represent the fact that the optionality is already captured.
    ///
    
    // optional chaining
    print(10.half?.half?.half as Any) /// Optional(2)
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
    _ = !array.isEmpty ? array[0] : 0
    
    
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
    
    print(firstCharAsString as Any)
}

/// we can do this using map function as below
///
public func optionalMap() {
    
    let characters: [Character] = ["a", "b", "c"]
    let firstChar = characters.first.map { String($0) } // Optional("a")}
    print(firstChar as Any)
}

/// map function implementation inside the 
extension Optional {
    func map<U>(transform: (Wrapped) -> U) -> U? {
        guard let value = self else { return nil }
        return transform(value)
    }
}


///Because of the possibility that the array might be empty, the result needs to be optional — without an initial value. --> reduce always needs a initial value...but with  this below implentation it doesnt need an initial value. It will return nil for empty arrays
extension Array {
    func reduce(_ nextPartialResult: (Element, Element) -> Element) -> Element? {
        // first will be nil if the array is empty.
        guard let fst = first else { return nil }
        return dropFirst().reduce(fst, nextPartialResult)
    }
}


///Since optional map returns nil if the optional is nil, our variant of reduce could be
///rewritten using a single return statement (and no guard):
///
extension Array {
    func reduce_alt(_ nextPartialResult: (Element, Element) -> Element) -> Element? {
        return first.map {
            dropFirst().reduce($0, nextPartialResult)
        }
    }
}


// MARK: - Optional flatmap

public func optionalFlatMaps() {
    
    /// this gives us an int?? / Optional(Optional(1))
    let stringNumbers = ["1", "2", "3", "foo"]
    let x = stringNumbers.first.map { Int($0) }
    print(x as Any) // Optional(Optional(1))
    
    
    ///fatMap will instead flatten the result into a single optional. As a result, y will be of type Int?:
    ///
    let y = stringNumbers.first.flatMap { Int($0) } // Optional(1)
    print(y as Any)
}

public func flatMapDemo() {
    
    /// Without using flat map --> used basic if let
    if let path = Bundle.main.path(forResource: "CityNameAndNameList", ofType: "json") {
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            let _ = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
            
        } catch {
            // handle error
        }
    }
    
    
    /// using flat map - more readable
    let _ = Bundle.main.path(forResource: "CityNameAndNameList", ofType: "json")
                        .flatMap { URL(fileURLWithPath: $0) }
                        .flatMap { try? Data(contentsOf: $0, options: .mappedIfSafe) }
                        .flatMap { try? JSONSerialization.jsonObject(with: $0, options: .mutableLeaves) }
}

/// Internal implementation of a flat map would look like this.
extension Optional {
    
    func flatMap<U>(transform: (Wrapped) -> U?) -> U? {
        if let value = self,
           let transformed = transform(value) {
            return transformed
        }
        return nil
    }
}


//MARK: - Filtering Out nils with compactMap

///there are different way of filtering out nils
func compactMapsDemo() {
    
    // #1
    let numbers = ["1", "2", "3", "foo"]
    var sum = 0
    
    for case let i? in numbers.map({ Int($0) }) {
        sum += i
    }
        
    // #2
    sum = numbers.map { Int($0) }.reduce(0) { $0 + ($1 ?? 0) } // 6
    
    // #3
    /// compact map way of doing it
    sum = numbers.compactMap { Int($0) }.reduce(0, +) // 6

}

/// Implementation of compact map would look like this
 /// Fun fact --In the implementation, we use lazy to defer actual creation of the array until the last moment. This is possibly a micro-optimization, but it might be worthwhile for larger sequences. Using lazy saves the allocation of multiple intermediate arrays.
extension Sequence {
    func compactMap<B>(_ transform: (Element) -> B?) -> [B] {
        return lazy.map(transform).filter { $0 != nil }.map { $0! }
    }
}

// MARK: - Equating Optionals
///Optional conforms to Equatable, but only if the Wrapped type also conforms to Equatable:

//extension Optional: Equatable where Wrapped: Equatable {
//    static func ==(lhs: Wrapped?, rhs: Wrapped?) -> Bool {
//        switch (lhs, rhs) {
//        case (nil, nil): return true
//        case let (x?, y?): return x == y
//        case (_?, nil), (nil, _?): return false
//        }
//    }
//}

public func addingNilToDict() {
    
    var dictWithNils: [String: Int?] = [
        "one": 1,
        "two": 2,
        "none": nil
    ]
     
    /// this will just remove the key "two"
    dictWithNils["two"] = nil
    print(dictWithNils) // ["one": Optional(1), "none": nil]
    
    ///instead we need to use one of the following things
    //#1
    dictWithNils["two"] = Optional(nil)
    
    //#2
    dictWithNils["two"] = .some(nil)
    
    //#3
    dictWithNils["two"]? = nil
    
    print(dictWithNils) // ["one": Optional(1), "two": nil, "none": nil]
    
    
    /// in the third case if key is not present nothing would be updated/inserted.
    dictWithNils["three"]? = nil
    let idx = dictWithNils.index(forKey: "three") // nil
    print(idx as Any)
}


// MARK: - When to Force-Unwrap

/// when to use force unwrap?
/// Use ! when you’re so certain that a value won’t be nil that you want your program to crash if it ever is.
///go back to compact map implementation --> force unwrapped the values after check
///chances are there’s a better way than force-unwrapping. Whenever you do find yourself reaching for !, it’s worth taking a step back and wondering if there really is no other option.

public func filterNames() {
    
    
    let ages = [
        "Tim": 53,"Angela":54,"Craig":44, "Jony": 47, "Chris": 37, "Michael": 34,
    ]
    
    /// objcio say its perfectly okat to unwrap but what if one of the keys have nil value
    let ageSorted = ages.keys
    .filter { name in ages[name]! < 50 }
    .sorted()  // ["Chris", "Craig", "Jony", "Michael"]
    
    print(ageSorted)
    
    /// better way of unwrapping without force unwrap
    let ageSorted2 = ages.filter { (_, age) in age < 50 } .map { (name, _) in name }.sorted()
    
    print(ageSorted2)
}

// MARK: - Improving Force-Unwrap Error Messages
///you’ll leave a comment as to why you’re justified in force-unwrapping. So why not have that comment serve as the error message too? Here’s an operator, !!; it combines unwrapping with supplying a more descriptive error message to be logged when the application exits:
///
infix operator !!
func !! <T>(wrapped: T?, failureText: @autoclosure () -> String) -> T {
    if let x = wrapped { return x }
    fatalError(failureText())
}

public func testInfixOperationForForceUnwrap() {
    
    let s = "foo"
    let i = Int(s) !! "Expecting integer, got \"\(s)\""
    print(i)
}


// MARK: - Asserting in Debug Builds
///Still, choosing to crash even on release builds is quite a bold move. Often, you might prefer to assert during debug and test builds, but in production, you’d substitute a valid default value — perhaps zero or an empty array.
///
/// This is just for integerss others have different literal types eg: - ExpressibleByArrayLiteral, ExpressibleByStringLiteral
infix operator !?

func !?<T: ExpressibleByIntegerLiteral>(wrapped: T?, failureText: @autoclosure () -> String) -> T {
    assert(wrapped != nil, failureText())
    return wrapped ?? 0
}

public func testInterrobangOperator() {
    let s = "dd"
    let i = Int(s) !? "Expecting integer, got \"\(s)\""
    print(i)
}


// MARK: - Implicitly Unwrapped Optionals

///implicitly unwrapped optionals — types marked with an exclamation point, such as UIView! — are still optionals, albeit ones that are automatically force-unwrapped whenever you use them.

///why do we use them -? Two reasons ante
///#1 -> Reason 1: Temporarily, because you’re calling Objective-C code that hasn’t been audited for nullability, or because you’re calling into a C library that doesn’t have Swift-specific annotations.
///#2 Reason 2: Because a value is nil very briefly, for a well-defined period of time, and is then never nil again.
///eg: Interface Builders -> The most common scenario is two-phase initialization. By the time your class is ready to use, the implicitly wrapped optionals will all have a value. This is the reason Xcode/Interface Builder uses them in the view controller lifecycle: in Cocoa and Cocoa Touch, view controllers create their view lazily, so there exists a time window — after a view controller has been initialized but before it has loaded its view — when the view objects its outlets reference have not yet been created.
