<template>
    <div class="product-detail-container pa-8">
        <h2>Produit {{ productId }}</h2>
        <p>Catégorie : {{ categoryId }}</p>
    </div>
</template>

<script setup>
    const route = useRoute();

    const categoryId = computed(() => route.params.categoryId);
    const productId = computed(() => route.params.productId);
</script>
