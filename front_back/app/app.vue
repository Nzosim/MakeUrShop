<template>
    <v-app>
        <Navbar />
        <v-main>
            <slot />
            <NuxtPage />
        </v-main>
    </v-app>
</template>

<script setup>
    import Navbar from './components/Main/Navbar.vue';
</script>
