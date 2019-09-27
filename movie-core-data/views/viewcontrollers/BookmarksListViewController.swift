//
//  BookmarksListViewController.swift
//  movie-core-data
//
//  Created by AcePlus Admin on 9/26/19.
//  Copyright © 2019 padc. All rights reserved.
//

import UIKit
import CoreData

class BookmarksListViewController: UIViewController {

	@IBOutlet weak var collectionViewBookmarksList : UICollectionView!
    var fetchResultController: NSFetchedResultsController<BookMark>!

    override func viewDidLoad() {
        super.viewDidLoad()
		initView()

		
		


    }
   func initView() {
		  
		  collectionViewBookmarksList.delegate = self
		  collectionViewBookmarksList.dataSource = self
		  collectionViewBookmarksList.backgroundColor = Theme.background

		  initBookMarksFetchRequest()

	  }

	fileprivate func initBookMarksFetchRequest(){
		let fetchRequest : NSFetchRequest<BookMark> = BookMark.fetchRequest()
		let sortDescriptor = NSSortDescriptor(key: "id", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchResultController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataStack.shared.viewContext, sectionNameKeyPath: nil, cacheName: "")
        fetchResultController.delegate = self

		do {
            try fetchResultController.performFetch()
			if let result = fetchResultController.fetchedObjects {
				print("result \(result.count)")

                if result.isEmpty {
					print("result \(result.count)")
//                    self.mBookmarkedList = result
                    collectionViewBookmarksList.reloadData()
                }
            }

		}catch {
            Dialog.showAlert(viewController: self, title: "Error", message: "Failed to fetch data from database")

		}
		
	}
}

extension BookmarksListViewController :UICollectionViewDataSource {
	func numberOfSections(in collectionView: UICollectionView) -> Int {
        return fetchResultController.sections?.count ?? 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchResultController.sections?[section].numberOfObjects ?? 0
    }
	
	func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
		guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BookmarksListCollectionViewCell.identifier,for: indexPath) as? BookmarksListCollectionViewCell else {
			return UICollectionViewCell()
		}
        let bookedmarkedVO = fetchResultController.object(at: indexPath)

        let movie = MovieVO.getMovieById(movieId: Int(bookedmarkedVO.id))
        cell.data = movie
		return cell
	}
	
	
}
extension BookmarksListViewController : UICollectionViewDelegate {
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let movieDetailsViewController = segue.destination as? MovieDetailsViewController {
            
            if let indexPaths = collectionViewBookmarksList.indexPathsForSelectedItems, indexPaths.count > 0 {
                let selectedIndexPath = indexPaths[0]
                let movieId = Int(fetchResultController.object(at: selectedIndexPath).id)
                let movie = MovieVO.getMovieById(movieId: movieId)
                
                movieDetailsViewController.movieId = movieId
                
                self.navigationItem.title = movie?.original_title ?? ""
            }
            
        }
    }
}

extension BookmarksListViewController : UICollectionViewDelegateFlowLayout{
	func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width / 3) - 10;
        return CGSize(width: width, height: width * 1.45)
    }
}

extension BookmarksListViewController : NSFetchedResultsControllerDelegate {
//	func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
//		switch type {
//		case .insert :
//            collectionViewBookmarksList.insertItems(at: [newIndexPath!])
//            break
//
//		case .delete :
//            collectionViewBookmarksList.insertItems(at: [newIndexPath!])
//            break
//			default:()
//		}
//	}
	func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
		   collectionViewBookmarksList.reloadData()
	   }
}
