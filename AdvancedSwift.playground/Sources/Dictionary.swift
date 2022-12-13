import Foundation

public func dictMerge() {
    
    let filesData = ["vikhat": 1, "Ajinkya": 4, "amit": 6]

    let systemAccess = ["vikhyath": 4, "tabrez": 28]

    let appsData = ["krishna": 33, "manasa": 6]

    let merged = filesData.merging(appsData) { current, new in
        return current
    }.merging(systemAccess) { current, _ in
        return current
    }
    
    print(merged, terminator: " ")
}
