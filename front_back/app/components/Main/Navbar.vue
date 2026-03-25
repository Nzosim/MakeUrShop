<template>
    <v-navigation-drawer v-model="drawer" temporary color="surface">
        <v-list>
            <v-list-item v-for="category in categories" :key="category.id" :to="`/Product/${category.id}`" @click="drawer = false">
                <v-list-item-title>{{ category.name }}</v-list-item-title>
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
            <v-menu v-for="category in categories" :key="category.id" open-on-hover offset-y>
                <template #activator="{ props }">
                    <v-btn text class="categories" ripple="false" :to="`/Product/${category.id}`" v-bind="props">
                        {{ category.name }}
                    </v-btn>
                </template>

                <v-list v-if="category.children && category.children.length">
                    <v-list-item v-for="sub in category.children" :key="sub.id" :to="`/Product/${sub.id}`">
                        <v-list-item-title>{{ sub.name }}</v-list-item-title>
                    </v-list-item>
                </v-list>
            </v-menu>
        </div>

        <v-spacer />

        <div class="d-flex align-center nav-side-block justify-end">
            <v-btn icon @click="theme.toggle()" variant="text">
                <v-icon size="22">
                    {{ theme.global.name.value === 'light' ? 'mdi-weather-night' : 'mdi-white-balance-sunny' }}
                </v-icon>
            </v-btn>

            <v-btn icon to="/Cart/View" variant="text">
                <v-icon size="22">mdi-cart-outline</v-icon>
            </v-btn>

            <v-btn icon to="/User/Profile" variant="text">
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

    const { data: categories } = await useFetch('/api/navbar/getCategories');
</script>
