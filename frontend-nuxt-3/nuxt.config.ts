// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
    typescript: {
        shim: false
    },
  modules: [
    '@nuxtjs/i18n',
  ],
  i18n: {
    /* module options */
    strategy: 'prefix_except_default',
    defaultLocale: 'sv'
  }
})
