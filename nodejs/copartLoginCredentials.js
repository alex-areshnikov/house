import axios from 'axios';

const host = process.env.DOCKERIZED ? "http://app:3000" : "http://localhost:3000"
const url = "api/copart/credentials";

async function copartLoginCredentials() {
  const response = await axios({
    method: 'get',
    url: `${host}/${url}`
  }).catch(error => {
    console.error(`Credentials fetch failed: ${error}`)
  })

  return { username: response.data.username, password: response.data.password };
}

export default copartLoginCredentials;
