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
    
    init() {}
    
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
    
    func getMovies(_ option: SavedMovies) -> [Movie]? {
        
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
    
    func updateMovie(_ movie: Movie) {
        
        if var savedMovie = getMovie(for: movie.id) {
            
            savedMovie = movie
            
            saveContext()
            
        }
    }
    
    func switchValueOnMovie(on id: Int64, for type: ButtonType ) {
        
        if var savedMovie = getMovie(for: id) {
            switch type {
            case .favourite:
                savedMovie.favourite = !savedMovie.favourite
            case .watched:
                savedMovie.watched = !savedMovie.watched
            }
            
            saveContext()
            
        }
    }
    
    func createMovie(_ movie: MovieItem) -> Movie {
        
        let managedContext = persistentContainer.viewContext
        
        let newMovie = Movie(context: managedContext)
        
        newMovie.id           = Int64(movie.id)
        newMovie.title        = movie.title
        newMovie.overview     = movie.overview
        newMovie.releaseDate  = movie.release_date
        newMovie.favourite    = false
        newMovie.watched      = false
        
        if let path = movie.poster_path {
            newMovie.posterPath = path
        }

        return newMovie
    }
    
    func deleteMovie(_ movie: Movie) {
        
        let managedContext = persistentContainer.viewContext
        
        managedContext.delete(movie)    }
    
}

extension CoreDataManager {
    //MARK: Private functions
    
    private func getMovie(for id: Int64) -> Movie? {
        let managedContext = persistentContainer.viewContext
        
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



