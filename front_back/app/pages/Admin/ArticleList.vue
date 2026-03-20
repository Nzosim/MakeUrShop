<template>
    <h1>Articles</h1>

    <ButtonsAddStock />
    <ProductListAdmin />
</template>

<script setup>
    // import StockList from '~/components/Admin/StockList.vue';
    import ButtonsAddStock from '~/components/Admin/ButtonsAddStock.vue';
    import ProductListAdmin from '~/components/Admin/ProductListAdmin.vue';

    const { data } = await useFetch('/api/stock/getProducts');
</script>
