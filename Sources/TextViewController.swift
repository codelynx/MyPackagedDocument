//
//  TextViewController.swift
//  MyPackagedDocument
//
//  Created by Kaz Yoshikawa on 2024/09/25.
//  Copyright © 2024 Kaz Yoshikawa. All rights reserved.
//

import Foundation

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

class TextViewController: XViewController, DocumentAware {

	static func makeViewController(document: TextDocument) -> TextViewController {
		let viewController = XStoryboard(name: "TextViewController", bundle: nil).instantiateInitialViewController() as! TextViewController
		viewController.textDocument = document
		return viewController
	}

	private var textDocument: TextDocument!
	var document: XDocument? { return textDocument }
	@IBOutlet weak var textView: XTextView!

	override func viewDidLoad() {
		super.viewDidLoad()
		self.textView.delegate = self
	}
	
	#if canImport(UIKit)
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		assert(self.textDocument != nil)
		self.textDocument?.open { success in
			self.navigationItem.title = self.textDocument.fileURL.lastPathComponent
			self.textView.text = self.textDocument?.textContent
		}
	}
	#elseif canImport(AppKit)
	override func viewWillAppear() {
		super.viewWillAppear()
		assert(self.document != nil)
		self.textView.string = self.textDocument?.textContent ?? ""
	}
	#endif

	#if canImport(UIKit)
	override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		self.textDocument?.close()
	}
	#endif

	#if canImport(UIKit)
	@IBAction func dismissAction(_ sender: Any) {
		dismiss(animated: true) {
			self.document?.close(completionHandler: nil)
		}
	}
	#endif
}

#if canImport(AppKit)
extension TextViewController: NSTextViewDelegate {
	func textDidChange(_ notification: Notification) {
		assert(self.document != nil)
		self.textDocument?.textContent = self.textView.string
		self.textDocument.updateChangeCount(.changeDone)
	}
}
#endif

#if canImport(UIKit)
extension TextViewController: UITextViewDelegate {
	func textViewDidChange(_ textView: UITextView) {
		assert(self.document != nil)
		self.textDocument?.textContent = textView.text
		self.textDocument.updateChangeCount(.done)
	}
}
#endif
