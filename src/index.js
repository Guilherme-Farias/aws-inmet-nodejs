const express = require('express');
const bodyParser = require('body-parser')
const cors = require('cors');

const { Kinesis } = require('aws-sdk')
const { format, utcToZonedTime } = require('date-fns-tz');
const api = require('./services/api')


const kinesis = new Kinesis()
const app = express();
app.use(cors())
app.use(bodyParser.json())


app.get('/', async (request, response) => {
    try {
        
        const recifeDate = utcToZonedTime(new Date(), "America/Recife")
        const timeBrazilFormatted = format(recifeDate, "yyyy-MM-dd/HH00")


        const apiResponse = await api.get(`/${timeBrazilFormatted}`)
        const stationsOfPE = []


        apiResponse.data.map(station => {
            if (station.UF === 'PE') {
                let data = {
                    Data: JSON.stringify({
                        name: station.DC_NOME,
                        temperature: parseFloat(station.TEM_INS),
                        humidity: parseFloat(station.UMD_INS)
                    }),
                    PartitionKey: station.DC_NOME,
                };

                stationsOfPE.push(data)
            }
        })

        const kinesisRecordsParams = {
            StreamName: "api-stream",
            Records: stationsOfPE,
        }
        kinesis.putRecords(kinesisRecordsParams, function (error, data) {
            if (error) throw new Error("Bad request");
            else return response.status(200).json({ data: data });
        });
    } catch (error) {
        return response.status(400).json(error)
    }
})


module.exports = app
