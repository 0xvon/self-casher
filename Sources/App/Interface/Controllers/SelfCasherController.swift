import Vapor
import Foundation

final class SelfCasherController: RouteCollection {
    let useCase = SelfCasherUseCase()
    func boot(router: Router) throws {
        router.group("selfCasher") { (group) in
            group.post("", use: post)
        }
    }
}

extension SelfCasherController {
    func post(_ req: Request) throws -> Future<String> {
        let body: String = "2\n001137565660 1000\n78722\nstart\n0011375656600\n0278722020000\nend\nstart\n0011375656600\n0278722020002\nend"
        
        let parsedBodies: [String] = self.parseInput(input: body)
        print(parsedBodies)
        var index = 0
        for parsed in parsedBodies {
            let response = useCase.post(body: parsed, index: index)
            if let response = response { print(response)}
            index += 1
        }
        return req.eventLoop.newSucceededFuture(result: "ok")
    }
    
    func parseInput(input: String) -> [String] {
        let parsedItems: [String] = input.components(separatedBy: "\n")
        return parsedItems
    }
}
