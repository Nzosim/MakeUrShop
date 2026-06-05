<template>
    <div class="d-flex align-center gap-3 mb-6">
        <v-icon color="primary" size="28">mdi-tag-plus-outline</v-icon>
        <div>
            <p class="text-h6 font-weight-bold mb-0">Gestion des marques</p>
            <p class="text-caption text-medium-emphasis mb-0">Ajoutez ou supprimez des marques</p>
        </div>
    </div>

    <div class="d-flex gap-3 align-start">
        <div class="flex-grow-1">
            <p class="text-caption text-medium-emphasis mb-1">Nom de la marque</p>
            <v-text-field
                v-model="newBrandName"
                placeholder="Nike, Adidas, Zara..."
                variant="outlined"
                density="compact"
                :error-messages="addErrorMsg"
                @keyup.enter="submitBrand"
            />
        </div>
        <div class="mt-5">
            <v-btn color="primary" variant="flat" :loading="loading" :disabled="!newBrandName?.trim()" prepend-icon="mdi-plus" @click="submitBrand">Ajouter</v-btn>
        </div>
    </div>

    <v-text-field v-model="search" placeholder="Rechercher une marque..." variant="outlined" density="compact" prepend-inner-icon="mdi-magnify" clearable class="mb-3" />

    <v-data-table :headers="headers" :items="dataBrand ?? []" :search="search" density="compact" :items-per-page="10" no-data-text="Aucune marque enregistrée">
        <template #item.actions="{ item }">
            <v-btn icon="mdi-trash-can-outline" size="small" variant="text" color="error" :loading="deletingId === item.id" @click="openDeleteDialog(item)" />
        </template>
    </v-data-table>

    <v-dialog v-model="deleteDialog" max-width="400">
        <v-card rounded="lg" class="pa-4">
            <div class="d-flex align-center gap-3 mb-4">
                <v-icon color="error" size="28">mdi-alert-circle-outline</v-icon>
                <p class="text-subtitle-1 font-weight-bold mb-0">Supprimer la marque</p>
            </div>
            <p class="text-body-2 text-medium-emphasis mb-6">
                Êtes-vous sûr de vouloir supprimer
                <strong>{{ brandToDelete?.name }}</strong>
                ? Cette action est irréversible.
            </p>
            <div class="d-flex justify-end gap-3">
                <v-btn variant="text" @click="deleteDialog = false">Annuler</v-btn>
                <v-btn color="error" variant="flat" :loading="deletingId !== null" @click="confirmDelete">Supprimer</v-btn>
            </div>
            <v-alert v-if="deleteErrorMsg" type="error" variant="tonal" density="compact" class="mb-4">
                {{ deleteErrorMsg }}
            </v-alert>
        </v-card>
    </v-dialog>

    <Teleport to="body">
        <Transition name="ok">
            <div v-if="showSuccessPopup" class="pop-up-ok">
                <v-icon color="white" size="48">mdi-check-circle</v-icon>
                <p class="text-white font-weight-bold mt-2">Supprimé</p>
            </div>
        </Transition>
    </Teleport>
</template>

<script setup>
    const newBrandName = ref('');
    const loading = ref(false);
    const addSuccessMsg = ref('');
    const addErrorMsg = ref('');
    const search = ref('');
    const deleteDialog = ref(false);
    const brandToDelete = ref(null);
    const deletingId = ref(null);
    const showSuccessPopup = ref(false);
    const deleteErrorMsg = ref('');

    const { data: dataBrand, refresh } = await useFetch('/api/admin/getBrand');

    const headers = [
        { title: 'Nom', key: 'name' },
        { title: '', key: 'actions', sortable: false, align: 'end' },
    ];

    async function submitBrand() {
        addErrorMsg.value = '';
        addSuccessMsg.value = '';

        const brandName = newBrandName.value?.trim();

        if (!brandName) {
            addErrorMsg.value = 'Veuillez entrer un nom de marque valide.';
            return;
        }

        if (brandName.length < 2) {
            addErrorMsg.value = 'Le nom de la marque doit contenir au moins 2 caractères.';
            return;
        }

        if (!/^[a-zA-ZÀ-ÿ0-9' -]+$/.test(brandName)) {
            addErrorMsg.value = 'Le nom de la marque contient des caractères non autorisés.';
            return;
        }

        if (!/[a-zA-ZÀ-ÿ0-9]/.test(brandName)) {
            addErrorMsg.value = 'Le nom doit contenir au moins une lettre ou un chiffre.';
            return;
        }

        loading.value = true;
        try {
            await $fetch('/api/admin/addBrand', {
                method: 'POST',
                body: { name: newBrandName.value.trim() },
            });

            newBrandName.value = '';
            await refresh();
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

    function openDeleteDialog(brand) {
        brandToDelete.value = brand;
        deleteErrorMsg.value = '';
        deleteDialog.value = true;
    }

    async function confirmDelete() {
        deletingId.value = brandToDelete.value.id;
        try {
            await $fetch('/api/admin/deleteBrand', {
                method: 'DELETE',
                body: { id: brandToDelete.value.id },
            });

            deleteDialog.value = false;
            await refresh();
            showSuccessPopup.value = true;
            setTimeout(() => {
                showSuccessPopup.value = false;
            }, 1800);
        } catch (e) {
            deleteErrorMsg.value = e?.data?.message || 'Erreur lors de la suppression.';
        } finally {
            deletingId.value = null;
            brandToDelete.value = null;
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

    .pop-up-ok-enter-active,
    .pop-up-ok-leave-active {
        transition:
            opacity 0.25s ease,
            transform 0.25s ease;
    }

    .pop-up-ok-enter-from,
    .pop-up-ok-leave-to {
        opacity: 0;
        transform: translate(-50%, -50%) scale(0.85);
    }
</style>
