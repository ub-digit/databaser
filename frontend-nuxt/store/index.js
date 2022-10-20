import NProgress from 'nprogress'

export const state = () => ({
  alertURL: "http://localhost:4000/alert"
})

export const getters = {
  getCounter(state) {
    return state.counter
  }
}

export const mutations = {
  increment(state) {
    state.counter++
  }
}

export const actions = {
  async fetchDatabases(context, payload) {
    try {
     // NProgress.start();
      const result = await this.$axios.get(`/databases`, {params: {payload}});
      return result.data;
    } catch (error) {
      console.log(error.message);
    } finally {
   //   NProgress.done();
    }
  },
  async fetchPopularDatabases(payload) {
    try {
      const result = await this.$axios.get('/databases/popular', {params: {payload}});
      return result.data;
    } catch (error) {
      console.log(error.message);
    }
  },
  async fetchDatabase({context}, payload) {
    try {
     // NProgress.start();
      const result = await this.$axios.get(`/databases/${payload.id}`, {params: {payload}});
      return result.data;
    } catch (error) {
      console.log(error.message);
    } finally {
     // NProgress.done();
    }
  },
}