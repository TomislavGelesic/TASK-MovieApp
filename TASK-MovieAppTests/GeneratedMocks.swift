// MARK: - Mocks generated from file: TASK-MovieApp/Common/CommonModels/MovieRepositoryImpl.swift at 2021-01-06 11:46:42 +0000

//
//  MovieRepositoryImpl.swift
//  TASK-MovieApp
//
//  Created by Tomislav Gelesic on 04.01.2021..
//

import Cuckoo
@testable import TASK_MovieApp

import Combine
import UIKit


class MockMovieRepositoryImpl: MovieRepositoryImpl, Cuckoo.ClassMock {
    
    typealias MocksType = MovieRepositoryImpl
    
    typealias Stubbing = __StubbingProxy_MovieRepositoryImpl
    typealias Verification = __VerificationProxy_MovieRepositoryImpl
    
    let cuckoo_manager = Cuckoo.MockManager.preconfiguredManager ?? Cuckoo.MockManager(hasParent: true)
    
    
    private var __defaultImplStub: MovieRepositoryImpl?
    
    func enableDefaultImplementation(_ stub: MovieRepositoryImpl) {
        __defaultImplStub = stub
        cuckoo_manager.enableDefaultStubImplementation()
    }
    
    
    
    
    
    override var networkService: MovieNetworkService {
        get {
            return cuckoo_manager.getter("networkService",
                                         superclassCall:
                                            
                                            super.networkService
                                         ,
                                         defaultCall: __defaultImplStub!.networkService)
        }
        
        set {
            cuckoo_manager.setter("networkService",
                                  value: newValue,
                                  superclassCall:
                                    
                                    super.networkService = newValue
                                  ,
                                  defaultCall: __defaultImplStub!.networkService = newValue)
        }
        
    }
    
    
    
    
    
    
    struct __StubbingProxy_MovieRepositoryImpl: Cuckoo.StubbingProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        
        init(manager: Cuckoo.MockManager) {
            self.cuckoo_manager = manager
        }
        
        
        var networkService: Cuckoo.ClassToBeStubbedProperty<MockMovieRepositoryImpl, MovieNetworkService> {
            return .init(manager: cuckoo_manager, name: "networkService")
        }
        
        
    }
    
    struct __VerificationProxy_MovieRepositoryImpl: Cuckoo.VerificationProxy {
        private let cuckoo_manager: Cuckoo.MockManager
        private let callMatcher: Cuckoo.CallMatcher
        private let sourceLocation: Cuckoo.SourceLocation
        
        init(manager: Cuckoo.MockManager, callMatcher: Cuckoo.CallMatcher, sourceLocation: Cuckoo.SourceLocation) {
            self.cuckoo_manager = manager
            self.callMatcher = callMatcher
            self.sourceLocation = sourceLocation
        }
        
        
        
        var networkService: Cuckoo.VerifyProperty<MovieNetworkService> {
            return .init(manager: cuckoo_manager, name: "networkService", callMatcher: callMatcher, sourceLocation: sourceLocation)
        }
        
        
        
    }
}

class MovieRepositoryImplStub: MovieRepositoryImpl {
    
    
    override var networkService: MovieNetworkService {
        get {
            
            //here i return mock json file
            return DefaultValueRegistry.defaultValue(for: (MovieNetworkService).self)
        }
        
        set { }
        
    }
    
    
    
    
    
}

