<template>
    <v-footer class="d-flex align-center justify-center ga-2 flex-wrap flex-grow-1 py-3 mt-10" color="surface" elevation="8">
        <v-btn v-for="link in links" :key="link" :text="link" variant="text" rounded class="categories"></v-btn>

        <div class="flex-1-0-100 text-center mt-2">
            {{ new Date().getFullYear() }} —
            <strong>{{ storeName }}</strong>
            — {{ storeEmail }}
        </div>
    </v-footer>
</template>
<script setup>
    import configData from '@/assets/config.json';
    const storeName = configData.config.info.storeName;
    const storeEmail = configData.config.info.storeEmail;
    const links = ['CGV', 'MENTIONS LÉGALES', 'POLITIQUE DE CONFIDENTIALITÉ', 'FAQ', 'NOUS CONTACTER'];
</script>
