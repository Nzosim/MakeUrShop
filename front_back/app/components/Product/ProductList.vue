<template>
    <div v-for="product in products" :key="product.id">
        <display-one-product :product="product" />
    </div>
</template>

<script setup>
    import DisplayOneProduct from './DisplayOneProduct.vue';

    const props = defineProps({
        products: Array,
    });

    const emit = defineEmits(['update:products']);
</script>
