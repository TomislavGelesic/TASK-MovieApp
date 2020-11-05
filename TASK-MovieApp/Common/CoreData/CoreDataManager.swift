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
    
    func saveNewMovie(_ movie: Movie) {
        
        let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
        
        var newMovie = Movie(context: managedContext)
        newMovie = movie
        
        CoreDataManager.sharedManager.saveContext()
    }
    
    func deleteMovie(_ movie: Movie) {
        
        let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
        
        managedContext.delete(movie)
        
        CoreDataManager.sharedManager.saveContext()
    }
    
    func updateMovie() {
        CoreDataManager.sharedManager.saveContext()
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
    
}



