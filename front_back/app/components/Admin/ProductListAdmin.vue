<template>
    <v-row class="font-weight-bold border-b px-4 pb-2 pt-3 text-caption text-uppercase text-medium-emphasis" style="letter-spacing: 0.07em">
        <v-col cols="2">État</v-col>
        <v-col cols="2">Image</v-col>
        <v-col cols="3">Nom du produit</v-col>
        <v-col cols="3">Date</v-col>
        <v-col cols="2">Prix</v-col>
    </v-row>

    <v-expansion-panels variant="accordion" expand-icon-position="start" class="mt-1" density="compact">
        <v-expansion-panel v-for="product in products" :key="product.product_id" elevation="0">
            <v-expansion-panel-title>
                <v-row align="center" class="w-100">
                    <v-col cols="2">
                        <v-chip :color="product.totalStock > 0 ? 'primary' : 'error'" variant="flat" size="small">
                            {{ product.totalStock > 0 ? 'Actif' : 'Rupture' }}
                        </v-chip>
                    </v-col>

                    <v-col cols="2">
                        <v-img :src="product.image" width="40" height="40" cover style="border-radius: 6px" />
                    </v-col>

                    <v-col cols="3" class="text-body-2 font-weight-medium">
                        {{ product.product_name }}
                    </v-col>

                    <v-col cols="3" class="text-body-2 text-medium-emphasis">
                        {{ formatDate(product.creation_date) }}
                    </v-col>

                    <v-col cols="2" class="text-body-2 font-weight-medium">{{ product.price }} €</v-col>
                </v-row>
            </v-expansion-panel-title>

            <v-expansion-panel-text>
                <StockListAdmin :product="product" />
            </v-expansion-panel-text>
        </v-expansion-panel>
    </v-expansion-panels>
</template>

<script setup>
    import StockListAdmin from '~/components/Admin/StockList.vue';

    const { data: rows } = await useFetch('/api/admin/getProductsWithStock', {
        method: 'GET',
    });

    const products = computed(() => {
        if (!rows.value) return [];

        const map = new Map();

        for (const row of rows.value) {
            if (!map.has(row.product_id)) {
                map.set(row.product_id, {
                    product_id: row.product_id,
                    product_name: row.product_name,
                    price: row.price,
                    creation_date: row.creation_date,
                    image: row.image,
                    stocks: [],
                });
            }

            if (row.stock_id) {
                map.get(row.product_id).stocks.push({
                    id: row.stock_id,
                    size: row.size,
                    stock_number: row.stock_number,
                });
            }
        }

        return Array.from(map.values()).map((product) => {
            let totalStock = 0;
            for (const s of product.stocks) {
                totalStock += s.stock_number || 0;
            }
            return { ...product, totalStock };
        });
    });

    const formatDate = (date) => {
        if (!date) return '-';
        return new Date(date).toLocaleDateString('fr-FR');
    };
</script>
