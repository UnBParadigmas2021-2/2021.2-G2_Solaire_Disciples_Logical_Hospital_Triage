import axios from 'axios'

axios.defaults.withCredentials = true
const api = axios.create({
  baseURL: 'http://localhost:8000/', mode: 'cors', withCredentials: false
})

export default api
