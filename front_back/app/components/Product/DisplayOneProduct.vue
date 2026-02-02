<template>
    <v-card class="product-card" elevation="2" width="300px">
        <div class="product-image-container">
            <img :src="product.url" :alt="product.name" class="product-image" />
        </div>
        <div class="product-info pa-4">
            <h4 class="product-name mb-2">{{ product.name }}</h4>
            <p class="product-price">{{ product.price }} €</p>
        </div>
    </v-card>
</template>

<script setup>
    const props = defineProps({
        product: Object,
    });

    const emit = defineEmits(['update:product']);
</script>
