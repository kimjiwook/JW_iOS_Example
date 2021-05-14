import UIKit
import Foundation
import CryptoKit // 암호화 킷 iOS13 이상

/*
 1. SHA512 + Salt 확인하는 사이트
 https://www.convertstring.com/ko/Hash/SHA512
 
 2. 암호화 결과 확인하는 사이트 (여러종류 다 있음)
 https://emn178.github.io/online-tools/base64_encode.html
 
 [1] 사이트에서 SHA512 + Salt 확인하고
 [2] base64 값 확인함.

 ※ 암호화 변경 샘플 결과값 [안드로이드, 메신져(맥, 윈도우), 웹]
 1.
 passwd : 1111
 salt : 1
 SHA512+salt 암호문 : Iufp2Ft/5gBPe586pZLqnsnOCYaC6BkvqDeF8XhMdo0dGsO4r8rohmb2auwkc5rBM+nUrcdQbxpfH2B4yyfGdA==

 2.
 passwd : hsgnu@1234
 salt : 1
 SHA512+salt 암호문 : /z+y48FraL+LO2QTKqS+dmRiC0tk1KoVAt9qBDJ8sSSYxHwC34D1pEsr121iKPvwkUrls5erEdKqc7unqb8Bkw==

 3.
 passwd : 111111
 salt : 123
 SHA512+salt 암호문 : 5fHna5pXEqQZwMphO2Aoo8XokT2DDMmI7y8sBVgWNSkfls/LOmQSBWuRxwrfmQLEdmnpWcH7jtfCEpSoAhNICQ==
 */

// 암호화 테스트
let text = "111111"
let saltKey = "123" // empSeq

// 기본적인 암호화 문 (엄청 간결하죠)
// let data = text.data(using: .utf8)!
// let sha512 = SHA512.hash(data: data)
// let sha256 = SHA256.hash(data: data)

// 해당 암호화 문 String 으로 변환하기.
// let hashString = sha512.compactMap { String(format: "%02x", $0) }.joined()

// 1. Salt 추가시 SaltKey를 시작 + 원문 으로 붙여서 사용하면 됩니다.
let salt = saltKey + text
var saltData = salt.data(using: .utf8)
let sha512Salt = SHA512.hash(data: saltData!)

// 2. sha512Salt 에서 Data로 바로 빼서 base64 해야지만 hex로 됨
var shaData = Data()
sha512Salt.compactMap { indata in
    shaData.append(indata)
}

// 3. 최종 결과
let sha512SaltBase64String = shaData.base64EncodedString()
print("SHA512 -> Data -> Base64String : ")
print(sha512SaltBase64String)

/*
 주의사항 iOS 예제로 SHA512 -> String 의 예제만 있어서 나만 결과가 틀려서 당황했는데
 text = 111111, salt = 123 으로 테스트 결과
 : 다른 모듈들 협업시 확인하고 진행해야 하겠지만, 보통 "SHA512 -> Data -> Base64String" 사용됨
 
 - SHA512 -> Data -> Base64String
    : 5fHna5pXEqQZwMphO2Aoo8XokT2DDMmI7y8sBVgWNSkfls/LOmQSBWuRxwrfmQLEdmnpWcH7jtfCEpSoAhNICQ==
 - SHA512 -> String -> Data -> Base64String
    : ZTVmMWU3NmI5YTU3MTJhNDE5YzBjYTYxM2I2MDI4YTNjNWU4OTEzZDgzMGNjOTg4ZWYyZjJjMDU1ODE2MzUyOTFmOTZjZmNiM2E2NDEyMDU2YjkxYzcwYWRmOTkwMmM0NzY2OWU5NTljMWZiOGVkN2MyMTI5NGE4MDIxMzQ4MDk=

 
 */

// #. 아래값으로 String -> Data -> Base64로 하면 결과가 다름 (Text 방식)
// SHA512 + salt 결과
let hashString = sha512Salt.compactMap { String(format: "%02x", $0) }.joined()
//// base64 String
let base64String = hashString.data(using: .utf8)!.base64EncodedString()
print("SHA512 -> String -> Data -> Base64String : ")
print(base64String)

