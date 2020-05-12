//this is the note for codable and decodable
// function: conversion between Swift data types and JSON


import UIKit

// First, here’s some JSON to work with:
let json = """
[
    {
        "name": "Paul",
        "age": 38
    },
    {
        "name": "Andrew",
        "age": 40
    }
]
"""
let data = Data(json.utf8)
//The last line converts it to a Data object because that’s what Codable decoders work with.
//Next we need to define a Swift struct that will hold our finished data:



struct User: Codable {
    var name: String
    var age: Int
}

//Now we can go ahead and perform the decode:
let decoder = JSONDecoder()

do {
    let decoded = try decoder.decode([User].self, from: data)
    print(decoded[0].name)
} catch {
    print("Failed to decode JSON")
}

//https://www.hackingwithswift.com/articles/119/codable-cheat-sheet
