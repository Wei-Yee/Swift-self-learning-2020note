import UIKit
import SwiftUI

//We looked at networking code previously, using URLSession. Let’s look at another example now, adding to the default SwiftUI template code:

Text("Hello, World!")
.onAppear {
    let url = URL(string: "https://www.apple.com")!
    URLSession.shared.dataTask(with: url) { data, response, error in
        if data != nil {
            print("We got data!")
        } else if let error = error {
            print(error.localizedDescription)
        }
    }.resume()
}
 

//If you recall, I said the completion closure will either have data or error set to a value – it can’t be both, and it can’t be neither, because both those situations don’t make sense. However, because URLSession doesn’t enforce this constraint for us we need to write code to handle the impossible cases, just to make sure all bases are covered.

//Swift has a solution for this confusion, and it’s a special data type called Result.

enum NetworkError: Error {
    case badURL, requestFailed, unknown
}

func fetchData(from urlString: String) -> Result<String, NetworkError> {
    .failure(.badURL)
}

//What we really want is a non-blocking call, which means we can’t send back our Result as a return value. Instead, we need to make our method accept two parameters: one for the URL to fetch, and one that is a completion closure that will be called with a value. This means the method itself returns nothing; its data is passed back using the completion closure, which is called at some point in the future.

func fetchData(from urlString: String, completion: (Result<String, NetworkError>) -> Void) {
    completion(.failure(.badURL))
}

//There is one small complexity here, and although I’ve mentioned it briefly before now it becomes important. When we pass a closure into a function, Swift needs to know whether it will be used immediately or whether it might be used later on. If it’s used immediately – the default – then Swift is happy to just run the closure. But if it’s used later on, then it’s possible whatever created the closure has been destroyed and no longer exists in memory, in which case the closure would also be destroyed and can no longer be run.

//To fix this, Swift lets us mark closure parameters as @escaping, which means “this closure might be used outside of the current run of this method, so please keep its memory alive until we’re done.”

//Here’s the third version of our function, which uses @escaping for the closure so we can call it asynchronously:

func fetchData(from urlString: String, completion: @escaping (Result<String, NetworkError>) -> Void) {
    DispatchQueue.main.async {
        completion(.failure(.badURL))
    }
}


//And now for our fourth version of the method we’re going to blend our Result code with the URLSession code from earlier. This will have the exact same function signature – accepts a string and a closure, and returns nothing – but now we’re going to call the completion closure in different ways:

//If the URL is bad we’ll call completion(.failure(.badURL)).
//If we get valid data back from our request we’ll convert it to a string then call completion(.success(stringData)).
//If we get an error back from our request we’ll call completion(.failure(.requestFailed)).
//If we somehow don’t get data or an error back then we’ll call completion(.failure(.unknown)).
//The only new thing there is how to convert a Data instance to a string. If you recall, you can go the other way using let data = Data(someString.utf8), and when converting from Data to String the code is somewhat similar:





//OK, it’s time for the fourth pass of our method:

func fetchData(from urlString: String, completion: @escaping (Result<String, NetworkError>) -> Void) {
    // check the URL is OK, otherwise return with a failure
    guard let url = URL(string: urlString) else {
        completion(.failure(.badURL))
        return
    }

    URLSession.shared.dataTask(with: url) { data, response, error in
        // the task has completed – push our work back to the main thread
        DispatchQueue.main.async {
            if let data = data {
                // success: convert the data to a string and send it back
                let stringData = String(decoding: data, as: UTF8.self)
                completion(.success(stringData))
            } else if error != nil {
                // any sort of network failure
                completion(.failure(.requestFailed))
            } else {
                // this ought not to be possible, yet here we are
                completion(.failure(.unknown))
            }
        }
    }.resume()
}



//https://www.hackingwithswift.com/books/ios-swiftui/understanding-swifts-result-type
