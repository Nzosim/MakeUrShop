<template>
    <v-row class="font-weight-bold border-b pb-2">
        <v-col cols="2">Etat</v-col>
        <v-col cols="2">Image</v-col>
        <v-col cols="3">Nom du produit</v-col>
        <v-col cols="3">Date</v-col>
        <v-col cols="2">Prix</v-col>
    </v-row>

    <v-expansion-panels variant="accordion" expand-icon-position="start">
        <v-expansion-panel v-for="product in products" :key="product.id">
            <v-expansion-panel-title>
                <v-row align="center" class="w-100">
                    <v-col cols="2">
                        <v-chip color="primary" variant="flat">
                            {{ product.status }}
                        </v-chip>
                    </v-col>

                    <v-col cols="2">
                        <v-img :src="product.image" width="40" height="40" />
                    </v-col>

                    <v-col cols="3">{{ product.name }}</v-col>

                    <v-col cols="3">{{ product.date }}</v-col>

                    <v-col cols="2">{{ product.price }} €</v-col>
                </v-row>
            </v-expansion-panel-title>

            <v-expansion-panel-text>
                <StockListAdmin :product="product" />
            </v-expansion-panel-text>
        </v-expansion-panel>
    </v-expansion-panels>
</template>

<script setup>
    import StockListAdmin from '~/components/Admin/StockListAdmin.vue';

    const products = [
        {
            id: 1,
            status: 'Actif',
            image: 'https://encrypted-tbn3.gstatic.com/shopping?q=tbn:ANd9GcRRyKSsZTQ7QbG668eAK6Q0R4YaEJno88kxsbM-0VSqsLOMFOePujxNSdMDpx-b98wUVsUNO2bTzfcSzL9dqtN0fshl8JtUwT1ZcZEdqVgM5v9RPgDA5WYk',
            name: 'T-shirt',
            date: '2024-03-01',
            price: 29.99,
        },
        {
            id: 2,
            status: 'Actif',
            image: 'https://encrypted-tbn3.gstatic.com/shopping?q=tbn:ANd9GcRRyKSsZTQ7QbG668eAK6Q0R4YaEJno88kxsbM-0VSqsLOMFOePujxNSdMDpx-b98wUVsUNO2bTzfcSzL9dqtN0fshl8JtUwT1ZcZEdqVgM5v9RPgDA5WYk',
            name: 'T-shirt',
            date: '2024-03-01',
            price: 29.99,
        },
    ];
</script>
