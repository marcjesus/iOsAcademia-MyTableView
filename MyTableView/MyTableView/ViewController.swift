//
//  ViewController.swift
//  MyTableView
//
//  Created by Marc Jesus on 28/11/2020.
//

import UIKit


struct Post: Decodable {
    let id: Int
    let title, body: String
}

class Service: NSObject {
    static let shared = Service()
    
    func fetchPosts(completion: () -> ()){
        guard let url = URL(string:"http://localhost:1337/posts") else {return}
        
        URLSession.shared.dataTask(with: url) { (data, resp, err) in
                
            if let err = err{
                print("Failed to fetch posts", err)
                return
            }
            
            guard let data = data else {return}
            
            do{
                let posts = try JSONDecoder().decode([Post].self, from: data)
                completion(.success(posts))
            } catch {
                completion(.failure(error))
            }
            
            
            print(String(data: data, encoding: .utf8) ?? "")
        
            
        }.resume()
        
    }
}


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet var tabla: UITableView!
    
    fileprivate func fetchPosts(){
        
        Service.shared.fetchPosts { (res) in
            switch res{
            case .failure(let err):
                    print("Failed to fetch posts:", err)
            case .success(let psots):
                print(posts)
        }
        }
    }
    
    
    
    var names = ["Maria","Jorge","Juan","Ana","Maria","Jorge","Juan","Ana","Maria","Jorge","Juan","Ana","Maria","Jorge","Juan","Ana","Maria","Jorge","Juan","Ana"]
    
    var posts = [Post]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tabla.delegate = self
        tabla.dataSource = self
        
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Posts"
        navigationItem.rightBarButtonItem = .init(title: "Create Post", style: .plain, target: self, action: #selector(handleCreatePos))
        
        fetchPosts()
  
    }
    
    
    @objc fileprivate func handleCreatePos(){
        print("Create Post")
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tabla.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = names[indexPath.row]
        return cell
    }
    

}

