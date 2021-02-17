import axios from 'axios';

const host = process.env.DOCKERIZED ? "http://app:3000" : "http://localhost:3000"
const url = "api/copart/receiver";

export default class HouseApiClient {
  constructor(communicator) {
    this.communicator = communicator || "unknown";
  }

  send = async (data) => {
    const decorated_data = {
      communicator: this.communicator,
      data: data
    }

    await axios({
      method: 'post',
      url: `${host}/${url}`,
      data: decorated_data
    }).catch(error => {
      console.error(`[${this.communicator}] AXIOS failed ${error.message}`)
    })
  }
}
