//
//  ViewController.swift
//  API
//
//  Created by student on 3/1/23.
//

import UIKit

class TableViewController: UITableViewController {

    var searchResponse: SearchResponse?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(NSLocalizedString("tableview_title", comment: ""))
        makeAPICall { searchResponse in
            self.searchResponse = searchResponse
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = searchResponse?.Search[indexPath.row].title
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchResponse?.Search.count ?? 0
    }
    
    func makeAPICall(completion: @escaping (SearchResponse?) -> Void) {
        print("start API call")
        
        let domain = "https://www.omdbapi.com/"
        let apiKey = "ee23633f"
        let searchQuery = "Harry%20Potter"
        
        
        guard let url = URL(string:"\(domain)?apikey=\(apiKey)&s=\(searchQuery)") else {
            completion(nil)
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            var searchResponse: SearchResponse?
            defer {completion(searchResponse)}
            if let error = error {
                print("Error with API call: \(error)")
                return
            }
//            200 means that it's connected
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode)
            else {
                print("Error with the response (\(String(describing: response))")
                return
            }
//            this code returns a long unstructured string
//            if let data = data,
//            let dataString = String(data: data, encoding: String.Encoding.utf8){
//            print(dataString)
            if let data = data,
               let response = try? JSONDecoder().decode(SearchResponse.self, from: data)
            {
                print("success")
                searchResponse = response
                print(response.Search.first?.type)
            } else {
                print("Something is wrong with decoding, probably.")
            }
        }
        task.resume()
    }
}

struct SearchResponse: Codable {
    let totalResults: String
    let Response: String
    let Search: [Movie]
    enum CodingKeys: String, CodingKey {
        case totalResults
        case Response
        case Search
    }
}

struct Movie: Codable {
    let title: String
    let year: Int
    let imdbID: String
    let type: String
    let poster: String
    
//      just type "CodingKey" for this to show
    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case imdbID
        case type = "Type"
        case poster = "Poster"
    }
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decode(String.self, forKey: .title)
        self.year = Int(try container.decode(String.self, forKey: .year)) ?? 0
        self.imdbID = try container.decode(String.self, forKey: .imdbID)
        self.type = try container.decode(String.self, forKey: .type)
        self.poster = try container.decode(String.self, forKey: .poster)
    }
    
    enum MovieType: String, Codable {
        case hello = "movie"
        case show = "series"
    }
}
