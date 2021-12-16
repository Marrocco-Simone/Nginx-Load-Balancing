const express = require('express');
const {getAdress} = require('./parser');

let url,port;
const setAdress = async () => {
    let result = await getAdress(process.argv);
    url = result.url;
    port = result.port;
}
setAdress().then(() => {

///////set server up

const app = express();

const printRequest = (req,res,next) => {
    console.log(`${url}:${port} received ${req.path}`);
    next();
}
app.use(printRequest);
app.use(express.static('./public'));

app.get('/adress',(req,res) => {
    res.status(200).send({url,port});
})

app.get('/',(req,res) => {
    res.send('gffff');
})

app.listen(port, url, () => {
    console.log(`listening on http://${url}:${port}`);
})

//////////////////////

})