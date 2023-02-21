//
//  WeatherData.swift
//  Weather App
//
//  Created by Fady Salah on 16/02/2023.
//

import Foundation

struct WeatherData : Codable {
    let name : String
    let main : Main
    let weather : [Weather]
}


struct Main : Codable {
    let temp:Double
}

struct Weather : Codable {
    let description : String
    let id : Int
}
