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
# * fix cannot inject string, number or array
# * fix ipso calls does.activate with mode as 'spec' (irrespective of does.mode)
# * stop append of .does() during injection (per mode)
# 

actionRunner = (text, fn) -> 

    #
    # * ipso decorates the function with injectability
    # * the first argument is the test resolver
    # * all subsequent arguments are populated by the injector
    #

    decorated = ipso fn
    decorated (result) -> 

        if result instanceof Error then console.log result.stack



try if typeof list.before.all is 'function' 
    actionRunner 'before all', list.before.all


setInterval (->

    try if typeof list.before.each is 'function' 
        actionRunner 'before each', list.before.each

    for text of list

        continue if text is 'before'

        fn = list[text]
        actionRunner text, fn
        

), 1000

