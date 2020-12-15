//
//  CoreDataManager.swift
//  TASK-MovieApp
//
//  Created by Tomislav Gelesic on 03/11/2020.
//

import UIKit
import CoreData

// +++++++++++++++++
#warning("Should CoreData be refactored to save object with all information for DetailScreen and NowPlayingTab? How?")
// ++++++++++++++++

class CoreDataManager {
    
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
    
    func getMovies(_ option: SavedMoviesOptions) -> [MovieRowItem]? {
        
        let managedContext = persistentContainer.viewContext
        
        let request = Movie.fetchRequest() as NSFetchRequest<Movie>
        
        switch (option) {
        
        case .all:
            break
        case .favourite:
            request.predicate = NSPredicate(format: "favourite == YES")
            break
        case .watched:
            request.predicate = NSPredicate(format: "watched == YES")
            break
        }
        
        do {
            let savedMovies = try managedContext.fetch(request)
            
            var movies = [MovieRowItem]()
            
            for movie in savedMovies {
                movies.append(MovieRowItem(movie))
            }
            
            return movies

        } catch  {
            print(error)
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
    
    func updateMovie(_ movie: MovieRowItem) {
        
        if !movie.favourite,!movie.watched {
            deleteMovie(movie)
        }
        else if let savedMovie = getMovie(for: movie.id) {
            
            savedMovie.favourite = movie.favourite
            savedMovie.watched = movie.watched
            saveContext()
        }
        else {
            
            saveMovie(from: movie)
        }
    }
    
    func saveMoviePreference(id: Int64, on buttonType: ButtonType, value: Bool) {
    
        if let savedMovie = getMovie(for: id) {
            
            switch buttonType {
            case .favourite:
                savedMovie.favourite = value
                break
            case .watched:
                savedMovie.watched = value
                break
                
            }
            
            if !savedMovie.favourite, !savedMovie.watched {
                deleteMovie(savedMovie)
            }
            
            saveContext()
            
            print("savedMovie \n\tid: \(savedMovie.id), favourite: \(savedMovie.favourite), watched: \(savedMovie.watched)")
        }
        else { // if doesn't exist save new one to CoreData
            
            switch buttonType {
            case .favourite:
                saveMovie(id: id, preference: true, buttonType: buttonType)
                break
            case .watched:
                saveMovie(id: id, preference: true, buttonType: buttonType)
                break
                
            }
            
            print("savedMovie \n\tid: \(id), set: true on btnType: \(buttonType)")
        }
        
        
    }
        
    
    private func saveMovie(from item: MovieRowItem) {
        
        let managedContext = persistentContainer.viewContext
        
        let movie = Movie(context: managedContext)
        
        movie.setValue(Int64(item.id), forKey: "id")
        movie.setValue(item.title, forKey: "title")
        movie.setValue(item.overview, forKey: "overview")
        movie.setValue(item.imagePath, forKey: "imagePath")
        movie.setValue(item.year, forKey: "year")
        movie.setValue(item.favourite, forKey: "favourite")
        movie.setValue(item.watched, forKey: "watched")
        
        saveContext()
        
        if let _ = getMovie(for: movie.id) { return }
        else {
            print("(WARNING) Couldn't save new movie to Core Data. (WARNING)")
            return
        }
    }
    
    
    private func saveMovie(id: Int64, preference: Bool, buttonType: ButtonType) {
        
        let managedContext = persistentContainer.viewContext
        
        let movie = Movie(context: managedContext)
        
        movie.setValue(Int64(id), forKey: "id")
        
        switch buttonType {
        case .favourite:
            movie.setValue(preference, forKey: "favourite")
            break
        case .watched:
            movie.setValue(preference, forKey: "watched")
            break
        }
        
        saveContext()
        
        if let _ = getMovie(for: movie.id) { return }
        else {
            print("(WARNING) Couldn't save new movie to Core Data. (WARNING)")
            return
        }
    }
    
    func deleteMovie(_ movie: MovieRowItem) {
        
        if let savedMovie = getMovie(for: movie.id) {
            
            let managedContext = persistentContainer.viewContext
            
            managedContext.delete(savedMovie)
            
            saveContext()
        }
    }
    
    func deleteMovie(_ movie: Movie) {
        
        if let savedMovie = getMovie(for: movie.id) {
            
            let managedContext = persistentContainer.viewContext
            
            managedContext.delete(savedMovie)
            
            saveContext()
        }
    }
    
    func deleteAll() {
        
        if let moviesToDelete = getMovies(.all) {
            
            for movie in moviesToDelete {
                deleteMovie(movie)
            }
        }
    }
    
    
    
}



