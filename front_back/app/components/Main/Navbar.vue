<template>
    <v-toolbar :elevation="8" class="px-4">
        <div class="d-flex align-center nav-side-block">
            <v-btn text to="/" ripple="false" variant="plain" class="pa-0">
                <img src="/assets/img/small_logo_makeurshop.png" class="icons" height="40" alt="Logo" />
            </v-btn>
        </div>

        <v-spacer />

        <div class="nav-center-categories">
            <v-btn v-for="(name, index) in configData.config.navBar.names" :key="index" text :to="`/Product/${index + 1}`" class="categories" ripple="false">
                {{ name }}
            </v-btn>
        </div>

        <v-spacer />

        <div class="d-flex align-center nav-side-block justify-end">
            <v-btn icon @click="theme.toggle()" variant="text">
                <v-icon size="22">
                    {{ theme.global.name.value === 'light' ? 'mdi-weather-night' : 'mdi-white-balance-sunny' }}
                </v-icon>
            </v-btn>

            <v-btn icon to="/Cart" variant="text">
                <v-icon size="22">mdi-cart-outline</v-icon>
            </v-btn>

            <v-btn icon to="/User/User" variant="text">
                <v-icon size="22">mdi-account-outline</v-icon>
            </v-btn>
        </div>
    </v-toolbar>
</template>

<script setup>
    import { useTheme } from 'vuetify';
    const theme = useTheme();
    import configData from '/assets/config.json';
    import { ref } from 'vue';

    const showSearch = ref(false);
    const searchQuery = ref('');
</script>
