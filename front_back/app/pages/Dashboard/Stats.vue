<template>
    <v-container fluid class="pa-6" style="min-height: 100vh">
        <div class="mb-6">
            <h1 class="text-h4 font-weight-bold text-grey-darken-3">Tableau de bord analytique</h1>
            <p class="text-subtitle-1 text-grey">Suivi des performances et de l'activité de la boutique</p>
        </div>

        <v-row class="mt-2 align-stretch">
            <v-col cols="12" md="12">
                <OrderChart />
            </v-col>
        </v-row>

        <SummaryKpiCards />

        <v-row class="mt-2 align-stretch">
            <v-col cols="12" md="6">
                <BrandChart />
            </v-col>
            <v-col cols="12" md="6">
                <StockAlertsTable />
            </v-col>
        </v-row>

        <v-row class="mt-2 align-stretch">
            <v-col cols="12" md="6">
                <GeoChart />
            </v-col>
            <v-col cols="12" md="6">
                <OrderHealthChart />
            </v-col>
        </v-row>

        <v-row class="mt-2 align-stretch">
            <v-col cols="12" md="6">
                <TopProductsTable />
            </v-col>
            <v-col cols="12" md="6">
                <CategoryChart />
            </v-col>
        </v-row>
    </v-container>
</template>

<script setup>
    import SummaryKpiCards from '@/components/Admin/SummaryKpiCards.vue';
    import BrandChart from '@/components/Admin/BrandChart.vue';
    import StockAlertsTable from '@/components/Admin/StockAlertsTable.vue';
    import GeoChart from '@/components/Admin/GeoChart.vue';
    import OrderHealthChart from '@/components/Admin/OrderHealthChart.vue';
    import TopProductsTable from '@/components/Admin/TopProductsTable.vue';
    import CategoryChart from '@/components/Admin/CategoryChart.vue';
    import OrderChart from '~/components/Admin/OrderChart.vue';

    definePageMeta({
        layout: 'admin',
    });
</script>
