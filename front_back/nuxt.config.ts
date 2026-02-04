// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
    compatibilityDate: '2025-07-15',
    devtools: { enabled: true },
    ssr: false,
    modules: ['vuetify-nuxt-module'],
    css: ['vuetify/styles', '@mdi/font/css/materialdesignicons.css', './app/assets/css/Product/Display.css', './app/assets/css/main.css', './app/assets/css/navbar.css'],
    vuetify: {
        moduleOptions: {
            /* module specific options */
        },
        vuetifyOptions: {
            theme: {
                defaultTheme: 'light',
                themes: {
                    light: {
                        colors: {
                            primary: '#A160A1',
                            secondary: '#424242',
                            accent: '#82B1FF',
                            error: '#FF5252',
                            info: '#2196F3',
                            success: '#4CAF50',
                            warning: '#FB8C00',
                        },
                    },
                    dark: {
                        colors: {
                            primary: '#474a4d',
                        },
                    },
                },
            },
        },
    },
});
