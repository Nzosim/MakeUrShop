<template>
    <v-card elevation="2" rounded="lg">
        <v-card-item>
            <template v-slot:prepend><v-icon icon="mdi-package-variant-sticky" color="warning"></v-icon></template>
            <v-card-title class="text-h6 font-weight-bold">Alertes Stocks Bas (≤ 5 unités)</v-card-title>
        </v-card-item>
        <v-divider></v-divider>
        <v-table density="comfortable" hover>
            <thead>
                <tr>
                    <th class="text-left font-weight-bold">Produit</th>
                    <th class="text-center font-weight-bold">Taille</th>
                    <th class="text-right font-weight-bold">Stock Restant</th>
                </tr>
            </thead>
            <tbody>
                <tr v-if="!items || items.length === 0">
                    <td colspan="3" class="text-center text-grey py-4">Tous les stocks sont au vert ! 🚀</td>
                </tr>
                <tr v-for="(item, index) in items" :key="index">
                    <td>{{ item.product }}</td>
                    <td class="text-center">
                        <v-chip size="small" variant="outlined">{{ item.size }}</v-chip>
                    </td>
                    <td class="text-right font-weight-bold text-error">
                        {{ item.stock }}
                        <v-icon icon="mdi-arrow-down" size="14"></v-icon>
                    </td>
                </tr>
            </tbody>
        </v-table>
    </v-card>
</template>

<script setup>
    const { data: items } = await useFetch('/api/admin/stats/low-stock');
</script>
