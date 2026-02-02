<template>
    <v-card>
        <img :src="product.url" height="400px" max-width="200px" alt="Product Image" />
        <div class="d-flex">
            <p>{{ product.name }}</p>
            <p>Price: {{ product.price }} €</p>
        </div>
    </v-card>
</template>

<script setup>
    const props = defineProps({
        product: Object,
    });

    console.log(props.product);

    const emit = defineEmits(['update:product']);
</script>
