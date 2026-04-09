<template>
    <div class="product-list-container mt-5">
        <div class="px-4 mb-2 filter-btn">
            <v-btn size="large" color="primary" prepend-icon="mdi-filter-variant" @click="showFilters = !showFilters">Filtres</v-btn>
        </div>

        <div v-if="showFilters && !isDesktop" class="filter-backdrop" @click="showFilters = false"></div>

        <div class="filter-section" :class="{ 'mobile-modal': !isDesktop && showFilters }" v-show="showFilters || isDesktop">
            <div class="filter ma-5">
                <div class="d-flex justify-space-between">
                    <h3 class="mt-1"><b>Filtres</b></h3>
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

        <div class="products-section-main">
            <div class="products-section justify-center">
                <product-list v-model:products="paginatedProducts" />
            </div>

            <div v-if="totalPages > 1" class="pagination d-flex justify-center align-center ga-2 my-8">
                <v-btn icon size="small" variant="text" :disabled="currentPage === 1" @click="goToPage(currentPage - 1)">
                    <v-icon>mdi-chevron-left</v-icon>
                </v-btn>

                <div v-for="page in displayedPages" :key="page">
                    <span v-if="page === '...'" class="pagination-content">...</span>
                    <v-btn v-else size="small" :variant="page === currentPage ? 'flat' : 'outlined'" :color="page === currentPage ? 'primary' : undefined" @click="goToPage(page)">
                        {{ page }}
                    </v-btn>
                </div>

                <v-btn icon size="small" variant="text" :disabled="currentPage === totalPages" @click="goToPage(currentPage + 1)">
                    <v-icon>mdi-chevron-right</v-icon>
                </v-btn>
            </div>

            <p v-if="sortedProducts.length > 0" class="text-center text-grey mb-4">
                {{ (currentPage - 1) * itemsPerPage + 1 }}-{{ Math.min(currentPage * itemsPerPage, sortedProducts.length) }} sur {{ sortedProducts.length }} produits
            </p>
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
    const showFilters = ref(false);
    const isDesktop = ref(false);

    // Pagination
    const currentPage = ref(1);
    const itemsPerPage = 12;

    const toggleBrand = (brand) => {
        selectedBrand.value = selectedBrand.value === brand ? null : brand;
        currentPage.value = 1;
    };

    const toggleSize = (value) => {
        size.value = size.value === value ? null : value;
        currentPage.value = 1;
    };

    // Reset page quand on change un filtre
    watch([selectedItem, priceRange, selectedBrand, size], () => {
        currentPage.value = 1;
    });

    const sortedProducts = computed(() => {
        if (!data.value) return [];

        let sorted = [...data.value];

        // Filtre par prix
        sorted = sorted.filter((product) => product.price >= priceRange.value[0] && product.price <= priceRange.value[1]);

        // Filtre par marque
        if (selectedBrand.value) {
            sorted = sorted.filter((product) => product.brand_name === selectedBrand.value);
        }

        // Filtre par taille
        if (size.value) {
            const stockKey = `taille_${size.value}`;
            sorted = sorted.filter((product) => (product?.[stockKey] ?? 0) > 0);
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

    const totalPages = computed(() => Math.ceil(sortedProducts.value.length / itemsPerPage));

    const paginatedProducts = computed(() => {
        const start = (currentPage.value - 1) * itemsPerPage; // Index de départ de la page
        return sortedProducts.value.slice(start, start + itemsPerPage);
    });

    const displayedPages = computed(() => {
        const total = totalPages.value;
        const current = currentPage.value;
        const pages = [];

        // Si plus de 7 pages on les affiches pas toutes
        if (total <= 7) {
            for (let i = 1; i <= total; i++) pages.push(i);
        } else {
            pages.push(1);
            if (current > 3) pages.push('...');
            for (let i = Math.max(2, current - 1); i <= Math.min(total - 1, current + 1); i++) {
                pages.push(i);
            }
            if (current < total - 2) pages.push('...');
            pages.push(total);
        }
        return pages;
    });

    onMounted(() => {
        isDesktop.value = window.innerWidth > 940;
        window.addEventListener('resize', () => {
            isDesktop.value = window.innerWidth > 940;
        });
    });

    // Changement de page
    const goToPage = (page) => {
        if (page >= 1 && page <= totalPages.value) {
            currentPage.value = page;
            window.scrollTo({ top: 0, behavior: 'smooth' });
        }
    };
</script>

<style scoped>
    .product-list-container {
        display: block;
        position: relative;
    }

    .filter-btn {
        display: block;
    }

    .filter-backdrop {
        position: fixed;
        inset: 0;
        background: rgba(0, 0, 0, 0.3);
        z-index: 999;
    }

    .filter-section.mobile-modal {
        position: fixed;
        top: 50%;
        left: 50%;
        transform: translate(-50%, -50%);
        z-index: 1000;
        max-height: 80vh;
        overflow-y: auto;
        border-radius: 8px;
        background: white;
        box-shadow: 0 8px 32px rgba(0, 0, 0, 0.2);
        width: 90%;
        max-width: 500px;
    }

    @media (min-width: 941px) {
        .product-list-container {
            display: flex;
        }

        .filter-btn {
            display: none;
        }

        .filter-backdrop {
            display: none;
        }

        .filter-section.mobile-modal {
            position: static;
            transform: none;
            max-height: none;
            overflow: visible;
            border-radius: 0;
            background: transparent;
            box-shadow: none;
            width: auto;
            max-width: none;
        }
    }
</style>
