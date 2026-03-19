<template>
    <NuxtLink v-for="product in products" :key="product.id" class="mt-5" :to="`/Product/${route.params.id}/${product.id}`" style="text-decoration: none; color: inherit">
        <display-one-product :product="product" />
    </NuxtLink>
</template>

<script setup>
    import DisplayOneProduct from './DisplayOneProduct.vue';

    const props = defineProps({
        products: Array,
    });

    const emit = defineEmits(['update:products']);

    const route = useRoute();
</script>
