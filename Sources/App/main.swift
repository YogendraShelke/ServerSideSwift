import Vapor
import VaporPostgreSQL

let drop = Droplet()

try drop.addProvider(VaporPostgreSQL.Provider)
drop.preparations += Acronym.self

drop.get("version") { req in
        
        if let db = drop.database?.driver as? PostgreSQLDriver {
                let version = try db.raw("SELECT version()")
                return try JSON(node: version)
        }
    return "Database connection failed"
}

drop.get("first") { request in
        return try JSON(node: Acronym.query().first()?.makeNode())
}

drop.get("all") { request in
        return try JSON(node: Acronym.all().makeNode())
}

drop.post("new") { request in
        var acronym = try Acronym(node: request.json)
        try acronym.save()
        return acronym
}

drop.get("update") { request in
        guard var first = try Acronym.query().first(), let long = request.data["long"]?.string else {
                throw Abort.badRequest
        }
        first.long = long
        try first.save()
        return first
}

drop.get("delete-afks") { request in
        let query = try Acronym.query().filter("short", "AFK")
        try query.delete()
        return try JSON(node: Acronym.all().makeNode())
}

drop.run()
