//
//  DataPersistenceManager.swift
//  Netflix-Clone
//
//  Created by Georgy Ganev on 6.07.24.
//

import Foundation
import UIKit
import CoreData

enum DataBaseError: Error {
    case failedToSaveData
    case failedToFetchData
    case failedToDeleteData
}

class DataPersistenceManager {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    static let shared = DataPersistenceManager()
    
    private init() {}
    
    func saveItemToStorage(itemModel: Item, completion: @escaping(Result<Void, Error>) -> Void) {
        
        let item = MediaItem(context: context)
        
        item.name = itemModel.name
        item.title = itemModel.title
        item.id = Int64(itemModel.id)
        item.media_type = itemModel.media_type
        item.original_name = itemModel.original_name
        item.original_title = itemModel.original_title
        item.overview = itemModel.overview
        item.poster_path = itemModel.poster_path
        item.release_date = itemModel.release_date
        item.vote_count = Int64(itemModel.vote_count ?? 0)
        item.vote_average = itemModel.vote_average ?? 0.0
        
        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(DataBaseError.failedToSaveData))
        }
    }
    
    func fetchItemsFromStorage(completion: @escaping(Result<[MediaItem], Error>) -> Void) {
        
        let request: NSFetchRequest<MediaItem>
        request = MediaItem.fetchRequest()
        
        do {
            let items = try context.fetch(request)
            completion(.success(items))
            
        } catch {
            completion(.failure(DataBaseError.failedToFetchData))
        }
    }
    
    func deleteMediaItem(item: MediaItem, completion: @escaping(Result<Void, Error>) -> Void) {
        context.delete(item)
        
        do {
            try context.save()
            completion(.success(()))
        } catch {
            completion(.failure(DataBaseError.failedToDeleteData))
        }
    }
    
    
}
