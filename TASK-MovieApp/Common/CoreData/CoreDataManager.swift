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
    static let sharedManager = CoreDataManager()
    
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
        let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
        if managedContext.hasChanges {
            do {
                try managedContext.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func getAllMovies() -> [Movie]? {
        
        var movies: [Movie]?
        
        let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
        
        do {
            movies = try managedContext.fetch(Movie.fetchRequest())
        } catch { print(error) }
        
        if let movies = movies {
            return movies
        }
        return nil
    }
    
    func saveJSONModel(_ json: MovieJSONModel) {
        
        let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
        
        let newMovie = Movie(context: managedContext)
        
        newMovie.id = Int64(json.id)
        newMovie.title = json.title
        newMovie.overview = json.overview
        newMovie.posterPath = json.poster_path
        newMovie.releaseDate = json.release_date
        newMovie.favourite = false
        newMovie.watched = false
        
        var genreIDs = String()
        
        for id in json.genre_ids {
            genreIDs.append("\(id), ")
        }
        newMovie.genreIDs = genreIDs
        
        CoreDataManager.sharedManager.saveContext()
    }
    
    func updateMovie() {
        CoreDataManager.sharedManager.saveContext()
    }
    
    func switchForId(type: ButtonType, for id: Int64) {
        
        let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
        
        let request = Movie.fetchRequest() as NSFetchRequest<Movie>
        request.predicate = NSPredicate(format: "id == \(id)")
        var movies: [Movie]?
        do {
            movies = try managedContext.fetch(request)
        } catch  {
            print(error)
            return
        }
        
        if let movies = movies {
            
            switch type {
            case .favourite:
                if movies[0].favourite == true {
                    movies[0].favourite = false
                }
                else {
                    movies[0].favourite = true
                }
                CoreDataManager.sharedManager.saveContext()
                
                
            case .watched:
                if movies[0].watched == true {
                    movies[0].watched = false
                }
                else {
                    movies[0].watched = true
                }
                CoreDataManager.sharedManager.saveContext()
            }
        } else {
            print("unseccesfull switchForId()")
        }
        
        
    }
    
    func getFavouriteMovies() -> [Movie]? {
        let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
        let request = Movie.fetchRequest() as NSFetchRequest<Movie>
        request.predicate = NSPredicate(format: "favourite == YES")
        var movies: [Movie]?
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
    
    func getWatchedMovies() -> [Movie]? {
        let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
        let request = Movie.fetchRequest() as NSFetchRequest<Movie>
        request.predicate = NSPredicate(format: "watched == YES")
        var movies: [Movie]?
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
    
    func checkButtonStatus(for id: Int64, and type: ButtonType) -> Bool? {
        let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
        
        let request = Movie.fetchRequest() as NSFetchRequest<Movie>
        request.predicate = NSPredicate(format: "id == \(id)")
        var movies: [Movie]?
        do {
            movies = try managedContext.fetch(request)
        } catch  {
            print(error)
            return nil
        }
        
        if let movies = movies {
            
            switch type {
            case .favourite:
                if movies[0].favourite == true {
                    return true
                }
                else {
                    return false
                }
            case .watched:
                if movies[0].watched == true {
                    return true
                }
                else {
                    return false
                }
            }
        }
        return nil
    }
    
    
    func getMovie(for id: Int64, and type: ButtonType) -> Movie? {
        let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
        
        let request = Movie.fetchRequest() as NSFetchRequest<Movie>
        request.predicate = NSPredicate(format: "id == \(id)")
        var movies: [Movie]?
        do {
            movies = try managedContext.fetch(request)
        } catch  {
            print(error)
            return nil
        }
        
        if let movies = movies {
            
            return movies[0]
        }
        return nil
    }
    
}



