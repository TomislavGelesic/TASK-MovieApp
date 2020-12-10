//
//  CoreDataManager.swift
//  TASK-MovieApp
//
//  Created by Tomislav Gelesic on 03/11/2020.
//

import UIKit
import CoreData

class CoreDataManager {
    //MARK: Properties
    static let sharedInstance = CoreDataManager()
    
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TASK-MovieApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
}

extension CoreDataManager {
    //MARK: Functions
    
    func saveContext () {
        
        let managedContext = persistentContainer.viewContext
        
        if managedContext.hasChanges {
            do {
                try managedContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func getMovies(_ option: SavedMoviesOptions) -> [Movie]? {
        
        var movies: [Movie]?
        
        let managedContext = persistentContainer.viewContext
        
        let request = Movie.fetchRequest() as NSFetchRequest<Movie>
        
        switch option {
        case .all:
            print("Getting all movies from core data...")
            
        case .favourite:
            request.predicate = NSPredicate(format: "favourite == YES")
            
        case .watched:
            request.predicate = NSPredicate(format: "watched == YES")
        }
        
        do {
            movies = try managedContext.fetch(request)
        } catch  {
            print(error)
        }
        
        if let movies = movies {
            return movies
        }
        return nil
        
    }
    
    func getMovie(for id: Int64) -> Movie? {
        
        let managedContext = persistentContainer.viewContext
        
        let request = Movie.fetchRequest() as NSFetchRequest<Movie>
        
        request.predicate = NSPredicate(format: "id == \(id)")
        
        do {
            
            let results = try managedContext.fetch(request)
             
            if results.count != 0 {
                return results.first
            }
            
            return nil
            
        } catch  {
            print(error)
            return nil
        }
    }
    
    func createMovie(from item: MovieResponseItem) -> Movie? {
        
        let managedContext = persistentContainer.viewContext
        
        let movie = Movie(context: managedContext)
        
        movie.setValue(Int64(item.id), forKey: "id")
        movie.setValue(item.title, forKey: "title")
        movie.setValue(item.overview, forKey: "overview")
        movie.setValue(item.posterPath, forKey: "imagePath")
        movie.setValue(getReleaseYear(releaseDate: item.releaseDate), forKey: "year")
        movie.setValue(false, forKey: "favourite")
        movie.setValue(false, forKey: "watched")
        
        return movie
    }
    
    func saveOrUpdateMovie(_ movie: Movie) {
        if var savedMovie = getMovie(for: movie.id) {
            savedMovie = movie
        }
        saveContext()
    }
    
    func deleteMovie(_ movie: Movie) {
        
        let managedContext = persistentContainer.viewContext
        
        managedContext.delete(movie)
        
        saveContext()
    }
    
    func deleteAll() {
        
        if let moviesToDelete = getMovies(.all) {
            
            for movie in moviesToDelete {
                deleteMovie(movie)
            }
        }
    }
    
    private func getReleaseYear(releaseDate: String) -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        guard let date = dateFormatter.date(from: releaseDate) else { return "-1" }
        
        dateFormatter.dateFormat = "yyyy"
        
        return dateFormatter.string(from: date)
    }
    
}



