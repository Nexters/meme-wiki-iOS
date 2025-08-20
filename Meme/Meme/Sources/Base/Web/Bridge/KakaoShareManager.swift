//
//  KakaoShareManager.swift
//  Meme
//
//  Created by 제나 on 8/21/25.
//

import UIKit
import KakaoSDKTemplate
import KakaoSDKShare
import KakaoSDKCommon
import KakaoSDKAuth

struct KakaoShareManager {
    static let shared = KakaoShareManager()
    
    private init() { }
    
    func shareToKakao(shareData: ShareData, link: URL) {
        let feedTemplate = FeedTemplate(
            content: Content(
                title: shareData.title,
                imageUrl: URL(string: shareData.image)!,
                description: "미미키에서 더 많은 밈을 확인해보세요!",
                link: Link(webUrl: link, mobileWebUrl: link)
            ),
            buttons: [
                Button(
                    title: "자세히 보기",
                    link: Link(webUrl: link, mobileWebUrl: link)
                )
            ]
        )

        if ShareApi.isKakaoTalkSharingAvailable() {
            ShareApi.shared.shareDefault(templatable: feedTemplate) { (linkResult, error) in
                if let error = error {
                    Log.error("카카오톡 공유 실패 \(error.localizedDescription)", .networking)
                } else if let linkResult = linkResult {
                    UIApplication.shared.open(linkResult.url, options: [:], completionHandler: nil)
                }
            }
        } else {
            // 카카오톡이 없으면 웹으로
            if let url = ShareApi.shared.makeDefaultUrl(templatable: feedTemplate) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
}
