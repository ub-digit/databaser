// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
    ssr: true,
    runtimeConfig: {
        
        API_BASE_URL: 'http://localhost:4000/',   
        public: {
            
        }
    },
    app: {
      head: {
        script: [{ children: "var _sid = '2237'; var _imboxSettings = { cookieDomain: '.databaser-staging.ub.gu.se'}; (function() { var se = document.createElement('script'); se.type = 'text/javascript'; se.async = true; se.src = ('https:' == document.location.protocol ? 'https://' : 'http://') + 'files.imbox.io/app/dist/initWidget.js'; var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(se, s); })();"}],
      },
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