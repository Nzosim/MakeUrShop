<script setup>
    import { ref, computed, watch } from 'vue';

    const brands = ref([]);
    const selectedBrandId = ref(null);
    const selectedParentCategoryId = ref(null);
    const selectedCategoryId = ref(null);

    const popup = ref(false);
    const open = ref(false);

    const productName = ref('');
    const productDescription = ref('');
    const productPrice = ref(null);
    const productSalePrice = ref(null);
    const productImageUrl = ref('');
    const productType = ref('classique');
    const productActif = ref(true);

    const { data: dataBrand } = await useFetch('/api/admin/getBrand');
    brands.value = dataBrand.value.map((brand) => brand.name);

    const { data: dataCategories } = await useFetch('/api/admin/getCategories');

    const parentCategories = computed(() => dataCategories.value.filter((c) => c.category_parent_id === null));

    const subCategories = computed(() => {
        if (!selectedParentCategoryId.value) return [];
        return dataCategories.value.filter((c) => c.category_parent_id === selectedParentCategoryId.value);
    });

    watch(selectedParentCategoryId, () => {
        selectedCategoryId.value = null;
    });

    async function addProduct() {
        await $fetch('/api/admin/addProductAdmin', {
            method: 'POST',
            body: {
                category_id: selectedCategoryId.value,
                brand_id: selectedBrandId.value,
                name: productName.value,
                description: productDescription.value,
                price: productPrice.value,
                sale_price: productSalePrice.value,
                image: productImageUrl.value,
                type: productType.value,
                actif: productActif.value ? 1 : 0,
            },
        });
        popup.value = false;
    }
</script>

<template>
    <div class="demo-panel-absolute">
        <v-fab :key="fabPosition" :absolute="fabPosition === 'absolute'" :app="fabPosition === 'fixed'" color="primary" :location="fabLocation" size="large" icon>
            <v-icon>{{ open ? 'mdi-close' : 'mdi-cog' }}</v-icon>

            <v-speed-dial v-model="open" :location="menuLocation" :transition="transition" activator="parent">
                <v-btn key="3" color="warning" icon>
                    <v-icon size="24">$warning</v-icon>
                </v-btn>

                <v-btn key="2" color="error" icon>
                    <v-icon size="24">mdi-minus</v-icon>
                </v-btn>

                <v-btn
                    key="1"
                    color="success"
                    icon
                    @click="
                        popup = true;
                        open = false;
                    "
                >
                    <v-icon size="24">mdi-plus</v-icon>
                </v-btn>

                <!-- 
          <v-btn key="4" color="info" icon>
            <v-icon size="24">$info</v-icon>
          </v-btn> -->
            </v-speed-dial>
        </v-fab>

        <v-dialog v-model="popup" width="1000">
            <v-card class="pa-3">
                <div class="d-flex align-center justify-space-between mb-3">
                    <h2 class="text-h6 font-weight-bold">Ajouter un nouveau produit</h2>
                    <v-chip
                        :color="productActif ? 'success' : 'error'"
                        :prepend-icon="productActif ? 'mdi-check-circle' : 'mdi-close-circle'"
                        class="cursor-pointer"
                        size="small"
                        @click="productActif = !productActif"
                    >
                        {{ productActif ? 'Actif' : 'Inactif' }}
                    </v-chip>
                </div>

                <v-card class="pa-3 mb-3">
                    <p class="text-caption text-medium-emphasis mb-1">Nom du produit</p>
                    <v-text-field v-model="productName" placeholder="Entrez le nom du produit" variant="outlined" density="compact" hide-details class="mb-2" />

                    <p class="text-caption text-medium-emphasis mb-1">Description</p>
                    <v-textarea v-model="productDescription" placeholder="Entrez la description du produit" density="compact" hide-details />
                </v-card>

                <v-card class="pa-3 mb-3">
                    <div class="d-flex gap-4">
                        <div style="width: 35%">
                            <p class="text-caption text-medium-emphasis mb-1">Prix</p>
                            <v-text-field v-model="productPrice" type="number" min="0" prefix="€" variant="outlined" density="compact" hide-details class="mb-2" />
                            <p class="text-caption text-medium-emphasis mb-1">Prix après réduction</p>
                            <v-text-field v-model="productSalePrice" type="number" min="0" prefix="€" variant="outlined" density="compact" hide-details />
                        </div>

                        <v-divider vertical class="mx-3" />

                        <div class="flex-grow-1">
                            <div class="d-flex gap-3 mb-2">
                                <div class="flex-grow-1">
                                    <p class="text-caption text-medium-emphasis mb-1">Marque</p>
                                    <v-select
                                        v-model="selectedBrandId"
                                        :items="dataBrand"
                                        item-title="name"
                                        item-value="id"
                                        placeholder="Selectionnez une marque"
                                        variant="outlined"
                                        density="compact"
                                        hide-details
                                    />
                                </div>
                                <div class="flex-grow-1">
                                    <p class="text-caption text-medium-emphasis mb-1">Genre</p>
                                    <v-select
                                        v-model="selectedParentCategoryId"
                                        :items="parentCategories"
                                        item-title="name"
                                        item-value="id"
                                        placeholder="Selectionnez un genre"
                                        variant="outlined"
                                        density="compact"
                                        hide-details
                                    />
                                </div>
                            </div>
                            <div class="d-flex gap-3">
                                <div class="flex-grow-1">
                                    <p class="text-caption text-medium-emphasis mb-1">Catégorie</p>
                                    <v-select
                                        v-model="selectedCategoryId"
                                        :items="subCategories"
                                        item-title="name"
                                        item-value="id"
                                        placeholder="Selectionnez une catégorie"
                                        variant="outlined"
                                        density="compact"
                                        hide-details
                                        :disabled="!selectedParentCategoryId"
                                    />
                                </div>
                                <div class="flex-grow-1">
                                    <p class="text-caption text-medium-emphasis mb-1">Type</p>
                                    <v-select v-model="productType" :items="['classique', 'enchere']" placeholder="Select Type" variant="outlined" density="compact" hide-details />
                                </div>
                            </div>
                        </div>
                    </div>
                </v-card>

                <v-file-upload browse-text="Local Filesystem" divider-text="or choose locally" icon="mdi-upload" title="Drag and Drop Here" class="mb-3" density="compact" />

                <v-card-actions class="pa-0">
                    <v-spacer />
                    <v-btn @click="popup = false">Annuler</v-btn>
                    <v-btn color="primary" @click="addProduct">Ajouter</v-btn>
                </v-card-actions>
            </v-card>
        </v-dialog>
    </div>
</template>

<style scoped>
    /* This is for documentation purposes and will not be needed in your application */
    ::v-deep(.v-application__wrap) {
        min-height: 0 !important;
    }

    .demo-panel-static,
    .demo-panel-relative {
        margin: 0 80px 50px;
        padding: 24px;
        min-height: 300px;
    }

    .demo-panel-static {
        position: static;
    }

    .demo-panel-absolute {
        position: fixed;
        bottom: 20px;
        right: 20px;
    }

    .v-selection-control--disabled,
    .v-input--disabled .v-selection-control {
        opacity: 0.1;
    }

    .v-radio {
        flex-grow: 0 !important;
    }

    h5 {
        margin-bottom: 12px;
    }

    code {
        display: block;
        font-size: 0.8rem;
        margin-top: 12px;
    }

    ::v-deep(.v-label) {
        margin-left: 8px;
    }
</style>
