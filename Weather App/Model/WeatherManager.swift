//
//  WeatherManager.swift
//  Weather App
//
//  Created by Fady Salah on 13/02/2023.
//

import Foundation
import CoreLocation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager:WeatherManager, weather:WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager{
    let weatherURL = "https://api.openweathermap.org/data/2.5/weather?appid=db1401fa1ad24a2b9f7d176f17b13275&units=metric"
    
    var delegate : WeatherManagerDelegate?

    func fetchWeather(cityName:String){
        let urlString = "\(weatherURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    func fetchWeather(latitude:CLLocationDegrees, longitude: CLLocationDegrees){
        let urlString = "\(weatherURL)&lat=\(latitude)&lon=\(longitude)"
        performRequest(with: urlString)
    }
    
    func performRequest(with urlString : String){
        if let url = URL(string: urlString){
            let  session = URLSession(configuration: .default)
            let task =  session.dataTask(with: url) { data, response, error in
                if error != nil{
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data{
                    if let weather = self.parseJSON(safeData){
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            
            task.resume()
        }
    }
    func parseJSON(_ weatherData :Data)-> WeatherModel?{
        let decoder = JSONDecoder()
        do{
         let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let name = decodedData.name
            
            let weather = WeatherModel(conditionId: id, cityName: name, tempreature: temp)
            return weather
            
        }
        catch{
            delegate?.didFailWithError(error: error)
            return nil
        }
        
    }
    
   
}

