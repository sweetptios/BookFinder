//
//  BookSummaryRepository.swift
// BookFinder
//
//  Created by mine on 2020/02/01.
//  Copyright © 2019 sweetpt365. All rights reserved.
//

import Foundation

class BookSummaryRepository: IBookSummaryRepository {
    
    private let networking: INetworkingService
    #warning("TODO - 의존성 주입? - 화면 구성에 따라 달라질 수 있어야 한다. ")
    private let maxResultCount: Int = 39
    private let apiKey: String = "AIzaSyCdyRfz2EwdpHesMXGGxgsaT37G-NsOy_4"
    private let totalResultCount: Int = 0

    required init(networking: INetworkingService) {
        self.networking = networking
    }
    
    func fetchBooks(page: Int, keyword: String, completion: ((Result<(books: [Book], totalCount: Int), RepositoryError>) -> Void)?) {

        let params = makeParams(page: page, keyword: keyword)
        networking.request(.books, parameters: params)?
            .response{(result :Result<BookIndexAPIModel, ServerAPIResponseError>) in
                DispatchQueue.main.async {
                    switch(result) {
                    case .success(let data):
                        if data.isEmpty() {
                            completion?(.failure(RepositoryError(kind: .emptySearchResult(keyword: keyword))))
                        } else {
                            completion?(.success((books: data.toBooks(), totalCount: data.totalItems ?? 0)))
                        }
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
            params["q"] = keyword
        }
        params["key"] = apiKey
        return params
    }
}


// MARK: - APIModel

struct BookIndexAPIModel: IServerAPIModel {
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
            let thumbnailUrl = URL(string: $0.volumeInfo?.imageLinks?.smallThumbnail ?? "")
            let detailUrl = URL(string: $0.volumeInfo?.infoLink ?? "")
            var date = Date(from: $0.volumeInfo?.publishedDate, format: "yyyy-MM-dd")
            if date == nil {
                date = Date(from: $0.volumeInfo?.publishedDate, format: "yyyy")
            }
            return Book(id: $0.id, title: $0.volumeInfo?.title, authors: $0.volumeInfo?.authors, publishedDate: date, thumbnailImage: thumbnailUrl, detailInfo: detailUrl)
        }
    }
}
