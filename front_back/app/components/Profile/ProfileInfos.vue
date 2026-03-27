<script setup>
    const props = defineProps(['user']);
    const emit = defineEmits(['updated']);

    const isEditing = ref(false);
    const editableUser = ref({});

    const toggleEdit = async () => {
        if (!isEditing.value) {
            editableUser.value = { ...props.user };
            isEditing.value = true;
        } else {
            try {
                await $fetch('/api/user/update', {
                    method: 'PUT',
                    body: editableUser.value,
                });

                const userState = useState('user');
                userState.value = { ...editableUser.value };
                localStorage.setItem('user', JSON.stringify(userState.value));

                isEditing.value = false;
                emit('updated');
            } catch (err) {
                console.error(err);
                alert('Erreur lors de la mise à jour');
            }
        }
    };
</script>

<template>
    <v-card class="pa-6" rounded="lg">
        <div>
            <h2 class="text-h5 mb-6 text-accent font-weight-bold">Bonjour {{ user.firstname }}</h2>

            <v-row dense>
                <v-col cols="12" sm="6">
                    <p class="text-caption mb-0">Prénom</p>

                    <v-text-field v-if="isEditing" v-model="editableUser.firstname" density="compact" />
                    <p v-else class="text-body-1 mb-4">
                        {{ user.firstname }}
                    </p>
                </v-col>
                <v-col cols="12" sm="6">
                    <p class="text-caption mb-0">Nom</p>

                    <v-text-field v-if="isEditing" v-model="editableUser.lastname" density="compact" />
                    <p v-else class="text-body-1 mb-4">
                        {{ user.lastname }}
                    </p>
                </v-col>
                <v-col cols="12" sm="6">
                    <p class="text-caption mb-0">E-mail</p>

                    <v-text-field v-if="isEditing" v-model="editableUser.email" density="compact" />
                    <p v-else class="text-body-1 mb-4">
                        {{ user.email }}
                    </p>
                </v-col>
                <v-col cols="12" sm="6">
                    <p class="text-caption mb-0">Téléphone</p>

                    <v-text-field v-if="isEditing" v-model="editableUser.phone" density="compact" />
                    <p v-else class="text-body-1 mb-4">
                        {{ user.phone || 'Non renseigné' }}
                    </p>
                </v-col>
            </v-row>

            <v-btn color="primary" class="mt-6" @click="toggleEdit">
                {{ isEditing ? 'Enregistrer' : 'Modifier mes informations' }}
            </v-btn>
        </div>
    </v-card>
</template>

<style scoped>
    .border-accent {
        border: 1px solid rgba(var(--v-theme-accent), 0.3);
    }
</style>
