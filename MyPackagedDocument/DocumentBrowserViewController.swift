//
//  DocumentBrowserViewController.swift
//  MyPackagedDocument
//
//  Created by Kaz Yoshikawa on 10/12/19.
//  Copyright © 2019 Kaz Yoshikawa. All rights reserved.
//

import UIKit


class DocumentBrowserViewController: UIDocumentBrowserViewController, UIDocumentBrowserViewControllerDelegate {
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		delegate = self
		
		allowsDocumentCreation = true
		allowsPickingMultipleItems = false
		
		// Update the style of the UIDocumentBrowserViewController
		// browserUserInterfaceStyle = .dark
		// view.tintColor = .white
		
		// Specify the allowed content types of your application via the Info.plist.
		
		// Do any additional setup after loading the view.
	}
	
	static let mypackageKey = "mypackage"
	static let sampleKey = "sample"

	// MARK: UIDocumentBrowserViewControllerDelegate
	
	func documentBrowser(_ controller: UIDocumentBrowserViewController, didRequestDocumentCreationWithHandler importHandler: @escaping (URL?, UIDocumentBrowserViewController.ImportMode) -> Void) {
		print("\(#function)")
		var samplePackgaeURL = Bundle.main.url(forResource: Self.sampleKey, withExtension: Self.mypackageKey)!
		let isPackage = (try? samplePackgaeURL.resourceValues(forKeys: [.isPackageKey]).isPackage) ?? false
		print("isPackage=", isPackage)
		importHandler(samplePackgaeURL, .copy)
	}
	
	func documentBrowser(_ controller: UIDocumentBrowserViewController, didPickDocumentsAt documentURLs: [URL]) {
		print("\(#function)")
		guard let sourceURL = documentURLs.first else { return }
		
		// Present the Document View Controller for the first document that was picked.
		// If you support picking multiple items, make sure you handle them all.
		presentDocument(at: sourceURL)
	}
	
	func documentBrowser(_ controller: UIDocumentBrowserViewController, didImportDocumentAt sourceURL: URL, toDestinationURL destinationURL: URL) {
		print("\(#function)")
		// Present the Document View Controller for the new newly created document
		presentDocument(at: destinationURL)
	}
	
	func documentBrowser(_ controller: UIDocumentBrowserViewController, failedToImportDocumentAt documentURL: URL, error: Error?) {
		print("\(#function), error=", error)
		// Make sure to handle the failed import appropriately, e.g., by presenting an error message to the user.
	}
	
	// MARK: Document Presentation
	
	func presentDocument(at documentURL: URL) {
		
		let storyBoard = UIStoryboard(name: "Main", bundle: nil)
		let documentViewController = storyBoard.instantiateViewController(withIdentifier: "DocumentViewController") as! DocumentViewController
		documentViewController.document = Document(fileURL: documentURL)
		documentViewController.modalPresentationStyle = .fullScreen
		
		present(documentViewController, animated: true, completion: nil)
	}
}

