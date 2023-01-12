// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
    runtimeConfig: {
        // Private keys are only available on the server
        apiSecret: '123',
        // Public keys that are exposed to the client
        public: {
            API_BASE_URL: process.env.NUXT_PUBLIC_API_BASE || 'https://databaser-server-staging.ub.gu.se/databases/'
        }
    },
    typescript: {
        shim: false
    }
})
