<template>
    <v-card class="mt-5 ml-5 mr-5 pa-6" rounded="lg">
        <ButtonAddProduct />
        <ProductListAdmin />
        <Brand />
    </v-card>
</template>

<script setup>
    definePageMeta({
        layout: 'admin',
    });

    import ButtonAddProduct from '~/components/Admin/ButtonAddProduct.vue';
    import ProductListAdmin from '~/components/Admin/ProductListAdmin.vue';
    import Brand from '~/components/Admin/Brand.vue';
</script>
