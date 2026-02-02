// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
    compatibilityDate: '2025-07-15',
    devtools: { enabled: true },
    ssr: false,
    modules: ['vuetify-nuxt-module'],
    css: ['vuetify/styles', '@mdi/font/css/materialdesignicons.css', './app/assets/css/Product/Display.css', './app/assets/css/main.css'],
    vuetify: {
        moduleOptions: {
            /* module specific options */
        },
        vuetifyOptions: {
            /* vuetify options */
        },
    },
});
