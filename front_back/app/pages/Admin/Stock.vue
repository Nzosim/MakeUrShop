<template>
    <h1>Stock disponible</h1>

    <ButtonsAddStock />


    
    <stock-list :products="data" />

    

</template>


<script setup>
    import StockList from '~/components/Admin/StockList.vue';
    import ButtonsAddStock from '~/components/Admin/ButtonsAddStock.vue';

    const { data } = await useFetch('/api/stock/getStock');
</script>