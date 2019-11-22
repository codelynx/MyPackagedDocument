# MyPackagedDocument

![xcode](https://img.shields.io/badge/Xcode-11.1-blue)
![swift](https://img.shields.io/badge/Swift-5.1-orange.svg)
![license](https://img.shields.io/badge/License-MIT-yellow.svg)

This is an example project for iOS to demonstrate how to create and load packaged based `UIDocument` from `UIDocumentBrowserViewController`.

It seems there aren't so much "working" example projects or codes how to handle packaged based `UIDocument`.  And I was having hard time to make it work, because `UIDocumentBrowserViewController` did not treat my package folders as a document, rather they are treated as just folders.

<img src="https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/65634/55defc31-724a-ab3a-d50e-8f6fcdeea5a1.png" width="600"/>

I just commit this project because I just made this project working.  `UIDocumentBrowserViewController` treats my folders as a document rather than a simple folder.  There are so many try and errors on my project, and some keys and values can be removed to simplify this project.  Anyway, I check this project in before I break this project.

This project is worked on following environment:

```
Xcode 11.1
Swift 5.1
iOS 12
```
### License

The MIT License
