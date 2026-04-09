<template>
    <div class="d-flex align-center gap-3 mb-6">
        <v-icon color="primary" size="28">mdi-shape-plus-outline</v-icon>
        <div>
            <p class="text-h6 font-weight-bold mb-0">Gestion des catégories</p>
            <p class="text-caption text-medium-emphasis mb-0">Ajoutez ou supprimez des catégories</p>
        </div>
    </div>

    <div class="d-flex gap-3 align-start">
        <div class="flex-grow-1">
            <p class="text-caption text-medium-emphasis mb-1">Nom de la catégorie</p>
            <v-text-field
                v-model="newCategoryName"
                placeholder="Électronique, Vêtements, Chaussures..."
                variant="outlined"
                density="compact"
                :error-messages="addErrorMsg"
                @keyup.enter="submitCategory"
            />
        </div>
        <div class="flex-grow-1">
            <p class="text-caption text-medium-emphasis mb-1">Catégorie parente (optionnel)</p>
            <v-select
                v-model="selectedParentId"
                :items="parentOptions"
                item-title="name"
                item-value="id"
                placeholder="Aucune (catégorie racine)"
                variant="outlined"
                density="compact"
                clearable
            />
        </div>
        <div class="mt-5">
            <v-btn color="primary" variant="flat" :loading="loading" :disabled="!newCategoryName?.trim()" prepend-icon="mdi-plus" @click="submitCategory">Ajouter</v-btn>
        </div>
    </div>

    <v-text-field v-model="search" placeholder="Rechercher une catégorie..." variant="outlined" density="compact" prepend-inner-icon="mdi-magnify" clearable class="mb-3" />

    <v-data-table :headers="headers" :items="flatCategories" :search="search" density="compact" :items-per-page="10" no-data-text="Aucune catégorie enregistrée">
        <template #item.parentName="{ item }">
            <span class="text-medium-emphasis">{{ item.parentName || '—' }}</span>
        </template>
        <template #item.actions="{ item }">
            <v-btn icon="mdi-trash-can-outline" size="small" variant="text" color="error" :loading="deletingId === item.id" @click="openDeleteDialog(item)" />
        </template>
    </v-data-table>

    <v-dialog v-model="deleteDialog" max-width="400">
        <v-card rounded="lg" class="pa-4">
            <div class="d-flex align-center gap-3 mb-4">
                <v-icon color="error" size="28">mdi-alert-circle-outline</v-icon>
                <p class="text-subtitle-1 font-weight-bold mb-0">Supprimer la catégorie</p>
            </div>
            <p class="text-body-2 text-medium-emphasis mb-6">
                Êtes-vous sûr de vouloir supprimer
                <strong>{{ categoryToDelete?.name }}</strong>
                ? Cette action est irréversible.
            </p>
            <div class="d-flex justify-end gap-3">
                <v-btn variant="text" @click="deleteDialog = false">Annuler</v-btn>
                <v-btn color="error" variant="flat" :loading="deletingId !== null" @click="confirmDelete">Supprimer</v-btn>
            </div>
            <v-alert v-if="deleteErrorMsg" type="error" variant="tonal" density="compact" class="mt-4">
                {{ deleteErrorMsg }}
            </v-alert>
        </v-card>
    </v-dialog>

    <Teleport to="body">
        <Transition name="ok">
            <div v-if="showSuccessPopup" class="pop-up-ok">
                <v-icon color="white" size="48">mdi-check-circle</v-icon>
                <p class="text-white font-weight-bold mt-2">{{ successMessage }}</p>
            </div>
        </Transition>
    </Teleport>
</template>

<script setup>
    const newCategoryName = ref('');
    const selectedParentId = ref(null);
    const loading = ref(false);
    const addErrorMsg = ref('');
    const search = ref('');
    const deleteDialog = ref(false);
    const categoryToDelete = ref(null);
    const deletingId = ref(null);
    const showSuccessPopup = ref(false);
    const deleteErrorMsg = ref('');
    const successMessage = ref('');

    const { data: dataCategory, refresh } = await useFetch('/api/admin/getCategories');

    const headers = [
        { title: 'Nom', key: 'name' },
        { title: 'Parent', key: 'parentName' },
        { title: '', key: 'actions', sortable: false, align: 'end' },
    ];

    // retourne les catagories sans parents
    const parentOptions = computed(() => {
        if (!dataCategory.value) return [];
        return dataCategory.value.filter((c) => !c.category_parent_id);
    });

    // va chercher le nom du parent
    const flatCategories = computed(() => {
        if (!dataCategory.value) return [];
        return dataCategory.value.map((c) => ({
            ...c,
            parentName: dataCategory.value.find((p) => p.id === c.category_parent_id)?.name || null,
        }));
    });

    async function submitCategory() {
        addErrorMsg.value = '';

        const categoryName = newCategoryName.value?.trim();

        if (!categoryName) {
            addErrorMsg.value = 'Veuillez entrer un nom de catégorie valide.';
            return;
        }

        if (categoryName.length < 2) {
            addErrorMsg.value = 'Le nom de la catégorie doit contenir au moins 2 caractères.';
            return;
        }

        if (!/^[a-zA-ZÀ-ÿ0-9' -]+$/.test(categoryName)) {
            addErrorMsg.value = 'Le nom de la catégorie contient des caractères non autorisés.';
            return;
        }

        loading.value = true;
        try {
            await $fetch('/api/admin/addCategory', {
                method: 'POST',
                body: {
                    category: {
                        name: categoryName,
                        category_parent_id: selectedParentId.value ?? null,
                    },
                },
            });

            newCategoryName.value = '';
            selectedParentId.value = null;
            await refresh();
            successMessage.value = 'Ajouté';
            showSuccessPopup.value = true;
            setTimeout(() => {
                showSuccessPopup.value = false;
            }, 1800);
        } catch (e) {
            addErrorMsg.value = e?.data?.message || 'Une erreur est survenue.';
        } finally {
            loading.value = false;
        }
    }

    function openDeleteDialog(category) {
        categoryToDelete.value = category;
        deleteErrorMsg.value = '';
        deleteDialog.value = true;
    }

    async function confirmDelete() {
        deletingId.value = categoryToDelete.value.id;
        try {
            await $fetch('/api/admin/deleteCategory', {
                method: 'DELETE',
                body: { id: categoryToDelete.value.id },
            });

            deleteDialog.value = false;
            await refresh();
            successMessage.value = 'Supprimé';
            showSuccessPopup.value = true;
            setTimeout(() => {
                showSuccessPopup.value = false;
            }, 1800);
        } catch (e) {
            deleteErrorMsg.value = e?.data?.message || 'Erreur lors de la suppression.';
        } finally {
            deletingId.value = null;
            categoryToDelete.value = null;
        }
    }
</script>

<style scoped>
    .pop-up-ok {
        position: fixed;
        top: 50%;
        left: 50%;
        transform: translate(-50%, -50%);
        background: rgba(0, 0, 0, 0.82);
        backdrop-filter: blur(20px);
        border-radius: 28px;
        width: 160px;
        height: 160px;
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        z-index: 9999;
    }

    .ok-enter-active,
    .ok-leave-active {
        transition:
            opacity 0.25s ease,
            transform 0.25s ease;
    }

    .ok-enter-from,
    .ok-leave-to {
        opacity: 0;
        transform: translate(-50%, -50%) scale(0.85);
    }
</style>
