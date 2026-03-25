<script setup>
    import { ref, computed, watch } from 'vue';

    const props = defineProps({
        modelValue: Boolean,
    });
    const emit = defineEmits(['update:modelValue']);

    const popup = computed({
        get: () => props.modelValue,
        set: (val) => emit('update:modelValue', val),
    });

    const page = ref(1);

    const selectedBrandId = ref(null);
    const selectedParentCategoryId = ref(null);
    const selectedCategoryId = ref(null);

    const productName = ref('');
    const productDescription = ref('');
    const productPrice = ref(null);
    const productSalePrice = ref(null);
    const productImageUrl = ref('');
    const productType = ref('classique');
    const productActif = ref(true);

    const { data: dataBrand } = await useFetch('/api/admin/getBrand');
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
        page.value = 1;
    }
</script>

<template>
    <v-dialog v-model="popup" width="1000">
        <v-card class="pa-3">
            <!-- Page 1 -->
            <template v-if="page === 1">
                <div class="d-flex align-center justify-space-between mb-3">
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
                    <v-text-field v-model="productName" placeholder="Entrez le nom du produit" variant="outlined" density="compact" />

                    <p class="text-caption text-medium-emphasis mb-1">Description</p>
                    <v-textarea v-model="productDescription" placeholder="Entrez la description du produit" density="compact" />
                </v-card>

                <v-card class="pa-3 mb-3">
                    <div class="d-flex gap-4">
                        <div style="width: 35%">
                            <p class="text-caption text-medium-emphasis mb-1">Prix</p>
                            <v-text-field v-model="productPrice" type="number" min="0" prefix="€" variant="outlined" density="compact" />
                            <p class="text-caption text-medium-emphasis mb-1">Prix après réduction</p>
                            <v-text-field v-model="productSalePrice" type="number" min="0" prefix="€" variant="outlined" density="compact" />
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
                                        :disabled="!selectedParentCategoryId"
                                    />
                                </div>
                                <div class="flex-grow-1">
                                    <p class="text-caption text-medium-emphasis mb-1">Type</p>
                                    <v-select v-model="productType" :items="['classique', 'enchere']" placeholder="Select Type" variant="outlined" density="compact" />
                                </div>
                            </div>
                        </div>
                    </div>
                    <v-file-upload browse-text="Local Filesystem" divider-text="or choose locally" icon="mdi-upload" title="Drag and Drop Here" class="mb-3" density="compact" />
                </v-card>
            </template>

            <!-- Page 2 -->
            <template v-else-if="page === 2">test</template>

            <!-- Pagination -->
            <div class="text-center mt-3">
                <v-pagination v-model="page" :length="2" rounded="circle" />
            </div>
        </v-card>
    </v-dialog>
</template>
