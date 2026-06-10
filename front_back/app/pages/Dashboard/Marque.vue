<template>
    <v-card class="mt-5 ml-5 mr-5 pa-6" rounded="lg">
        <Brand />
    </v-card>
</template>

<script setup>
    definePageMeta({
        layout: 'admin',
    });

    import Brand from '~/components/Admin/Brand.vue';
</script>
