program = require 'commander'
{readFileSync} = require 'fs'
{join} = require 'path'

program.version JSON.parse( 
    readFileSync __dirname + '/../package.json'
    'utf8'
).version

program.option '-f, --file [file]',  'Run file.'

{file} = program.parse process.argv
ipso   = require('ipso').components()
path   = join process.cwd(), file unless file[0] is '/'

require path

#
# TODO:
# 
# * handle .coffee and .litcoffee
#

