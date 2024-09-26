//
//  XPlatform.swift
//  MyPackagedDocument
//
//  Created by Kaz Yoshikawa on 2024/09/25.
//  Copyright © 2024 Kaz Yoshikawa. All rights reserved.
//

import Foundation

#if canImport(AppKit)
import AppKit
typealias XResponder = NSResponder
typealias XDocument = NSDocument
typealias XViewController = NSViewController
typealias XTextView = NSTextView
extension XTextView {
	var text: String {
		get { return self.string }
		set { self.string = newValue }
	}
}
typealias XStoryboard = NSStoryboard
extension NSStoryboard {
	func instantiateInitialViewController() -> XViewController? {
		return self.instantiateInitialController() as? XViewController
	}
}
#elseif canImport(UIKit)
import UIKit
typealias XResponder = UIResponder
typealias XDocument = UIDocument
typealias XViewController = UIViewController
typealias XTextView = UITextView
typealias XStoryboard = UIStoryboard
extension UIResponder {
	var nextResponder: UIResponder? {
		return self.next
	}
}
@available(iOS 17.0, *)
extension UIDocumentViewController: DocumentAware {
}
#endif

protocol DocumentAware {
	var document: XDocument? { get }
}

extension XResponder {
	func findViewController() -> XViewController? {
		var nextResponder: XResponder? = self
		while let responder = nextResponder {
			if let viewController = responder as? XViewController {
				return viewController
			}
			nextResponder = responder.nextResponder
		}
		return nil
	}
	
	static func findDocument(responder: XResponder) -> XDocument? {
		var nextResponder: XResponder? = responder
		while let responder = nextResponder {
			if let viewController = responder as? XViewController {
				if let document = XViewController.findDocument(viewController: viewController) {
					return document
				}
			}
			nextResponder = responder.nextResponder
		}
		return nil
	}
	
	func findDocument() -> XDocument? {
		return XResponder.findDocument(responder: self)
	}
}

extension XViewController {
	static func findDocument(viewController: XViewController) -> XDocument? {
		var nextViewController: XViewController? = viewController
		while let viewController = nextViewController {
			if let documentAware = viewController as? DocumentAware, let document = documentAware.document {
				return document
			}
			nextViewController = viewController.parent
		}
		return nil
	}
}

extension String {
	func appendingPathComponent(_ pathComponent: String) -> String {
		return (self as NSString).appendingPathComponent(pathComponent)
	}
}
