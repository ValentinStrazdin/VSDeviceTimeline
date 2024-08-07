import UIKit

extension NSAttributedString {

    public convenience init(string: String?,
                            font: UIFont,
                            textColor: UIColor,
                            alignment: NSTextAlignment = .natural) {

        guard let string = string else {
            self.init()
            return
        }

        let attributes = Self.attributes(for: font, textColor: textColor, alignment: alignment)
        self.init(string: string, attributes: attributes)
    }

    public static func attributes(for font: UIFont,
                                  textColor: UIColor,
                                  alignment: NSTextAlignment = .natural) -> [NSAttributedString.Key: Any] {

        var attributes = [NSAttributedString.Key: Any]()

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = alignment

        attributes[.font] = font
        attributes[.foregroundColor] = textColor
        attributes[.paragraphStyle] = paragraphStyle

        return attributes
    }

}
