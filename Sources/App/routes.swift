import Fluent
import Vapor

func routes(_ app: Application) throws {
    
    let passwordProtected = app.grouped(User.authenticator())
    let tokenProtected = app.grouped(UserToken.authenticator())
    
    app.get { req in
        return "It works!"
    }

    let todoController = TodoController()
    tokenProtected.get("todos", use: todoController.index)
    tokenProtected.post("todos", use: todoController.create)
    tokenProtected.delete("todos", ":todoID", use: todoController.delete)
    
    let authController = AuthController()
    app.post("register", use: authController.register)
    passwordProtected.post("login", use: authController.login)
    tokenProtected.get("me", use: authController.me)


}
