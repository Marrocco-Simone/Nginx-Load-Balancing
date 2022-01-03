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
    console.log(`${url}:${port} received ${req.path} from ${req.ip}`);
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

app.get('/login', (req,res) => {
    res.json({ token: 'secret-token' });
})

const loginMW = (req,res,next) => {
    const token = req.headers.authorization;
    if(token != 'secret-token') res.status(403).send('Not logged in');
    else next();
}

app.get('/secret', loginMW, (req,res) => {
    res.send('welcome to the secret page');
})

app.get('*', (req,res) => {
    res.status(404).send('<h1>Express - Page not found </h1>');
})

app.listen(port, url, () => {
    console.log(`listening on http://${url}:${port}`);
})

//////////////////////

})