<template>
    <v-app>
        <Navbar />
        <client-only>
            <LoadingScreen :loading="isLoading" />
        </client-only>
        <v-main>
            <slot />
        </v-main>
        <AdminRedirectionButton v-if="user && user.role === 'admin'" />
        <Footer />
    </v-app>
</template>

<script setup>
    import Navbar from '../components/Main/Navbar.vue';
    import Footer from '../components/Main/Footer.vue';
    import LoadingScreen from '../components/Main/LoadingScreen.vue';
    import AdminRedirectionButton from '~/components/Main/AdminRedirectionButton.vue';
    const nuxtApp = useNuxtApp();
    const isLoading = ref(false);

    nuxtApp.hook('page:start', () => {
        isLoading.value = true;
    });

    nuxtApp.hook('page:finish', () => {
        setTimeout(() => {
            isLoading.value = false;
        }, 10);
    });

    const user = useState('user', () => null);

    onMounted(() => {
        const savedUser = localStorage.getItem('user');
        if (savedUser) {
            user.value = JSON.parse(savedUser);
        }
    });
</script>
