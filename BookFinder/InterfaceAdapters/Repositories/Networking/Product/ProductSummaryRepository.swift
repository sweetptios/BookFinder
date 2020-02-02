//
//  ProductSummaryRepository.swift
//  Shoppingmall
//
//  Created by mine on 2019/12/03.
//  Copyright © 2019 sweetpt365. All rights reserved.
//

import Foundation

class ProductSummaryRepository: IBookSummaryRepository {
    
    private let networking: INetworkingService
    #warning("TODO - 의존성 주입?")
    private let maxResultCount: Int = 40
    private let apiKey: String = "AIzaSyCdyRfz2EwdpHesMXGGxgsaT37G-NsOy_4"
    private let totalResultCount: Int = 0

    required init(networking: INetworkingService) {
        self.networking = networking
    }
    
    func fetchBooks(page: Int, keyword: String, completion: ((Result<[Book], RepositoryError>) -> Void)?) {
        
        #warning("TODO")
//        if let data = listJson().data(using: .utf8), let obj = try? JSONDecoder().decode(ProductIndexAPIModel.self, from: data) {
//           completion?(.success(obj.toProductSummary()))
//        }
        let params = makeParams(page: page, keyword: keyword)
        networking.request(.books, parameters: params)?
            .response{(result :Result<BookIndexAPIModel, ServerAPIResponseError>) in
                DispatchQueue.main.async {
                    switch(result) {
                    case .success(let data):
                        if data.isEmpty() {
                            completion?(.failure(RepositoryError(kind: .emptySearchResult(keyword: keyword))))
                        } else {
                            completion?(.success(data.toBooks()))
                        }
                        print("책개수: ", data.totalItems ?? 0)
                    case .failure(let error):
                         completion?(.failure(error.toRepositoryError()))
                }
            }
        }
    }

    private func makeParams(page: Int, keyword: String) -> [String: Any] {
        
        var params = [String: Any]()
        params["startIndex"] = (page - 1) * maxResultCount
        params["maxResults"] = maxResultCount
        if keyword.isEmpty == false {
            params["q"] = "intitle:\(keyword)"
        }
        params["key"] = apiKey
        return params
    }
}


// MARK: - APIModel

import Foundation

// MARK: - Books
struct BookIndexAPIModel: IServerAPIModel {
    #warning("TODO - 사용하기")
    let totalItems: Int?
    let items: [Volume]?
    
    struct Volume: Codable {
        let id: String?
        let volumeInfo: VolumeInfo?
        
        struct VolumeInfo: Codable {
            let title: String?
            let authors: [String]?
            let publishedDate: String?
            let imageLinks: ImageLinks?
            let infoLink: String?
            
            struct ImageLinks: Codable {
                let smallThumbnail: String?
            }
        }
    }

    func isValid() -> Bool { true }
    
    func isEmpty() -> Bool { items?.isEmpty ?? true }
}

extension BookIndexAPIModel {
    
    func toBooks() -> [Book] {
        guard let items = items, isValid() else { return [] }
        return items.map{
            let url = URL(string: $0.volumeInfo?.imageLinks?.smallThumbnail ?? "")
            #warning("TODO - 개선")
            var date = toDate(from: $0.volumeInfo?.publishedDate, format: "yyyy-MM-dd")
            if date == nil {
                date = toDate(from: $0.volumeInfo?.publishedDate, format: "yyyy")
            }
            return Book(id: $0.id, title: $0.volumeInfo?.title, authors: $0.volumeInfo?.authors, publishedDate: date, thumbnailImage: url)
        }
    }
    
    private func toDate(from string: String?, format: String) -> Date? {
        guard let string = string else { return nil }
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale.current
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: string)
    }
}



#warning("TODO")
func listJson() -> String {
    """
    {
      "statusCode": 200,
      "body": [
        {
          "id": 536,
          "price": "19650",
          "oily_score": 100,
          "thumbnail_image": "https://grepp-programmers-challenges.s3.ap-northeast-2.amazonaws.com/2020-birdview/thumbnail/ef792a79-435c-44eb-b9dc-285750ae1517.jpg",
          "title": "플라멜엠디 밀크러스트필 마일드 워시오프 앰플 5ml x 2개"
        },
        {
          "id": 258,
          "price": "25550",
          "oily_score": 100,
          "thumbnail_image": "https://grepp-programmers-challenges.s3.ap-northeast-2.amazonaws.com/2020-birdview/thumbnail/2c7672aa-5112-4f28-bd43-79ee817d67bf.jpg",
          "title": "아티스트리 맨 젠틀 페이스 워시 115ml"
        },
        {
          "id": 192,
          "price": "34200",
          "oily_score": 100,
          "thumbnail_image": "https://grepp-programmers-challenges.s3.ap-northeast-2.amazonaws.com/2020-birdview/thumbnail/a494db8e-7c5a-4163-8df4-eeb70798715f.jpg",
          "title": "제주온 하이온 제주 바다 보배 콜라겐 펩타이드 크림 50ml"
        },
        {
          "id": 987,
          "price": "3940",
          "oily_score": 100,
          "thumbnail_image": "https://grepp-programmers-challenges.s3.ap-northeast-2.amazonaws.com/2020-birdview/thumbnail/b0244924-7842-485d-bfee-05c0002b3743.jpg",
          "title": "타소스 옴므 2종 세트"
        },
        {
          "id": 543,
          "price": "4900",
          "oily_score": 100,
          "thumbnail_image": "https://grepp-programmers-challenges.s3.ap-northeast-2.amazonaws.com/2020-birdview/thumbnail/ab6662c7-b511-4844-b810-f9bed65fc61d.jpg",
          "title": "네츄럴아일랜드 퓨어 아쿠아 버블 클렌징폼 300g"
        },
        {
          "id": 615,
          "price": "20800",
          "oily_score": 100,
          "thumbnail_image": "https://grepp-programmers-challenges.s3.ap-northeast-2.amazonaws.com/2020-birdview/thumbnail/d5bc66b9-b67e-40a2-b1ff-bdd8e67046cf.jpg",
          "title": "드 레피데 드 퓨어 더블 프로틴 리턴 크림 50ml"
        },
        {
          "id": 259,
          "price": "11570",
          "oily_score": 100,
          "thumbnail_image": "https://grepp-programmers-challenges.s3.ap-northeast-2.amazonaws.com/2020-birdview/thumbnail/7dd55cf5-e52a-461a-8c47-da46ae51ab95.jpg",
          "title": "에코스토리 천연 발효 식초 비누 국내산 자연 수제 클렌징 미용 촉촉한 보습 산뜻 한애가 오랜시간이 만든 전통 장인의 최고 명품"
        },
        {
          "id": 110,
          "price": "12910",
          "oily_score": 100,
          "thumbnail_image": "https://grepp-programmers-challenges.s3.ap-northeast-2.amazonaws.com/2020-birdview/thumbnail/02752a37-cdff-4b01-830f-a492abdb47ad.jpg",
          "title": "데이셀 피부수호 클린 프로젝트 쿠션 14g"
        },
        {
          "id": 555,
          "price": "2450",
          "oily_score": 100,
          "thumbnail_image": "https://grepp-programmers-challenges.s3.ap-northeast-2.amazonaws.com/2020-birdview/thumbnail/52a856c8-af43-40a1-9243-5c99bf8ca0ed.jpg",
          "title": "투쿨포스쿨 코코넛 세라마이드 마스크"
        },
        {
          "id": 359,
          "price": "21070",
          "oily_score": 100,
          "thumbnail_image": "https://grepp-programmers-challenges.s3.ap-northeast-2.amazonaws.com/2020-birdview/thumbnail/e1b88d97-b137-497a-a472-de1ce1e2b196.jpg",
          "title": "오리진스 아웃 오브 트러블"
        },
        {
          "id": 284,
          "price": "36490",
          "oily_score": 99,
          "thumbnail_image": "https://grepp-programmers-challenges.s3.ap-northeast-2.amazonaws.com/2020-birdview/thumbnail/f183adb9-c16f-4041-ad5e-71a1527aa704.jpg",
          "title": "아워글래스 아워글라스 컨페션 립스틱 타임"
        },
        {
          "id": 337,
          "price": "101480",
          "oily_score": 99,
          "thumbnail_image": "https://grepp-programmers-challenges.s3.ap-northeast-2.amazonaws.com/2020-birdview/thumbnail/2b9f60f0-09e4-403a-8af0-a063eeddf2ad.jpg",
          "title": "정나니 스페셜 스킨케어 3종 세트 [PNC1017]"
        },
        {
          "id": 305,
          "price": "160",
          "oily_score": 99,
          "thumbnail_image": "https://grepp-programmers-challenges.s3.ap-northeast-2.amazonaws.com/2020-birdview/thumbnail/7384de9c-a122-422d-ad6a-ba7242e55a8e.jpg",
          "title": "네이처바이 플러스 알로에 에센스 마스크"
        },
        {
          "id": 960,
          "price": "25240",
          "oily_score": 99,
          "thumbnail_image": "https://grepp-programmers-challenges.s3.ap-northeast-2.amazonaws.com/2020-birdview/thumbnail/005b1c58-e91f-40ce-ac55-55fef912694c.jpg",
          "title": "맨 포 아이크림 눅스"
        },
        {
          "id": 142,
          "price": "26440",
          "oily_score": 99,
          "thumbnail_image": "https://grepp-programmers-challenges.s3.ap-northeast-2.amazonaws.com/2020-birdview/thumbnail/0f6a8b85-1622-448c-a281-82a944629003.jpg",
          "title": "아모레퍼시픽 설화수 여민 마스크"
        },
        {
          "id": 202,
          "price": "183600",
          "oily_score": 99,
          "thumbnail_image": "https://grepp-programmers-challenges.s3.ap-northeast-2.amazonaws.com/2020-birdview/thumbnail/06f22a9e-9c43-434e-b997-b261dd9e874f.jpg",
          "title": "코스메 데코르테 AQ화이트닝 크림 25g"
        },
        {
          "id": 1051,
          "price": "11100",
          "oily_score": 99,
          "thumbnail_image": "https://grepp-programmers-challenges.s3.ap-northeast-2.amazonaws.com/2020-birdview/thumbnail/46fed26e-af8b-44af-9592-277145ac0fa2.jpg",
          "title": "메이메딕 페이스 핏 리프팅 마스크"
        },
        {
          "id": 316,
          "price": "56760",
          "oily_score": 98,
          "thumbnail_image": "https://grepp-programmers-challenges.s3.ap-northeast-2.amazonaws.com/2020-birdview/thumbnail/cb485b15-50ad-446d-903c-9af64cd67b3e.jpg",
          "title": "dcl G10 래디언스 필 50매"
        },
        {
          "id": 952,
          "price": "7630",
          "oily_score": 98,
          "thumbnail_image": "https://grepp-programmers-challenges.s3.ap-northeast-2.amazonaws.com/2020-birdview/thumbnail/5584e33d-f046-4c06-886e-a70feff152da.jpg",
          "title": "슈에무라 글로우 온 듀오 (케이스)"
        },
        {
          "id": 454,
          "price": "14744",
          "oily_score": 98,
          "thumbnail_image": "https://grepp-programmers-challenges.s3.ap-northeast-2.amazonaws.com/2020-birdview/thumbnail/946e6933-cb82-4124-b93f-d60f9d84c4ce.jpg",
          "title": "퐁당 어메이징 핑크 파우더 스팟 앰플 15ml"
        }
      ],
      "scanned_count": 20
    }
    """
}
