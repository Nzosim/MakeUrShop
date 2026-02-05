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
                            background: '#E7E7E7',
                            surface: '#E7E7E7',
                            primary: '#A160A1',
                            secondary: '#4C4D5F',
                            accent: '#291928',
                            error: '#FF5252',
                            info: '#2196F3',
                            success: '#4CAF50',
                            warning: '#FB8C00',
                        },
                    },
                    dark: {
                        colors: {
                            background: '#151515',
                            surface: '#232323',
                            primary: '#623A62',
                            secondary: '#8485A8',
                            accent: '#C996C5',
                        },
                    },
                },
            },
        },
    },
});
