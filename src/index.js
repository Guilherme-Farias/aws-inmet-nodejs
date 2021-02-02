const express = require('express');
const bodyParser = require('body-parser')
const cors = require('cors');
const { format } = require('date-fns')
const api = require('./services/api')
const app = express();

app.use(cors())
app.use(bodyParser.json())

app.get('/', async (request, response) => {
    try {
        const time = format(new Date(), "yyyy-MM-dd/HH00")
        const apiResponse = await api.get(`/${time}`)
    
        const stationsOfPE = []
        
        apiResponse.data.map(station => {
            if(station.UF === 'PE'){
                let data = {
                    name: station.DC_NOME,
                    temperature: station.TEM_INS,
                    humidity: station.UMD_INS
                }

                stationsOfPE.push(data)
            }
        })
        return response.status(200).json(stationsOfPE)
        
    } catch (error) {
        return response.status(400).json(error)
    }
})


module.exports = app
