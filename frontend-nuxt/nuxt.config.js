export default {
  // Global page headers: https://go.nuxtjs.dev/config-head
  head: {
    title: 'frontend-nuxt',
    htmlAttrs: {
      lang: 'en',
    },
    meta: [
      { charset: 'utf-8' },
      { name: 'viewport', content: 'width=device-width, initial-scale=1' },
      { hid: 'description', name: 'description', content: '' },
      { name: 'format-detection', content: 'telephone=no' },
    ],
    link: [{ rel: 'icon', type: 'image/x-icon', href: '/favicon.ico' }],
  },

  // Global CSS: https://go.nuxtjs.dev/config-css
  css: ['~assets/scss/main.scss'],

  // Plugins to run before rendering page: https://go.nuxtjs.dev/config-plugins
  plugins: [],

  // Auto import components: https://go.nuxtjs.dev/config-components
  components: true,

  // Modules for dev and build (recommended): https://go.nuxtjs.dev/config-modules
  buildModules: [
    '@nuxtjs/style-resources',
    '@nuxtjs/fontawesome',
    '@nuxtjs/router-extras',
  ],

  fontawesome: {
    icons: {
      solid: true, // loads all solid - not recomended of course
      regular: true, // Todo: specify icons
    }
  },

  // Modules: https://go.nuxtjs.dev/config-modules
  modules: [
    // https://go.nuxtjs.dev/axios
    '@nuxtjs/axios',
    // https://i18n.nuxtjs.org/setup
    '@nuxtjs/i18n',
  ],

  styleResources: {
    scss: '@/assets/scss/_variables.scss'
  },
  // Axios module configuration: https://go.nuxtjs.dev/config-axios
  axios: {
    // Workaround to avoid enforcing hard-coded localhost:3000: https://github.com/nuxt-community/axios-module/issues/308
    baseURL: 'http://localhost:4000',
  },

  i18n: {
    /* module options */
    baseUrl: 'http://localhost:3000',
    strategy: 'prefix_and_default',
    defaultLocale: 'sv',
    langDir: 'locales/',
    locales: [
      {
        code: 'en',
        iso: 'en-US',
        name: 'en',
        file: 'en.js'
      }, 
      {
        code: 'sv',
        iso: 'sv',
        name: 'sv',
        file: 'sv.js'
      } 
    ]
  },

  // Build Configuration: https://go.nuxtjs.dev/config-build
  build: {
  }
}
