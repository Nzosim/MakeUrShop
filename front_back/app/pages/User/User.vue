<template>
    <v-container>
        <h1 class="my-12">MON COMPTE</h1>

        <v-row>
            <v-col cols="12" md="3">
                <v-list class="bg-transparent">
                    <v-list-item
                        prepend-icon="mdi-account-circle"
                        title="Informations du compte"
                        class="text-accent mb-2 text-wrap"
                        rounded="lg"
                        active-color="primary"
                        active
                    ></v-list-item>
                    <v-list-item prepend-icon="mdi-history" class="text-accent" rounded="lg" active-color="primary">
                        <v-list-item-title style="white-space: normal; line-height: 1.2">Historique de commandes</v-list-item-title>
                    </v-list-item>
                </v-list>
            </v-col>

            <v-col cols="12" md="9">
                <v-card class="pa-6 border-accent" rounded="lg">
                    <div v-for="user in users" :key="user.id">
                        <h2 class="text-h5 mb-6 text-accent font-weight-bold">Bonjour {{ user.firstname }}</h2>

                        <v-row dense>
                            <v-col cols="12" sm="6">
                                <p class="text-caption text-secondary mb-0">Prénom</p>
                                <p class="text-body-1 text-accent mb-4">{{ user.firstname }}</p>
                            </v-col>
                            <v-col cols="12" sm="6">
                                <p class="text-caption text-secondary mb-0">Nom</p>
                                <p class="text-body-1 text-accent mb-4">{{ user.lastname }}</p>
                            </v-col>
                            <v-col cols="12" sm="6">
                                <p class="text-caption text-secondary mb-0">E-mail</p>
                                <p class="text-body-1 text-accent mb-4">{{ user.email }}</p>
                            </v-col>
                            <v-col cols="12" sm="6">
                                <p class="text-caption text-secondary mb-0">Téléphone</p>
                                <p class="text-body-1 text-accent mb-4">{{ user.phone || 'Non renseigné' }}</p>
                            </v-col>
                            <v-col cols="12">
                                <p class="text-caption text-secondary mb-0">Adresse</p>
                                <p class="text-body-1 text-accent">{{ user.address || 'Aucune adresse enregistrée' }}</p>
                            </v-col>
                        </v-row>

                        <v-btn color="primary" variant="flat" class="mt-6 categories">Modifier mes informations</v-btn>
                    </div>
                </v-card>
            </v-col>
        </v-row>
    </v-container>
</template>

<script setup>
    const { data: users } = await useFetch('/api/user/getUser?id=2');
</script>
