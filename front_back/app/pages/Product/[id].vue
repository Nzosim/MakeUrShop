<template>
    <div class="product-list-container d-flex mt-5">
        <div class="filter-section">
            <div class="filter ma-5">
                <div class="d-flex justify-space-between">
                    <h3>Filtres</h3>
                    <div class="text-center">
                        <v-menu v-model="menuOpen" open-on-hover>
                            <template v-slot:activator="{ props }" class="d-flex">
                                <div class="d-flex mt-1" v-bind="props">
                                    <p>{{ selectedItem.title }}</p>
                                    <span :class="menuOpen ? 'mdi mdi-chevron-up' : 'mdi mdi-chevron-down'"></span>
                                </div>
                            </template>

                            <v-list>
                                <v-list-item v-for="(item, index) in items" :key="index" :value="index" @click="selectedItem = item">
                                    <v-list-item-title>{{ item.title }}</v-list-item-title>
                                </v-list-item>
                            </v-list>
                        </v-menu>
                    </div>
                </div>
                <h4 class="mt-5 mb-2">Taille</h4>
                <div class="size d-flex ga-1">
                    <p @click="toggleSize('S')" :class="{ active: size === 'S' }">S</p>
                    <p @click="toggleSize('M')" :class="{ active: size === 'M' }">M</p>
                    <p @click="toggleSize('L')" :class="{ active: size === 'L' }">L</p>
                    <p @click="toggleSize('XL')" :class="{ active: size === 'XL' }">XL</p>
                </div>

                <h4 class="mt-5 mb-8">Prix</h4>
                <v-range-slider v-model="priceRange" class="ma-5" min="0" max="1000" step="10" thumb-label="always"></v-range-slider>

                <div v-if="brands.length > 0">
                    <h4 class="mt-5 mb-2">Marque</h4>
                    <div class="size d-flex ga-1 flex-wrap">
                        <p v-for="(brand, index) in brands" @click="toggleBrand(brand)" :class="{ active: selectedBrand === brand }" :key="index">{{ brand }}</p>
                    </div>
                </div>
            </div>
        </div>

        <div class="products-section justify-center">
            <product-list v-model:products="sortedProducts" />
        </div>
    </div>
</template>

<script setup>
    const route = useRoute();
    const categoryId = route.params.id;

    const { data } = await useFetch(`/api/product/getProduct?id=${categoryId}`);

    const items = [{ title: 'Meilleures ventes' }, { title: 'Prix croissant' }, { title: 'Prix décroissant' }, { title: 'Ordre Alphabétique' }];
    const selectedItem = ref(items[0]);
    const menuOpen = ref(false);
    const brands = data.value ? [...new Set(data.value.map((product) => product.brand_name))] : [];

    const size = ref(null);
    const priceRange = ref([0, 1000]);
    const selectedBrand = ref(null);

    const toggleBrand = (brand) => {
        selectedBrand.value = selectedBrand.value === brand ? null : brand;
    };

    const toggleSize = (value) => {
        size.value = size.value === value ? null : value;
    };

    const sortedProducts = computed(() => {
        if (!data.value) return [];

        let sorted = [...data.value];

        // Filter by price range
        sorted = sorted.filter((product) => product.price >= priceRange.value[0] && product.price <= priceRange.value[1]);

        // Filter by brand
        if (selectedBrand.value) {
            sorted = sorted.filter((product) => product.brand_name === selectedBrand.value);
        }

        switch (selectedItem.value.title) {
            case 'Prix croissant':
                return sorted.sort((a, b) => a.price - b.price);
            case 'Prix décroissant':
                return sorted.sort((a, b) => b.price - a.price);
            case 'Ordre Alphabétique':
                return sorted.sort((a, b) => a.name.localeCompare(b.name));
            case 'Meilleures ventes':
            default:
                return sorted;
        }
    });
</script>
