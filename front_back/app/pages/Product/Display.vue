<template>
    Article Homme

    <product-list v-model:products="data" />
</template>

<script setup>
    const { data } = await useFetch('/api/product/getProduct?id=1');
</script>
