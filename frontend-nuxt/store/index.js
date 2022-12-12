import NProgress from 'nprogress'

export const state = () => ({
  alertURL: process.env.alertURL
})

export const getters = {
}

export const mutations = {

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
  async fetchPopularDatabases(context, payload) {
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