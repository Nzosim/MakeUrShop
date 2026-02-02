<template>
    <div v-for="product in products" :key="product.id" class="mt-5">
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
