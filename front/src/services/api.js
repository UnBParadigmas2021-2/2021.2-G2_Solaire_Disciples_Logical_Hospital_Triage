import axios from 'axios'

axios.defaults.withCredentials = false
axios.defaults.headers.post['Access-Control-Allow-Origin'] = '*';
axios.defaults.headers.post['Content-Type'] ='application/json;charset=utf-8';

const api = axios.create({
  baseURL: 'http://localhost:8000/', withCredentials: false
})


export default api
