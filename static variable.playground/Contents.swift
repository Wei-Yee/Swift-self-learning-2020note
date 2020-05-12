import UIKit


//For example, here’s a Person class with one static property and one class property:
class Person {
    static var count: Int {
        return 250
    }

    class var averageAge: Double {
        return 30
    }
}

class Student: Person {
    // THIS ISN'T ALLOWED
    // override static var count: Int {
    //    return 150
    // }

    // THIS IS ALLOWED
    override class var averageAge: Double {
        return 19.5
    }
}

//If we created a Student class by inheriting from Person, trying to override count (the static property) would fail to compile if uncommented, whereas trying to override averageAge (the class property) is OK:
