<template>
    <v-row class="font-weight-bold text-caption text-grey" dense>
        <v-col cols="4" class="px-3">Taille unique</v-col>
        <v-col cols="4" class="px-3">Stock</v-col>
        <v-col cols="4" class="px-3">Statut</v-col>
    </v-row>

    <v-divider class="my-1" />

    <template v-for="(stock, index) in product.stocks" :key="stock.id">
        <v-row align="center" dense>
            <v-col cols="4" class="px-3 py-2">{{ stock.size }}</v-col>
            <v-col cols="4" class="px-3 py-2">{{ stock.stock_number }}</v-col>
            <v-col cols="4" class="px-3 py-2">
                <v-chip :color="stock.stock_number > 0 ? 'success' : 'error'" size="small" variant="flat">
                    {{ stock.stock_number > 0 ? 'Disponible' : 'Épuisé' }}
                </v-chip>
            </v-col>
        </v-row>
        <v-divider v-if="index > 0 && index < product.stocks.length - 1" />
    </template>

    <v-row v-if="!product.stocks?.length" dense>
        <v-col class="px-3 py-2 text-grey text-caption">Aucun stock enregistré</v-col>
    </v-row>
</template>

<script setup>
    defineProps({
        product: {
            type: Object,
            required: true,
        },
    });
</script>
