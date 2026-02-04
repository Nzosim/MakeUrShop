<template>
    <v-navigation-drawer v-model="drawer" temporary color="surface">
        <v-list>
            <v-list-item v-for="(name, index) in configData.config.navBar.names" :key="index" :to="`/Product/${index + 1}`" @click="drawer = false">
                <v-list-item-title>{{ name }}</v-list-item-title>
            </v-list-item>
        </v-list>
    </v-navigation-drawer>

    <v-app-bar :elevation="8" color="surface" class="px-4">
        <div class="d-flex align-center nav-side-block">
            <v-app-bar-nav-icon class="d-md-none mr-2" @click="drawer = !drawer" />

            <v-btn text to="/" ripple="false" class="pa-0">
                <img src="/assets/img/small_logo_makeurshop.png" class="icons" height="40" alt="Logo" />
            </v-btn>
        </div>

        <v-spacer />

        <div class="nav-center-categories d-none d-md-flex">
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
    </v-app-bar>
</template>

<script setup>
    import { useTheme } from 'vuetify';
    import { ref } from 'vue';
    import configData from '/assets/config.json';

    const theme = useTheme();
    const drawer = ref(false);

    const showSearch = ref(false);
    const searchQuery = ref('');
</script>
