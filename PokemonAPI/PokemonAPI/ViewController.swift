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
    var offset = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureTableView()
        getPokemon()
    }

    
    func getPokemon(){
        NetworkManager.shared.getPokemons(page: offset) { [weak self] (result) in
            guard let self = self else { return }
            
            switch result {
            case.success(let pokemons):
                self.pokemons.append(contentsOf: pokemons)
                self.offset += 10
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
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

        ])
        
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
        let pokemon = pokemons[indexPath.row]
        cell.nameLabel.text = pokemon.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.section == tableView.numberOfSections - 1 && indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            
            self.getPokemon()
        }
    }
    
}

