<template>
    <v-footer class="d-flex align-center justify-center ga-2 flex-wrap flex-grow-1 py-3 mt-10" color="surface" elevation="12">
        <v-btn
            v-for="link in footerLinks"
            :key="link.title"
            :to="link.url.startsWith('mailto') ? null : link.url"
            :href="link.url.startsWith('mailto') ? link.url : null"
            variant="text"
            rounded
            class="categories"
        >
            {{ link.title }}
        </v-btn>
        <div class="flex-1-0-100 text-center mt-2">
            {{ new Date().getFullYear() }} — ©
            <strong>{{ storeName }}</strong>
            — {{ storeEmail }}
        </div>
    </v-footer>
</template>
<script setup>
    import configData from '@/assets/config.json';
    const storeName = configData.config.info.storeName;
    const storeEmail = configData.config.info.storeEmail;
    const footerLinks = [
        { title: 'CGV', url: '/cgv' },
        { title: 'MENTIONS LÉGALES', url: '/legal-mentions' },
        { title: 'POLITIQUE DE CONFIDENTIALITÉ', url: '/privacy-policy' },
        { title: 'FAQ', url: '/faq' },
        { title: 'NOUS CONTACTER', url: `mailto:${storeEmail}` },
        { title: 'A PROPOS', url: `/About` },
    ];
</script>
