<template>
    <v-app>
        <Navbar />
        <v-main>
            <slot />
            <NuxtPage />
        </v-main>
        <Footer />
    </v-app>
</template>

<script setup>
    import Navbar from './components/Main/Navbar.vue';
    import Footer from './components/Main/Footer.vue';
</script>
