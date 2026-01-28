<template>
    <div>
        <h2>{{ product.name }}</h2>
        <p>{{ product.description }}</p>
        <p>Price: {{ product.price }} €</p>
        <img :src="product.url" height="200px" alt="Product Image" />
    </div>
</template>

<script setup>
    const props = defineProps({
        product: Object,
    });

    console.log(props.product);

    const emit = defineEmits(['update:product']);
</script>
