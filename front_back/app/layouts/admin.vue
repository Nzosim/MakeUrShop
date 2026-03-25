<template>
    <v-app>
        <AdminNavbar />
        <client-only>
            <LoadingScreen :loading="isLoading" />
        </client-only>
        <v-main>
            <slot />
        </v-main>
    </v-app>
</template>

<script setup>
    import AdminNavbar from '../components/Admin/AdminNavbar.vue';
    import LoadingScreen from '../components/Main/LoadingScreen.vue';

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
