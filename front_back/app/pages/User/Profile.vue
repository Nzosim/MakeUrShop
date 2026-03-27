<template>
    <v-container>
        <v-scale-transition origin="top right">
            <v-alert
                v-if="accountEdited"
                type="success"
                variant="tonal"
                density="compact"
                class="added-alert"
                style="position: absolute; top: 80px; right: 24px; width: auto; min-width: 260px; max-width: 380px; z-index: 100"
            >
                Informations modifiées.
            </v-alert>
        </v-scale-transition>
        <h1 class="my-12">Mon compte</h1>

        <v-row v-if="user">
            <v-col cols="12" md="3">
                <v-list class="bg-transparent">
                    <v-list-item prepend-icon="mdi-account-circle" title="Informations du compte" class="text mb-2 text-wrap" rounded="lg" active-color="text" active></v-list-item>

                    <v-list-item prepend-icon="mdi-history" class="text mb-2" rounded="lg" active-color="text">
                        <v-list-item-title style="white-space: normal; line-height: 1.2">Historique de commandes</v-list-item-title>
                    </v-list-item>

                    <v-list-item prepend-icon="mdi-logout" title="Se déconnecter" class="text text-error mt-4" rounded="lg" @click="logout"></v-list-item>
                </v-list>
            </v-col>

            <v-col cols="12" md="9">
                <v-card class="pa-6 border-accent" rounded="lg">
                    <div>
                        <h2 class="text-h5 mb-6 text-accent font-weight-bold">Bonjour {{ user.firstname }}</h2>

                        <v-row dense>
                            <v-col cols="12" sm="6">
                                <p class="text-caption mb-0">Prénom</p>

                                <v-text-field v-if="isEditing" v-model="editableUser.firstname" density="compact" />
                                <p v-else class="text-body-1 mb-4">{{ user.firstname }}</p>
                            </v-col>

                            <v-col cols="12" sm="6">
                                <p class="text-caption mb-0">Nom</p>

                                <v-text-field v-if="isEditing" v-model="editableUser.lastname" density="compact" />
                                <p v-else class="text-body-1 mb-4">{{ user.lastname }}</p>
                            </v-col>

                            <v-col cols="12" sm="6">
                                <p class="text-caption mb-0">E-mail</p>

                                <v-text-field v-if="isEditing" v-model="editableUser.email" density="compact" />
                                <p v-else class="text-body-1 mb-4">{{ user.email }}</p>
                            </v-col>

                            <v-col cols="12" sm="6">
                                <p class="text-caption mb-0">Téléphone</p>

                                <v-text-field v-if="isEditing" v-model="editableUser.phone" density="compact" />
                                <p v-else class="text-body-1 mb-4">
                                    {{ user.phone || 'Non renseigné' }}
                                </p>
                            </v-col>
                        </v-row>

                        <v-btn color="primary" class="mt-6 categories" @click="toggleEdit">
                            {{ isEditing ? 'Enregistrer' : 'Modifier mes informations' }}
                        </v-btn>
                    </div>
                </v-card>
            </v-col>
        </v-row>

        <v-row v-else justify="center">
            <v-progress-circular indeterminate></v-progress-circular>
        </v-row>
    </v-container>
</template>

<script setup>
    const accountEdited = ref(false);
    const user = useState('user');

    watch(
        user,
        (val) => {
            if (!val) {
                navigateTo('/User/Login');
            }
        },
        { immediate: true }
    );

    const isEditing = ref(false);
    const editableUser = ref({});

    const toggleEdit = async () => {
        if (!isEditing.value) {
            editableUser.value = { ...user.value };
            isEditing.value = true;
        } else {
            try {
                await $fetch('/api/user/update', {
                    method: 'PUT',
                    body: editableUser.value,
                });

                user.value = { ...editableUser.value };
                localStorage.setItem('user', JSON.stringify(user.value));

                isEditing.value = false;

                accountEdited.value = true;

                setTimeout(() => {
                    accountEdited.value = false;
                }, 3000);
            } catch (err) {
                console.error(err);
                alert('Erreur lors de la mise à jour');
            }
        }
    };
    const logout = () => {
        user.value = null; // Vide l'état réactif
        localStorage.removeItem('user'); // Nettoie le navigateur
        navigateTo('/User/Login'); // Redirige
    };
</script>

<style scoped>
    .text-error {
        color: #d32f2f !important;
    }
    .v-scale-transition-enter-active,
    .v-scale-transition-leave-active {
        transition:
            transform 0.4s cubic-bezier(0.34, 1.56, 0.64, 1),
            opacity 0.3s ease;
    }
</style>
