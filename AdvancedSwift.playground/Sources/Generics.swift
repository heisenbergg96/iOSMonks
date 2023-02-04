import Foundation

// MARK: - Generics Definition
/// Generic code enables you to write flexible, reusable functions and types that can work with any type
/// Generic programming is a technique for writing reusable code while maintaining type safety
///
/// What is maintaining type safety?
/// #1 -> the standard library uses generic programming to make the sort method take a custom comparator function while making sure the types of the comparator’s parameters match up with the element type of the sequence being sorted
/// #2 -> an array is generic over the kind of elements it contains in order to provide a type-safe API for accessing and mutating the array’s contents.
///
///Generics are a form of polymorphism. ----> Polymorphism means using a single interface or name that works with multiple types.

//MARK: - Generic Types
/// Indentity function -> the function that returns its input unchanged:
///
///
///the identity function has an unlimited number of concrete types
///For example,
/// #1 - if we choose A to be Int, the concrete type is (Int) -> Int;
/// #2 - if we choose A to be (String -> Bool), then its type is ((String) -> Bool) -> (String) -> Bool;
func identity<A>(_ value: A) -> A {
    return value
}


/// We can also have generic structs, classes, and enums.
///  For example, here’s the definition of Optional:
///
//enum Optional<Wrapped> {
//    case none
//    case some(Wrapped)
//}

/// When we choose a value for Wrapped, we get a concrete type.
/// For example, Optional<Int> or Optional<UIView> are both concrete types.
///
public func testOptionConcreteType() {
    
    let optionalInt = Optional.some(4)
    print(optionalInt as Any) // Optional(4)
}

/// Standard library has many Generic types such as Array, Dictionary, and Result
/// The Array type has a single generic parameter, Element.
///

// MARK: - Creating your own generic type
enum BinaryTree<Element> {
    case leaf
    indirect case node(Element, l: BinaryTree<Element>, r: BinaryTree<Element>)
}
/// Here Element is the generic parameter.  we have to choose a concrete type for Element. Let us pick Int
///

public func createBinaryTreeWithConcreteType() {
    let tree: BinaryTree<Int> = .node(5, l: .node(6, l: .leaf, r: .leaf), r: .node(7, l: .leaf, r: .leaf))
    print(tree.values)
}
/// Note: When we want to turn a generic type into a concrete type, we have to choose exactly one concrete type for each generic parameter.
/// eg: let array: [String] = []
/// if we dont specify concrete type (String) in this case, Swift doesn’t know what concrete type to use for its elements:
///
/// Likewise, Swift doesn’t allow you to put values with different concrete types in an array unless you explicitly choose a type for the Array’s Element. By default, the compiler suggests choosing Any -> check eg below

public func havingDifferentTypeInArray() {
    let multipleTypes: [Any] = [1, "foo", true]
    print(multipleTypes)
}


// MARK: - Extending generic types
/// The generic parameter Element is available anywhere within the scope of BinaryTree
///  eg: we can freely use Element as if it were a concrete type when writing an extension on BinaryTree.
///
extension BinaryTree {
    
    init(_ value: Element) {
        self = .node(value, l: .leaf, r: .leaf)
    }
}

/// Computed property -> Collects all values and puts it in an array
///
extension BinaryTree {
    
    // inorder traversal
    var values: [Element] {
        
        switch self {
        case .leaf:
            return []
        case .node(let element, let l, let r):
            return l.values + [element] + r.values
        }
    }
}

///  We can also add generic methods -> introducing one more generic param inside a method -> within an extension that's cool
///  For example, we can add map, which has an additional generic parameter named T for the return type of the transformation function and the element type of the transformed tree.
///  Because we define map in an extension on BinaryTree, we can still use the generic Element parameter
extension BinaryTree {
    
    func map<T>(_ transform: (Element) -> T) -> BinaryTree<T> {
        
        switch self {
        case .leaf:
            return .leaf
        case let .node(el, left, right):
            return .node(transform(el),
                         l: left.map(transform),
                         r: right.map(transform))
        }
    }
}

// testing map func
public func testMapMethod() {
    
    let tree: BinaryTree<Int> = .node(5,
                                      l: .node(6, l: .leaf, r: .leaf),
                                      r: .node(7, l: .leaf, r: .leaf))
    
    let incremented: BinaryTree<Int> = tree.map { $0 + 1 }
    print(incremented.values)
}

/// generics aren’t just useful for collections;
/// they are also used throughout the Swift standard library.
///  For example:
/// #1 -> Optional uses a generic parameter to abstract over the wrapped type.
/// #2 -> Result has two generic parameters— one representing a successful value,and another    representing an error.
/// #3 -> Unsafe[Mutable]Pointerisgenericoverthepointee’stype.
/// #4 ->  Key paths are generic over both the root type and the resulting value type.
/// #5 ->  Ranges are generic over their bounds.


// MARK: - Generics vs. Any

