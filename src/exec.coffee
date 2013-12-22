program = require 'commander'
{readFileSync, lstatSync} = require 'fs'
{join} = require 'path'
{compile} = require 'coffee-script'
{util} = require 'also'

program.version JSON.parse( 
    readFileSync __dirname + '/../package.json'
    'utf8'
).version

program.option '-f, --file [file]',  'Run file.'

{file} = program.parse process.argv
path   = join process.cwd(), file unless file[0] is '/'


#
# bring selected ipso ipso tools into scope
#

{ipso, tag} = require('ipso').components()


if path.match /\.coffee$/  then list = eval compile readFileSync(path, 'utf8'), bare: true
else if path.match /\.js$/ then list = eval "list = { #{readFileSync(path, 'utf8')} }"



#
# TODO:
# 
# * handle .litcoffee (maybe)
# * control repeat interval
# * handle interval overlap
# * async, inject action resolver, done / facto
# * shared context with hooks
# 


actionRunner = (text, fn) -> 
    
    #
    # ipso function decorator handles the injection
    #
   
    run = ipso fn
    run done = ->


try if typeof list.before.all is 'function' 
    actionRunner 'before all', list.before.all


setInterval (->

    try if typeof list.before.each is 'function' 
        actionRunner 'before each', list.before.each

    for text of list

        continue if text is 'before'
        actionRunner text, list[text]
        

), 1000

