//
//  Document.swift
//  MyPackagedDocument
//
//  Created by Kaz Yoshikawa on 10/12/19.
//  Copyright © 2019 Kaz Yoshikawa. All rights reserved.
//

import UIKit

class Document: UIDocument {
    
    var fileWrapper = FileWrapper(directoryWithFileWrappers:[:])
    
    override init(fileURL url: URL) {
    	print("\(#function)")
    	super.init(fileURL: url)
	}
    
    override func contents(forType typeName: String) throws -> Any {
    	print("\(#function)")
		return self.fileWrapper
    }
    
    override func load(fromContents contents: Any, ofType typeName: String?) throws {
    	print("\(#function)")
		if let fileWrapper = contents as? FileWrapper {
			self.fileWrapper = fileWrapper
			if let item = fileWrapper.fileWrappers?["contents.plist"] {
				if let fileContents = item.regularFileContents {
					if let dictionary = try? PropertyListSerialization.propertyList(from: fileContents, options: [], format: nil) as? NSDictionary {
						print(dictionary)
					}
				}
			}
		}
    }

	override func handleError(_ error: Error, userInteractionPermitted: Bool) {
    	print("\(#function)")
		print(error)
		super.handleError(error, userInteractionPermitted: userInteractionPermitted)
	}

	override func finishedHandlingError(_ error: Error, recovered: Bool) {
		print("\(#function)")
		print(error)
		super.finishedHandlingError(error, recovered: recovered)
	}

	override func userInteractionNoLongerPermitted(forError error: Error) {
    	print("\(#function)")
		print(error)
		super.userInteractionNoLongerPermitted(forError: error)
	}

    override var savingFileType: String? {
    	print("\(#function)")
    	return "com.example.mypackage"
    }

	override func fileAttributesToWrite(to url: URL, for saveOperation: UIDocument.SaveOperation) throws -> [AnyHashable : Any] {
    	print("\(#function), url=", url)
		var attributes = try super.fileAttributesToWrite(to: url, for: saveOperation)
		attributes[URLResourceKey.thumbnailDictionaryKey] = UIImage(named: "mypackage_320.png")!
		return attributes
	}
}

