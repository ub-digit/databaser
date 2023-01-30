// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
    ssr: false,
    runtimeConfig: {
        // Public keys that are exposed to the client   
        public: {
            API_BASE_URL: process.env.NUXT_PUBLIC_API_BASE || 'https://databaser-server-staging.ub.gu.se/'
        }
    },
    typescript: {
        shim: false
    },
    modules: [
        '@pinia/nuxt',
        '@vueuse/nuxt'
    ],
    build: {
        transpile: [
          '@fortawesome/fontawesome-svg-core',
          '@fortawesome/free-brands-svg-icons',
          '@fortawesome/free-regular-svg-icons',
          '@fortawesome/free-solid-svg-icons',
          '@fortawesome/vue-fontawesome'
        ]
      },
    css: [
        // SCSS file in the project
        '@/assets/main.scss',
        '@fortawesome/fontawesome-svg-core/styles.css'
      ],
})