<template>
    <v-card class="mt-5 ml-5 mr-5 pa-6" rounded="lg">
        <Category />
    </v-card>
</template>

<script setup>
    definePageMeta({
        layout: 'admin',
    });

    import Category from '~/components/Admin/Category.vue';
</script>
