import Explanation

let a = 17
let b = 25

let (result, code) = #stringify(a + b)

print("The value \(result) was produced by the code \"\(code)\"")


@StructInit
struct User {
    
    var firstname: String
    var lastname: String
    var email: String
    var phoneNumber: String
}


enum Direction {
    
    case north
    case south
    case east
    case west
    
    var title: String {
        switch self {
        case .north:
            return "North"
        case .south:
            return "South"
        case .east:
            return "East"
        case .west:
            return "West"
        }
    }
}

