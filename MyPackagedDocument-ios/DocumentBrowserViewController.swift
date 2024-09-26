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
		do {
			let directoryWrapper = TextDocument.packageFileWrapper(content: "Hello World")
			let filepath = NSTemporaryDirectory().appendingPathComponent(UUID().uuidString).appendingPathComponent("Untitled.\(Self.mypackageKey)")
			let fileURL = URL(fileURLWithPath: filepath)
			try FileManager.default.createDirectory(atPath: filepath, withIntermediateDirectories: true)
			try directoryWrapper.write(to: fileURL, options: .atomic, originalContentsURL: nil)
			importHandler(fileURL, .move)
		}
		catch {
			fatalError()
		}
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
		print("\(#function), error=", error ?? "nil")
		// Make sure to handle the failed import appropriately, e.g., by presenting an error message to the user.
	}
	
	// MARK: Document Presentation
	
	func presentDocument(at documentURL: URL) {
		let document = TextDocument(fileURL: documentURL)
		let textViewController = TextViewController.makeViewController(document: document)
		let navigationController = UINavigationController(rootViewController: textViewController)
		navigationController.modalPresentationStyle = .fullScreen
		present(navigationController, animated: true, completion: nil)
	}
}

