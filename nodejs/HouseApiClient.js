import axios from 'axios';
import FormData from 'form-data';
import fs from 'fs';

const host = process.env.DOCKERIZED ? "http://app:3000" : "http://localhost:3000"
const url = "api/copart/receiver";

export default class HouseApiClient {
  constructor(communicator) {
    this.communicator = communicator || "unknown";
  }

  send = async (data, filePath = null) => {
    const form = new FormData();

    form.append('communicator', this.communicator);

    for( const key in data ) {
      form.append(key, data[key]);
    }

    if(filePath) { form.append('file', fs.createReadStream(filePath)); }

    await axios.post(`${host}/${url}`, form, {
      headers: {
        'accept': 'application/json',
        'Accept-Language': 'en-US,en;q=0.8',
        'Content-Type': `multipart/form-data; boundary=${form._boundary}`
      }
    }).catch(error => {
      console.error(`[${this.communicator}] AXIOS failed ${error.message}`)
    })
  }
}
