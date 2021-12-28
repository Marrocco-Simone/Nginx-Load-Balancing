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
    console.log(`${url}:${port} received ${req.path} by ${req.headers['x-forwarded-for']} | ${req.ip}`);
    next();
}
app.use(printRequest);
app.use(express.static('./public'));

app.get('/adress',(req,res) => {
    res.status(200).send({url,port});
})

app.get('/load/:n',(req,res) => {
    /* setTimeout(() => {
        res.send({url,port});
    },req.params.n*1000); */
    let a;
    for(let i=0; i<req.params.n*100000000; i++){
        a=i;
    }
    res.send();
})

app.get('*', (req,res) => {
    res.status(404).send('<h1>Express - Page not found </h1>');
})

app.listen(port, url, () => {
    console.log(`listening on http://${url}:${port}`);
})

//////////////////////

})