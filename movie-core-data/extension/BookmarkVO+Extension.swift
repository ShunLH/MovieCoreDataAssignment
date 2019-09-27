//
//  BookMarkVO+Extension.swift
//  movie-core-data
//
//  Created by AcePlus Admin on 9/27/19.
//  Copyright © 2019 padc. All rights reserved.
//

import Foundation
import Foundation
import CoreData

class BookmarkVO {
    
    static func getBookmarkedList() -> [BookMark]? {
        let fetchRequest : NSFetchRequest<BookMark> = BookMark.fetchRequest()
        
        do {
            let data = try CoreDataStack.shared.viewContext.fetch(fetchRequest)
            if data.isEmpty {
                return nil
            }
            return data
        } catch {
            print("failed to fetch bookmarked list: \(error.localizedDescription)")
            return nil
        }
        
    }
    
    static func getBookmarkedListWithId(movieId : Int) -> [BookMark]? {
        
        let fetchRequest: NSFetchRequest<BookMark> = BookMark.fetchRequest()
        let predicate = NSPredicate(format: "id == %d", movieId)
        fetchRequest.predicate = predicate
        
        do {
            let data = try CoreDataStack.shared.viewContext.fetch(fetchRequest)
            
            print(data.count)
            if data.isEmpty {
                return nil
            }
            return data
        } catch {
            print("failed to fetch bookmark")
            return nil
        }
        
    }
    
    static func getIsBookmarked(movieId: Int) -> Bool {
        
        let fetchRequest : NSFetchRequest<BookMark> = BookMark.fetchRequest()
        let predicate = NSPredicate(format: "id == %d", movieId)
        fetchRequest.predicate = predicate
        
        do {
            let data = try CoreDataStack.shared.viewContext.fetch(fetchRequest)
            
            print(data.count)
            if data.isEmpty {
                return false
            }
            return true
        } catch {
            print("failed to fetch bookmark")
            return false
        }
        
    }
	
	static func saveBookmarkEntity(data : Int, context : NSManagedObjectContext) {
        
        var id = 0
        
        if data>0 {
            id = data
        } else {
            print("failed to save Bookmark")
            return
        }
     
        let bookMarked = BookMark(context: context)
        bookMarked.id = Int32(id)
         
        do {
            try context.save()
        } catch {
            print("failed to save bookmark \(id) : \(error.localizedDescription)")
        }
        
        
    }
    
    static func deleteBookmarkEntity(data : Int , context : NSManagedObjectContext) {
    
        var id = 0
        
        if data>0 {
            id = data
        } else {
            print("failed to save Bookmark")
            return
        }
        
        if let bookMarked = getBookmarkedListWithId(movieId: id) {
        
            do {
                print("deleting... \(bookMarked[0].id)")
                try context.delete(bookMarked[0])
                
                do {
                    try context.save()
                } catch {
                    print("failed to save deleted bookmark")
                }
                
            } catch {
                print("failed to delete bookmark")
            }
        }
        
    }
    
}
