//
//  DecoratorSample.swift
//  AllPatterns
//
//  Created by Austin's Macbook Pro M3 on 11/13/24.
//

import UIKit
import XCTest

private protocol ImageEditor: CustomStringConvertible {
    func apply() -> UIImage
}

private class ImageDecorator: ImageEditor {

    private var editor: ImageEditor

    required init(_ editor: ImageEditor) {
        self.editor = editor
    }

    func apply() -> UIImage {
        print(editor.description + " 적용됨")
        return editor.apply()
    }

    var description: String {
        return "ImageDecorator"
    }
}

extension UIImage: ImageEditor {

    func apply() -> UIImage {
        return self
    }

    open override var description: String {
        return "Image"
    }
}

private class BaseFilter: ImageDecorator {

    var filter: CIFilter?

    init(editor: ImageEditor, filterName: String) {
        self.filter = CIFilter(name: filterName)
        super.init(editor)
    }

    required init(_ editor: ImageEditor) {
        super.init(editor)
    }

    override func apply() -> UIImage {

        let image = super.apply()
        let context = CIContext(options: nil)

        filter?.setValue(CIImage(image: image), forKey: kCIInputImageKey)

        guard let output = filter?.outputImage else { return image }
        guard let coreImage = context.createCGImage(output, from: output.extent) else {
            return image
        }
        return UIImage(cgImage: coreImage)
    }

    override var description: String {
        return "BaseFilter"
    }
}

private class BlurFilter: BaseFilter {

    required init(_ editor: ImageEditor) {
        super.init(editor: editor, filterName: "CIGaussianBlur")
    }

    func update(radius: Double) {
        filter?.setValue(radius, forKey: "inputRadius")
    }

    override var description: String {
        return "BlurFilter"
    }
}

private class ColorFilter: BaseFilter {

    required init(_ editor: ImageEditor) {
        super.init(editor: editor, filterName: "CIColorControls")
    }

    func update(saturation: Double) {
        filter?.setValue(saturation, forKey: "inputSaturation")
    }

    func update(brightness: Double) {
        filter?.setValue(brightness, forKey: "inputBrightness")
    }

    func update(contrast: Double) {
        filter?.setValue(contrast, forKey: "inputContrast")
    }

    override var description: String {
        return "ColorFilter"
    }
}

private class Resizer: ImageDecorator {

    private var xScale: CGFloat = 0
    private var yScale: CGFloat = 0
    private var hasAlpha = false

    private convenience init(_ editor: ImageEditor, xScale: CGFloat = 0, yScale: CGFloat = 0, hasAlpha: Bool = false) {
        self.init(editor)
        self.xScale = xScale
        self.yScale = yScale
        self.hasAlpha = hasAlpha
    }

    required init(_ editor: ImageEditor) {
        super.init(editor)
    }

    override func apply() -> UIImage {

        let image = super.apply()

        let size = image.size.applying(CGAffineTransform(scaleX: xScale, y: yScale))

        UIGraphicsBeginImageContextWithOptions(size, !hasAlpha, UIScreen.main.scale)
        image.draw(in: CGRect(origin: .zero, size: size))

        let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return scaledImage ?? image
    }

    override var description: String {
        return "Resizer"
    }
}

private class DecoratorRealWorld: XCTestCase {

    func testDecoratorRealWorld() {

        let image = loadImage()

        print("클라이언트: 편집기 스택을 설정합니다.")
        let resizer = Resizer(image)

        let blurFilter = BlurFilter(resizer)
        blurFilter.update(radius: 2)

        let colorFilter = ColorFilter(blurFilter)
        colorFilter.update(contrast: 0.53)
        colorFilter.update(brightness: 0.12)
        colorFilter.update(saturation: 4)

        clientCode(editor: colorFilter)
    }

    private func clientCode(editor: ImageEditor) {
        let image = editor.apply()
        /// 참고: Xcode에서 실행을 중지하면 이미지 미리보기를 볼 수 있습니다.
        print("클라이언트: 모든 변경 사항이 \(image)에 적용되었습니다.")
    }
}

private extension DecoratorRealWorld {

    func loadImage() -> UIImage {

        let urlString = "https:// refactoring.guru/images/content-public/logos/logo-new-3x.png"

        /// 참고:
        /// 프로덕션 코드에서는 다음과 같은 방식으로 이미지를 다운로드하지 마세요.

        guard let url = URL(string: urlString) else {
            fatalError("올바른 URL을 입력하세요.")
        }

        guard let data = try? Data(contentsOf: url) else {
            fatalError("이미지를 로드할 수 없습니다.")
        }

        guard let image = UIImage(data: data) else {
            fatalError("데이터에서 이미지를 생성할 수 없습니다.")
        }
        return image
    }
}

