//
//  Document.swift
//  MyPackagedDocument
//
//  Created by Kaz Yoshikawa on 2024/09/25.
//  Copyright © 2024 Kaz Yoshikawa. All rights reserved.
//

#if canImport(AppKit)
import AppKit
#endif

#if canImport(UIKit)
import UIKit
#endif

class TextDocument: XDocument {

	static let textFileName = "content.txt"
	static let documentType: String = "com.electricwoods.mypackage"
	var textContent: String = ""

	#if canImport(UIKit)
	override init(fileURL url: URL) {
		print(Self.self, #function, "url=", url.path)
		super.init(fileURL: url)
	}
	override func contents(forType typeName: String) throws -> Any {
		print(Self.self, #function)
		return self.packageFileWrapper()
	}
	override func load(fromContents contents: Any, ofType typeName: String?) throws {
		guard typeName == Self.documentType else { fatalError("do the right thing") }
		print(Self.self, #function)
		guard let fileWrapper = contents as? FileWrapper else { fatalError("do the right thing") }
		try self.readPackage(from: fileWrapper)
	}
	override func handleError(_ error: Error, userInteractionPermitted: Bool) {
		print(Self.self, #function)
		print(error)
		super.handleError(error, userInteractionPermitted: userInteractionPermitted)
	}
	override func finishedHandlingError(_ error: Error, recovered: Bool) {
		print(Self.self, #function)
		print(error)
		super.finishedHandlingError(error, recovered: recovered)
	}
	override func userInteractionNoLongerPermitted(forError error: Error) {
		print(Self.self, #function)
		print(error)
		super.userInteractionNoLongerPermitted(forError: error)
	}
	override var savingFileType: String? {
		print(Self.self, #function)
		return TextDocument.documentType
	}
	#endif

	#if canImport(AppKit)
	override class var autosavesInPlace: Bool {
		return true
	}
	override func makeWindowControllers() {
		let viewController = TextViewController.makeViewController(document: self)
		let window = NSWindow(contentViewController: viewController)
		window.setContentSize(NSSize(width: 800, height: 600))
		window.title = "My Document"
		let windowController = NSWindowController(window: window)
		self.addWindowController(windowController)
	}
	override func fileWrapper(ofType typeName: String) throws -> FileWrapper {
		return self.packageFileWrapper()
	}
	override func read(from fileWrapper: FileWrapper, ofType typeName: String) throws {
		guard typeName == Self.documentType else {
			throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
		}
		if let textFileWrapper = fileWrapper.fileWrappers?[Self.textFileName],
		   let fileData = textFileWrapper.regularFileContents,
		   let content = String(data: fileData, encoding: .utf8) {
			self.textContent = content
		} else {
			throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
		}
	}
	#endif
	func packageFileWrapper() -> FileWrapper {
		return Self.packageFileWrapper(content: self.textContent)
	}
	func readPackage(from fileWrapper: FileWrapper) throws {
		if let textFileWrapper = fileWrapper.fileWrappers?[Self.textFileName],
		   let fileData = textFileWrapper.regularFileContents,
		   let content = String(data: fileData, encoding: .utf8) {
			self.textContent = content
		} else {
			fatalError("do the right thing")
		}
	}
	static func packageFileWrapper(content: String) -> FileWrapper {
		var fileWrappers = [String: FileWrapper]()
		let contentsData = content.data(using: .utf8)!
		let textFileWrapper = FileWrapper(regularFileWithContents: contentsData)
		textFileWrapper.preferredFilename = Self.textFileName
		fileWrappers[Self.textFileName] = textFileWrapper
		let packageFileWrapper = FileWrapper(directoryWithFileWrappers: fileWrappers)
		return packageFileWrapper
	}
	static func makeInitialDocument(fileURL: URL) {
	}
}

