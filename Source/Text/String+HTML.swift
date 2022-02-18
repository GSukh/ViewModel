//
//  String+HTML.swift
//  YogaUI
//
//  Created by Grigoriy Sukhorukov on 30.09.2021.
//

import Foundation

extension String {
    func htmlAttributedString(size: CGFloat, color: UIColor, lineHeight: CGFloat) -> NSAttributedString? {
        guard !isEmpty else { return nil }
        let htmlTemplate = """
        <!doctype html>
        <html>
        <meta http-equiv="Content-Type"
        content="text/html; charset=UTF-8">
          <head>
            <style>
              body {
                color: \(color.hexString ?? "#000000");
                font-family: -apple-system;
                font-size: \(size)px;
                line-height: \(lineHeight)px;
              }
              body, h1, h2, h3, p {
                margin: 0;
                padding: 0;
              }
            </style>
          </head>
          <body>
            \(self)
          </body>
        </html>
        """
        guard let data = htmlTemplate.data(using: .utf8) else {
            return nil
        }

        return try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
    }
}
