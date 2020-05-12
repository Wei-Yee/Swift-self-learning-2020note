import UIKit

let driving = {(place:String) in
    print("I'm going to \(place) in my car")
}

driving("London")

let drivingWithReturn = { (place:String) -> String in
    return "I'm going to \(place) in my car"
}

let message = drivingWithReturn("London")
print(message)

func travel(action:() -> Void) {
    print ("I'm getting ready to go")
    action()
    print("I arrived")
}

travel(action: driving)
