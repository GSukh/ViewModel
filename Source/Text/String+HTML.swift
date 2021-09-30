//
//  String+HTML.swift
//  YogaUI
//
//  Created by Grigoriy Sukhorukov on 30.09.2021.
//

import Foundation

extension String {
    func htmlAttributedString(size: CGFloat, color: UIColor, lineHeight: CGFloat) -> NSAttributedString? {
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
