import Fluent
import Vapor

struct TodoController {
    func index(req: Request) throws -> EventLoopFuture<[Todo]> {
        _ = try req.auth.require(User.self)
        return Todo.query(on: req.db).all()
    }

    func create(req: Request) throws -> EventLoopFuture<Todo> {
        _ = try req.auth.require(User.self)
        let todo = try req.content.decode(Todo.self)
        return todo.save(on: req.db).map { todo }
    }

    func delete(req: Request) throws -> EventLoopFuture<HTTPStatus> {
        _ = try req.auth.require(User.self)
        return Todo.find(req.parameters.get("todoID"), on: req.db)
            .unwrap(or: Abort(.notFound))
            .flatMap { $0.delete(on: req.db) }
            .transform(to: .ok)
    }
}