const fs = require("fs")
const path = require("path")
const resourcePath = global.GetResourcePath ?
	global.GetResourcePath(global.GetCurrentResourceName()):
	__dirname
const safepath = url => path.join(resourcePath, url)

function fileExistsSync (filepath) { // from https://github.com/scottcorgan/file-exists, all credits to scottcorgan. the license can be found at https://github.com/scottcorgan/file-exists/blob/master/LICENSE
    const _filepath = filepath || '';
    try {
      return fs.statSync(_filepath).isFile()
    }
    catch (e) {
      // Check exception. If ENOENT - no such file or directory ok, file doesn't exist.
      // Otherwise something else went wrong, we don't have rights to access the file, ...
      if (e.code != 'ENOENT') {
        throw e
      }
  
      return false
    }
  }

class Database {
    constructor(file) {
        file = safepath(`${file}.json`);
        if (!fileExistsSync(file)) fs.writeFileSync(file,"[]");
        this.db = JSON.parse(fs.readFileSync(file));
        this.dbFile = file
    }
    GetUser(id) {
        const usr = this.db.find(u => u.id === id);
        return (usr) ? usr : false;
    }
    InsertUser(user) {
        this.db.push(user)
        this._updateDb();
    }
    UpdateUser(id, update) {
        for (let index = 0; index < this.db.length; index++) {
            const user = this.db[index];
            if (user.id == id) {
                for (var property in update) {
                    if (update.hasOwnProperty(property)) {
                        this.db[index][property] = update[property]
                    }
                }
            }            
        }
        this._updateDb()
    }
    _updateDb() {
        fs.writeFileSync(this.dbFile, JSON.stringify(this.db))
    }
}

var database;

function OpenDB(file,cb) {
    setImmediate(()=>{
        database = new Database(file);
        cb();
    })
}

function GetUser(id,cb) {
    setImmediate(()=>{
        var result = database.GetUser(id);
        cb(result);
    })
}

function InsertUser(user,cb) {
    setImmediate(()=>{
        database.InsertUser(user);
        cb();
    })
}

function UpdateUser(id, update, cb) {
    setImmediate(()=>{
        database.UpdateUser(id, update);
        cb();
    })
}

exports("OpenDB", OpenDB)
exports("GetUser", GetUser)
exports("InsertUser", InsertUser)
exports("UpdateUser", UpdateUser)
console.log("initialized DB component.")