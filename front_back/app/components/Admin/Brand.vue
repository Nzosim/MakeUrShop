<template>
    <v-card class="mt-5 ml-5 mr-5 pa-6" rounded="lg">
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

        <v-alert v-if="addSuccessMsg" type="success" variant="tonal" density="compact" class="mt-2 mb-2" closable @click:close="addSuccessMsg = ''">
            {{ addSuccessMsg }}
        </v-alert>

        <v-divider class="my-6" />

        <!-- Header liste -->
        <div class="d-flex align-center justify-space-between mb-3">
            <p class="text-subtitle-2 font-weight-bold mb-0">Marques existantes</p>
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
            </v-card>
        </v-dialog>
    </v-card>
</template>

<script setup>
    const newBrandName = ref('');
    const loading = ref(false);
    const addSuccessMsg = ref('');
    const addErrorMsg = ref('');
    const delSuccessMsg = ref('');
    const search = ref('');
    const deleteDialog = ref(false);
    const brandToDelete = ref(null);
    const deletingId = ref(null);

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

            addSuccessMsg.value = `Marque ${newBrandName.value.trim()} ajoutée avec succès.`;
            newBrandName.value = '';
            await refresh();
        } catch (e) {
            addErrorMsg.value = e?.data?.message || 'Une erreur est survenue.';
        } finally {
            loading.value = false;
        }
    }

    function openDeleteDialog(brand) {
        brandToDelete.value = brand;
        deleteDialog.value = true;
    }

    async function confirmDelete() {
        delSuccessMsg.value = '';

        deletingId.value = brandToDelete.value.id;
        try {
            await $fetch('/api/admin/deleteBrand', {
                method: 'DELETE',
                body: { id: brandToDelete.value.id },
            });

            delSuccessMsg.value = `Marque ${brandToDelete.value.name} supprimée.`;
            deleteDialog.value = false;
            await refresh();
        } catch (e) {
            addErrorMsg.value = e?.data?.message || 'Erreur lors de la suppression.';
        } finally {
            deletingId.value = null;
            brandToDelete.value = null;
        }
    }
</script>
