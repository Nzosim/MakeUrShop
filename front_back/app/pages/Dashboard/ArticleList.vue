<template>
    <h1>Articles</h1>
    <ButtonsAddStock />
    <ProductListAdmin />
</template>

<script setup>
    definePageMeta({
        layout: 'admin',
    });

    import ButtonsAddStock from '~/components/Admin/ButtonsAddStock.vue';
    import ProductListAdmin from '~/components/Admin/ProductListAdmin.vue';
</script>
