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
        let container = NSPersistentContainer(name: "MovieCoreDataModel")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
}

extension CoreDataManager {
    //MARK: Funcions
    
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
    
    func fetchAllCoreDataMovies() -> [MovieModel]? {
        let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext
        do {
            let coreDataMovies = try managedContext.fetch(MovieModel.fetchRequest()) as? [MovieModel]
            if let movieModels = coreDataMovies {
                return movieModels
            }
        } catch {
            print("ERROR in CoreDataManager.sharedManager.fetchAllCoreDataMovies() . . .")
        }
        return nil
    }
    
    func updateOrInsertMovieInCoreData (id: Int, favourite: Bool, watched: Bool) {
        guard let savedMovies = CoreDataManager.sharedManager.fetchAllCoreDataMovies() else { return }
        
        for savedMovie in savedMovies {
            if savedMovie.id == id {
                savedMovie.favourite = favourite
                savedMovie.watched = watched
                CoreDataManager.sharedManager.saveContext()
                return
            }
        }
        
        let newMovie = MovieModel(context: CoreDataManager.sharedManager.persistentContainer.viewContext)
        newMovie.id = Int64(id)
        newMovie.favourite = favourite
        newMovie.watched = watched
        
        CoreDataManager.sharedManager.saveContext()
    }
    
    func buttonTapped(button: ButtonSelection,id: Int) {
        
        switch button {
        
        case .favourite:
            
            if let savedMovies = CoreDataManager.sharedManager.fetchAllCoreDataMovies() {
                for savedMovie in savedMovies {
                    if savedMovie.id == id {
                        if savedMovie.favourite {
                            CoreDataManager.sharedManager.updateOrInsertMovieInCoreData(id: id, favourite: false, watched: savedMovie.watched)
                        }
                        else {
                            CoreDataManager.sharedManager.updateOrInsertMovieInCoreData(id: id, favourite: true, watched: savedMovie.watched)
                        }
                        return
                    }
                }
            }
            else {
                CoreDataManager.sharedManager.updateOrInsertMovieInCoreData(id: id, favourite: true, watched: false)
            }
            
        case .watched:
            
            if let savedMovies = CoreDataManager.sharedManager.fetchAllCoreDataMovies() {
                for savedMovie in savedMovies {
                    if savedMovie.id == id {
                        if savedMovie.watched {
                            CoreDataManager.sharedManager.updateOrInsertMovieInCoreData(id: id, favourite: savedMovie.favourite, watched: false)
                        }
                        else {
                            CoreDataManager.sharedManager.updateOrInsertMovieInCoreData(id: id, favourite: savedMovie.favourite, watched: true)
                        }
                        return
                    }
                }
            }
            else {
                CoreDataManager.sharedManager.updateOrInsertMovieInCoreData(id: id, favourite: false, watched: true)
            }
        }
        
    }
}



