//
//  ViewController.swift
//  PokemonAPI
//
//  Created by Mondale on 5/15/20.
//  Copyright © 2020 Mondale. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var tableView = UITableView()
    var pokemons : [Pokemon] = []
    var page = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        getPokemon()
    }

    
    func getPokemon(){
        NetworkManager.shared.getPokemons(page: page) { [weak self] (result) in
            guard let self = self else { return }
            
            switch result {
            case.success(let pokemons):
                self.pokemons.append(contentsOf: pokemons)
                self.page += 1
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
            
        }
    }
    
    
    private func configureTableView(){
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = 100
        tableView.register(PokemonCell.self, forCellReuseIdentifier: "PokemonCell")
        
        tableView.delegate = self
        tableView.dataSource = self
        
        
        
    }
}

extension ViewController : UITableViewDelegate {
    
}

extension ViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        pokemons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PokemonCell", for: indexPath) as! PokemonCell
        let pokemon = pokemons[indexPath.row].name
        cell.nameLabel.text = pokemon
        return cell
    }
    
    
}

