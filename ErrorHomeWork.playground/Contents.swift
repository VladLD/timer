import UIKit

typealias ResponseCode = (title: String, currentCode: Int, startCode: Int, endCode: Int, description: String)

var currentCode = Int.random(in: 100...599)
print(currentCode)

let responseCode: ResponseCode

switch currentCode {
case 100...199:
    responseCode = ResponseCode(title: "Informational", currentCode: currentCode, startCode: 100, endCode: 199, description: "Request received continuing process")
case 200...299:
    responseCode = ResponseCode(title: "Successful", currentCode: currentCode, startCode: 200, endCode: 299, description: "The action was successfully received, understood, and accepted")
case 300...399:
    responseCode = ResponseCode(title: "Redirection", currentCode: currentCode, startCode: 300, endCode: 399, description: "Further action must be taken in order to complete the request")
case 400...499:
    responseCode = ResponseCode(title: "Client Error", currentCode: currentCode, startCode: 400, endCode: 499, description: "The request contains bad syntax or cannot be fulfilled")
case 500...599:
    responseCode = ResponseCode(title: "Server Error", currentCode: currentCode, startCode: 500, endCode: 599, description: "The server failed to fulfil an apparently valid request")
default:
    fatalError()
}

print(responseCode.description)
