<template>
    <v-container>
        <AllUsers />
    </v-container>
</template>
<script setup>
    import AllUsers from '@/components/Admin/AllUsers.vue';
    definePageMeta({
        layout: 'admin',
    });
</script>
