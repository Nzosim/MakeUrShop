<template>
    <v-toolbar :elevation="8">
        <v-toolbar-items>
            <v-btn text to="/">
                <img src="/assets/img/small_logo_makeurshop.png" class="icons" height="40" alt="Logo" />
            </v-btn>
        </v-toolbar-items>

        <v-spacer />

        <v-toolbar-items>
            <v-btn v-for="(name, index) in configData.config.navBar.names" :key="index" text :to="`/Product/${index + 1}`" class="categories" ripple="false">
                {{ name }}
            </v-btn>
        </v-toolbar-items>

        <v-spacer />
        <v-toolbar-items>
            <v-btn icon @click="theme.toggle()">
                <v-icon>
                    {{ theme.global.name.value === 'light' ? 'mdi-weather-night' : 'mdi-white-balance-sunny' }}
                </v-icon>
            </v-btn>
            <v-btn text to="/User/User" width="90">
                <v-icon size="25">mdi-account</v-icon>
            </v-btn>
        </v-toolbar-items>
    </v-toolbar>
</template>

<script setup>
    import { useTheme } from 'vuetify';
    const theme = useTheme();
    import configData from '/assets/config.json';
</script>
