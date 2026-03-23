<script setup>
    import { ref, computed, watch } from 'vue';

    const brands = ref([]);
    const selectedBrandId = ref(null);
    const selectedParentCategoryId = ref(null);
    const selectedCategoryId = ref(null);
    const popup = ref(false);
    const open = ref(false);

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

        <v-dialog v-model="popup" width="500">
            <v-card>
                <v-card-text>
                    <v-text-field label="Nom du produit" />
                    <v-text-field label="Prix" type="number" min="0" />
                    <v-text-field label="Quantité" type="number" min="0" />

                    <v-select v-model="selectedBrandId" :items="brands" item-title="name" item-value="id" label="Choisir une marque" variant="outlined" density="compact" />

                    <v-select
                        v-model="selectedParentCategoryId"
                        :items="parentCategories"
                        item-title="name"
                        item-value="id"
                        label="Choisir un sexe"
                        variant="outlined"
                        density="compact"
                        class="mt-2"
                    />

                    <v-select
                        v-model="selectedCategoryId"
                        :items="subCategories"
                        item-title="name"
                        item-value="id"
                        label="Choisir une catégorie"
                        variant="outlined"
                        density="compact"
                        :disabled="!selectedParentCategoryId"
                        class="mt-2"
                    />
                </v-card-text>

                <v-card-actions>
                    <v-spacer />
                    <v-btn @click="popup = false">Annuler</v-btn>
                    <v-btn color="primary" @click="popup = false">Ajouter</v-btn>
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
