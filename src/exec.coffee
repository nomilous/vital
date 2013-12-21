program = require 'commander'
{readFileSync} = require 'fs'

program.version JSON.parse( 
    readFileSync __dirname + '/../package.json'
    'utf8'
).version


program.option '-f, --file [file]',  'Run file.'

{file} = program.parse process.argv

