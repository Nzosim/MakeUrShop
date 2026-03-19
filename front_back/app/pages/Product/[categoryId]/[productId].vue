<template>
    <div class="pa-8 d-flex justify-center" v-if="product">
        <div class="d-flex flex-column flex-md-row ga-8" style="max-width: 900px; width: 100%">
            <div class="mb-4">
                <v-btn variant="text" prepend-icon="mdi-arrow-left" @click="goBack">Retour</v-btn>
            </div>

            <div class="mb-6 mb-md-0">
                <img :src="product.url" :alt="product.name" style="max-width: 400px; width: 100%; border-radius: 8px" />
            </div>

            <div class="flex-grow-1">
                <h1 class="mb-2">{{ product.name }}</h1>
                <p class="text-grey mb-4">Catégorie #{{ categoryId }} • Marque : {{ product.brand_name }}</p>

                <div class="d-flex align-center mb-4">
                    <p class="text-h5 mr-2" :class="{ 'text-decoration-line-through': isSolde }">{{ product.price }} €</p>
                    <p v-if="isSolde" class="text-h5 text-primary mr-2">{{ finalPrice }} €</p>
                    <p v-if="isSolde" class="text-subtitle-2 text-success">-{{ product.sale_price }}%</p>
                </div>

                <p class="mb-6">{{ product.description }}</p>

                <div class="mb-4">
                    <h3 class="mb-2">Tailles disponibles</h3>
                    <div class="d-flex ga-2 flex-wrap">
                        <v-chip v-for="size in availableSizes" :key="size" color="primary" :variant="selectedSize === size ? 'flat' : 'outlined'" @click="toggleSize(size)">
                            {{ size }}
                        </v-chip>
                        <p v-if="!availableSizes.length" class="text-error">Rupture de stock</p>
                    </div>
                </div>

                <v-btn color="primary" :disabled="!isStock || !selectedSize">Ajouter au panier</v-btn>
            </div>
        </div>
    </div>

    <div v-else class="pa-8 text-center">
        <p v-if="pending">Chargement du produit...</p>
        <p v-else>Produit introuvable.</p>
    </div>
</template>

<script setup>
    const route = useRoute();
    const router = useRouter();

    const categoryId = computed(() => route.params.categoryId);
    const productId = computed(() => route.params.productId);

    const { data, pending } = await useFetch(() => `/api/product/getProduct?productId=${productId.value}`);

    const product = computed(() => (data.value && data.value.length ? data.value[0] : null));

    const isStock = computed(() => {
        if (!product.value) return false;
        return (product.value.taille_S ?? 0) > 0 || (product.value.taille_M ?? 0) > 0 || (product.value.taille_L ?? 0) > 0 || (product.value.taille_XL ?? 0) > 0;
    });

    const isSolde = computed(() => {
        if (!product.value) return false;
        return product.value.sale_price > 0 && isStock.value;
    });

    const finalPrice = computed(() => {
        if (!product.value || !isSolde.value) return null;
        return (product.value.price - (product.value.price * product.value.sale_price) / 100).toFixed(2);
    });

    const availableSizes = computed(() => {
        if (!product.value) return [];
        const sizes = [];
        if ((product.value.taille_S ?? 0) > 0) sizes.push('S');
        if ((product.value.taille_M ?? 0) > 0) sizes.push('M');
        if ((product.value.taille_L ?? 0) > 0) sizes.push('L');
        if ((product.value.taille_XL ?? 0) > 0) sizes.push('XL');
        return sizes;
    });

    const selectedSize = ref(null);

    const toggleSize = (size) => {
        selectedSize.value = selectedSize.value === size ? null : size;
    };

    const goBack = () => {
        if (window.history.length > 1) {
            router.back();
            return;
        }

        router.push(`/Product/${categoryId.value}`);
    };
</script>
