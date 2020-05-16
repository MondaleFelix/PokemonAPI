//
//  NetworkManager.swift
//  NewsApp
//
//  Created by Mondale on 5/15/20.
//  Copyright © 2020 Mondale. All rights reserved.
//

import UIKit

class NetworkManager {
    
    // Creates singleton
    static let shared = NetworkManager()
    private init(){}
    
    let baseURL = "https://pokeapi.co/api/v2/pokemon?limit=10"

    
    func getPokemons(page:Int, completed: @escaping(Result<[Pokemon], ErrorMessage>) -> Void){
        
        let endpoint = baseURL + "&page=\(page)"
        
        // Returns if URL is invalid
        guard let url = URL(string: endpoint) else {
            completed(.failure(.invalidUrl))
            return
        }
        
    
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            // Returns if error exists
            if let _ = error {
                completed(.failure(.unableToComplete))
                return
            }
            
            // Returns if response is not successful status code
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(.failure(.unableToComplete))
                return
            }
            
            // Returns if data is invalid
            guard let data = data else {
                completed(.failure(.invalidData))
                return
            }
            
            // Trys to decode data, throws failure if invalid
            
            do {
                let decoder = JSONDecoder()
                let response = try decoder.decode(PokemonList.self, from: data)
                let pokemons = response.results

                completed(.success(pokemons))
                
            } catch {
                completed(.failure(.invalidData))
            }
        }
        task.resume()
    }

}
