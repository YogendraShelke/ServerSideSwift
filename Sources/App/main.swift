import Vapor
import VaporPostgreSQL

let drop = Droplet()

try drop.addProvider(VaporPostgreSQL.Provider)
drop.preparations += Acronym.self

let acronyms = AcronymsController()
drop.resource("acronyms", acronyms)

drop.run()
