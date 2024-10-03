import Dependencies
import Foundation

public struct ClipboardClient {
    public var copyString: (String) -> Void
    public var getString: () -> String?
    public var copyAttributedString: (NSAttributedString) -> Void
    public var getAttributedString: () -> NSAttributedString?
}

#if os(macOS)
    import Cocoa

    extension ClipboardClient: DependencyKey {
        public static var liveValue: Self {
            Self(
                copyString: { text in
                    NSPasteboard.general.clearContents()
                    NSPasteboard.general.setString(text, forType: .string)
                },
                getString: { NSPasteboard.general.string(forType: .string) },
                copyAttributedString: { attributedText in
                    NSPasteboard.general.clearContents()
                    NSPasteboard.general.writeObjects([attributedText])
                },
                getAttributedString: {
                    NSPasteboard.general.readObjects(forClasses: [NSAttributedString.self], options: nil)?.first as? NSAttributedString
                }
            )
        }
    }
#endif

#if os(iOS)
    import UIKit

    extension ClipboardClient: DependencyKey {
        public static var liveValue: Self {
            Self(
                copyString: { text in
                    UIPasteboard.general.string = text
                },
                getString: { UIPasteboard.general.string },
                copyAttributedString: { attributedText in
                    UIPasteboard.general.string = attributedText.string
                    UIPasteboard.general.addItems([[NSAttributedString.Key.documentType: NSAttributedString.DocumentType.rtf,
                                                    NSAttributedString.Key.rtf: try! attributedText.data(from: NSRange(location: 0, length: attributedText.length),
                                                                                                         documentAttributes: [.documentType: NSAttributedString.DocumentType.rtf])]])
                },
                getAttributedString: {
                    guard let data = UIPasteboard.general.data(forPasteboardType: "public.rtf") else { return nil }
                    return try? NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.rtf], documentAttributes: nil)
                }
            )
        }
    }
#endif

extension DependencyValues {
    public var clipboard: ClipboardClient.Value {
        get { self[ClipboardClient.self] }
        set { self[ClipboardClient.self] = newValue }
    }
}
