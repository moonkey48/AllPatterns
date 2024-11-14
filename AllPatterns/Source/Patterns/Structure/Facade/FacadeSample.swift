//
//  FacadeSample.swift
//  AllPatterns
//
//  Created by Austin's Macbook Pro M3 on 11/14/24.
//

import Foundation
import XCTest

/// 퍼사드 디자인 패턴
///
/// 의도: 라이브러리, 프레임워크 또는 기타 복잡한 클래스 집합에 대한 단순화된 인터페이스를 제공합니다.

private class FacadeRealWorld: XCTestCase {

    /// 실제 프로젝트에서는 서드파티 라이브러리를 사용할 가능성이 높습니다.
    /// 예를 들어, 이미지를 다운로드할 때 사용합니다.
    ///
    /// 따라서 퍼사드를 사용하여 서드파티 API를 클라이언트 코드에서 래핑하는 것이 좋습니다.
    /// 프로젝트에 연결된 자신의 라이브러리일지라도 동일하게 적용할 수 있습니다.
    ///
    /// 이 접근 방식의 장점은 다음과 같습니다:
    ///
    /// 1) 현재 이미지 다운로드 방식을 변경해야 할 때, 프로젝트의 한 곳에서만 변경하면 됩니다.
    ///    클라이언트 코드의 줄 수는 그대로 유지됩니다.
    ///
    /// 2) 퍼사드는 대부분의 클라이언트 요구에 맞는 기능의 일부에 대한 액세스를 제공합니다.
    ///    또한, 자주 사용되거나 기본값으로 설정되는 매개변수를 설정할 수 있습니다.

    func testFacedeRealWorld() {

        let imageView = UIImageView()

        print("이미지 뷰에 이미지를 설정해봅시다.")

        clientCode(imageView)

        print("이미지가 설정되었습니다.")

        XCTAssert(imageView.image != nil)
    }

    fileprivate func clientCode(_ imageView: UIImageView) {

        let url = URL(string: "www.example.com/logo")
        imageView.downloadImage(at: url)
    }
}

private extension UIImageView {

    /// 이 확장은 퍼사드 역할을 합니다.

    func downloadImage(at url: URL?) {

        print("다운로드 시작...")

        let placeholder = UIImage(named: "placeholder")

        ImageDownloader().loadImage(at: url,
                                    placeholder: placeholder,
                                    completion: { image, error in
            print("이미지 처리 중...")

            /// 자르기, 캐싱, 필터 적용 등...

            self.image = image
        })
    }
}

private class ImageDownloader {

    /// 서드파티 라이브러리 또는 자체 솔루션 (하위 시스템)

    typealias Completion = (UIImage, Error?) -> ()
    typealias Progress = (Int, Int) -> ()

    func loadImage(at url: URL?,
                   placeholder: UIImage? = nil,
                   progress: Progress? = nil,
                   completion: Completion) {
        /// ... 네트워크 스택 설정
        /// ... 이미지 다운로드 중
        /// ...
        completion(UIImage(), nil)
    }
}

