import { createVuetify } from 'vuetify';
import * as components from 'vuetify/components';
import * as directives from 'vuetify/directives';
import { md3 } from 'vuetify/blueprints';
import 'vuetify/styles';

export default defineNuxtPlugin((nuxtApp) => {
    const vuetify = createVuetify({
        blueprint: md3,
        components,
        directives,
        theme: {
            defaultTheme: 'system',
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
    });

    nuxtApp.vueApp.use(vuetify);
});
