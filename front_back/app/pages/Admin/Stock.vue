<template>
    <h1>Stock disponible</h1>

    <stock-list :products="data" />

</template>


<script setup>
    import StockList from '~/components/Admin/StockList.vue';

    const { data } = await useFetch('/api/stock/getStock');
</script>