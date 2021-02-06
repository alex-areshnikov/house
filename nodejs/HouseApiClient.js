import axios from 'axios';

// process.env.DOCKERIZED ?

const host = "http://localhost:3000";
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
      console.error(error.response)
    })
  }
}
