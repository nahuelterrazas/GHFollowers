//
//  GFError.swift
//  GHFollowers
//
//  Created by Nahuel Terrazas on 21/06/2023.
//

import Foundation

enum GFError: String, Error {
    case invalidUsername  = "This username created an invalid request. Please try again"
    case unableToComplete = "Unable to check your request. Please check your internet conection"
    case invalidResponse  = "Invalid response from the server. Please try again"
    case invalidData      = "The data received from the server was invalid. Please try again"
}
