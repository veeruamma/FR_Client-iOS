//
//  APIRequest.swift
//  VeerFRiOS
//
//  Created by Veeresh Ittangihal on 08/01/21.
//

import Foundation

struct APIRequest {
    let resourceURL : URL
    
    init(endpoint : String) {
//        let resourceString = "http://192.168.56.227:5000/\(endpoint)"
        let resourceString = "http://192.168.0.136:5000/\(endpoint)"
        guard let resourceURL = URL(string: resourceString) else {
            fatalError()
        }
        self.resourceURL = resourceURL
    }
    
    func sendToWebServer(name: String, cvData: String, rows: String, cols: String){
        do{
            let parameterDictionary = ["name" : name, "cvData": cvData, "rows" : rows, "cols": cols]
            let httpBody = try JSONSerialization.data(withJSONObject: parameterDictionary, options: [])
            
            var urlRequest = URLRequest(url: resourceURL)
            urlRequest.httpMethod = "POST"
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
            urlRequest.httpBody = httpBody
            
            let dataTask = URLSession.shared.dataTask(with: urlRequest, completionHandler: handle(data: response: error: ))
            
            dataTask.resume()
                
        } catch{
            print(error)
        }
                
    }
    
    func handle(data: Data?, response: URLResponse?, error: Error?){
        if error != nil {
            print(error!)
            return
        }
        
        if let safeData = data {
            let dataString = String(data: safeData, encoding: .utf8)
            print(dataString!)
        }
    }
}

