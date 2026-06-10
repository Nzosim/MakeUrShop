<template>
    <v-card elevation="2" rounded="lg" class="h-100">
        <v-card-item>
            <v-card-title class="text-h6 font-weight-bold">Top Produits Performants</v-card-title>
        </v-card-item>
        <v-divider></v-divider>
        <v-table density="comfortable">
            <thead>
                <tr>
                    <th class="text-left font-weight-bold">Produit</th>

                    <th class="text-center font-weight-bold cursor-pointer user-select-none" @click="changeSort('quantity')">
                        Ventes
                        <v-icon
                            :icon="sortBy === 'quantity' ? 'mdi-arrow-down' : 'mdi-minus'"
                            size="16"
                            :color="sortBy === 'quantity' ? 'primary' : 'grey-lighten-1'"
                            class="ml-1"
                        ></v-icon>
                    </th>

                    <th class="text-right font-weight-bold cursor-pointer user-select-none" @click="changeSort('revenue')">
                        CA Global
                        <v-icon
                            :icon="sortBy === 'revenue' ? 'mdi-arrow-down' : 'mdi-minus'"
                            size="16"
                            :color="sortBy === 'revenue' ? 'success' : 'grey-lighten-1'"
                            class="ml-1"
                        ></v-icon>
                    </th>
                </tr>
            </thead>
            <tbody>
                <tr v-if="!sortedProducts || sortedProducts.length === 0">
                    <td colspan="3" class="text-center text-grey py-4">Aucune vente enregistrée</td>
                </tr>
                <tr v-for="product in sortedProducts" :key="product.id">
                    <td class="font-weight-medium">{{ product.name }}</td>
                    <td class="text-center font-weight-bold">{{ product.quantity }}</td>
                    <td class="text-right font-weight-bold text-success">{{ product.revenue.toFixed(2) }} €</td>
                </tr>
            </tbody>
        </v-table>
    </v-card>
</template>

<script setup>
    // Récupération brute des données du catalogue
    const { data: products } = await useFetch('/api/admin/stats/top-products');

    // État local du tri ('quantity' par défaut au chargement)
    const sortBy = ref('quantity');

    // Fonction pour intervertir le mode de tri au clic
    const changeSort = (type) => {
        sortBy.value = type;
    };

    // Calcul dynamique de la liste : trie et extrait uniquement le Top 5 associé
    const sortedProducts = computed(() => {
        if (!products.value) return [];

        return [...products.value].sort((a, b) => b[sortBy.value] - a[sortBy.value]).slice(0, 5); // Conserve l'affichage des 5 meilleurs
    });
</script>

<style scoped>
    .cursor-pointer {
        cursor: pointer;
    }
    .user-select-none {
        user-select: none;
    }
    /* Effet de survol discret sur les en-têtes cliquables */
    th.cursor-pointer:hover {
        background-color: rgba(0, 0, 0, 0.03);
    }
</style>
