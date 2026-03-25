<template>
    <ButtonAddProduct />
    <ProductListAdmin />
</template>

<script setup>
    definePageMeta({
        layout: 'admin',
    });

    import ButtonAddProduct from '~/components/Admin/ButtonAddProduct.vue';
    import ProductListAdmin from '~/components/Admin/ProductListAdmin.vue';
</script>
