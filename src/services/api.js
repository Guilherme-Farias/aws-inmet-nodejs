const axios = require('axios')

const api = axios.create({
    baseURL: "https://apitempo.inmet.gov.br/estacao/dados/"
})


module.exports = api;