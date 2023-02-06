import {createAuth} from '@websanova/vue-auth/src/v3.js';
import driverAuthBearer from '@websanova/vue-auth/src/drivers/auth/bearer.js';
import driverHttpAxios from '@websanova/vue-auth/src/drivers/http/axios.1.x.js';
import driverRouterVueRouter from '@websanova/vue-auth/src/drivers/router/vue-router.2.x.js';

export default (app) => {
    console.log(app.router)
  app.use(createAuth({
    plugins: {
      http: app.axios,
      router: app.router,
    },
    drivers: {
      http: driverHttpAxios,
      auth: driverAuthBearer,
      router: driverRouterVueRouter,
      cas: {
        servicePath: '/login/cas',
        validationPath: '/auth/cas',
      }
    },
    options: {
        rolesKey: 'type',
        notFoundRedirect: {name: 'Checkouts'},
        fetchData: {url: `${app.baseURL}/auth/user`, method: 'GET', enabled: true},
        refreshData: {url: `${app.baseURL}/auth/refresh`, method: 'GET', enabled: true, interval: 30},
        loginData: {url: `${app.baseURL}/auth/databaser`, method: 'POST', redirect: '/', fetchUser: false, staySignedIn: true },
    }
  }));
}