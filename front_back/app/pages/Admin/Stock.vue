<template>
    Stock disponible
    <stock-list v-model:products="data" />
</template>


<script setup>
    const { data } = await useFetch('/api/stock/getStock');
</script>