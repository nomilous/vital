program = require 'commander'
{readFileSync, lstatSync} = require 'fs'
{join} = require 'path'
{compile} = require 'coffee-script'

program.version JSON.parse( 
    readFileSync __dirname + '/../package.json'
    'utf8'
).version

program.option '-f, --file [file]',  'Run file.'

{file} = program.parse process.argv
ipso   = require('ipso').components()
path   = join process.cwd(), file unless file[0] is '/'


if path.match /\.coffee$/  then list = eval compile readFileSync(path, 'utf8'), bare: true
else if path.match /\.js$/ then list = eval "list = { #{readFileSync(path, 'utf8')} }"



#
# TODO:
# 
# * handle .litcoffee (maybe)
# * control repeat interval
# * handle interval overlap
# 

try if typeof list.before.all is 'function' then list.before.all()

setInterval (->

    try if typeof list.before.each is 'function' then list.before.each()

    for text of list

        continue if text is 'before'
        console.log '%s:', text, list[text]()

), 1000

