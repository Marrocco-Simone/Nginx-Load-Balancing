const yargs = require('yargs');

//set url and port
yargs.command({
    command: 'start',
    describe: 'set server adress',
    builder: {
        url: {
            describe: 'server url',
            type: 'string',
        },
        port: {
            describe: 'server port',
            type: 'number',
        }
    }
})

const getAdress = async (argv) => {
    let parsed = await yargs.parse(argv);
    let url = parsed.url || 'localhost';
    let port = parsed.port || 3000;
    return {url, port};
}

module.exports = {getAdress};