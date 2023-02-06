import Foundation

public struct User: Codable {
    
    let userName: String
}

public struct BlogPost: Codable {
    let post: String
}

public enum NetworkError: Error {
    case NoDataError
}

public let webserviceURL = URL(string: "www.someBaseUrl.com") 
