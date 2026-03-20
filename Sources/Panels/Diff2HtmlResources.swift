// Loads diff2html CSS and JS from bundle resource files at first access.
// The raw .min.css and .min.js files live in Resources/.

import Foundation

enum Diff2HtmlResources {
    static let css: String = {
        guard let url = Bundle.main.url(forResource: "diff2html.min", withExtension: "css"),
              let content = try? String(contentsOf: url, encoding: .utf8) else {
            assertionFailure("diff2html.min.css not found in bundle")
            return ""
        }
        return content
    }()

    static let javaScript: String = {
        guard let url = Bundle.main.url(forResource: "diff2html.min", withExtension: "js"),
              let content = try? String(contentsOf: url, encoding: .utf8) else {
            assertionFailure("diff2html.min.js not found in bundle")
            return ""
        }
        return content
    }()
}
