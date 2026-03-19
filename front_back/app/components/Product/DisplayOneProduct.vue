<template>
    <v-card class="product-card" :class="{ 'out-of-stock': !isStock }" elevation="2" width="300px">
        <div class="product-image-container">
            <img :src="product.url" :alt="product.name" class="product-image" />
            <p v-if="!isStock" class="soldout">Rupture de stock</p>
            <p v-if="isSolde" class="soldout">Solde</p>
        </div>
        <div class="product-info pa-4">
            <h4 class="product-name mb-2">{{ product.name }}</h4>
            <div class="d-flex">
                <p class="product-price" :class="{ 'product-solde': isSolde }">{{ product.price }} €</p>
                <p v-if="isSolde" class="product-solde-number ml-2">-{{ product.sale_price }}%</p>
                <p v-if="isSolde" class="product-number ml-2">{{ (product.price - (product.price * product.sale_price) / 100).toFixed(2) }} €</p>
            </div>
        </div>
    </v-card>
</template>

<script setup>
    const props = defineProps({
        product: Object,
    });

    const emit = defineEmits(['update:product']);

    const isStock = computed(() => {
        return props.product.taille_S > 0 || props.product.taille_M > 0 || props.product.taille_L > 0 || props.product.taille_XL > 0;
    });

    const isSolde = computed(() => {
        return props.product.sale_price > 0 && isStock;
    });
</script>
