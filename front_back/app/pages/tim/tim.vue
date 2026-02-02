<script setup>

    const { data: tests } = await useFetch('/api/tim/tim');
    console.log(tests);

</script>

<template>

</template>


<style scoped>

</style>