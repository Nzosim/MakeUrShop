<template>
    <v-card class="mx-auto my-6" max-width="1000" elevation="2" rounded="lg">
        <v-card-item class="d-flex align-center justify-space-between flex-wrap">
            <div>
                <v-card-title class="text-h6 font-weight-bold">Analyse des Ventes</v-card-title>
                <v-card-subtitle>Chiffre d'affaires et volume des commandes</v-card-subtitle>
            </div>

            <v-btn-toggle v-model="selectedPeriod" mandatory color="primary" variant="outlined" density="comfortable" class="mt-2">
                <v-btn value="day">Jour</v-btn>
                <v-btn value="week">Semaine</v-btn>
                <v-btn value="month">Mois</v-btn>
                <v-btn value="year">Année</v-btn>
            </v-btn-toggle>
        </v-card-item>

        <v-divider></v-divider>

        <v-card-text class="py-6">
            <div v-if="pending" class="d-flex justify-center align-center" style="height: 400px">
                <v-progress-circular indeterminate color="primary" size="64" width="6"></v-progress-circular>
            </div>

            <v-alert v-else-if="error" type="error" variant="tonal" title="Erreur de chargement" text="Impossible de charger les données." closable></v-alert>

            <div v-else class="chart-wrapper">
                <ClientOnly>
                    <Bar :data="chartData" :options="chartOptions" />
                </ClientOnly>
            </div>
        </v-card-text>
    </v-card>
</template>

<script setup>
    import { ref, computed } from 'vue';
    import { Bar } from 'vue-chartjs';
    import { Chart as ChartJS, Title, Tooltip, Legend, BarElement, CategoryScale, LinearScale } from 'chart.js';

    ChartJS.register(Title, Tooltip, Legend, BarElement, CategoryScale, LinearScale);

    const selectedPeriod = ref('day');

    const { data: stats, pending, error } = await useFetch(() => `/api/admin/stats/orders?group=${selectedPeriod.value}`);

    const chartData = computed(() => {
        if (!stats.value || !Array.isArray(stats.value)) return { labels: [], datasets: [] };

        const labels = stats.value.map((item) => item.period);
        const revenues = stats.value.map((item) => parseFloat(item.total_revenue || 0));
        const ordersCount = stats.value.map((item) => parseInt(item.total_orders || 0));

        return {
            labels,
            datasets: [
                {
                    label: "Chiffre d'affaires (€)",
                    backgroundColor: '#1867C0',
                    data: revenues,
                    yAxisID: 'y',
                    borderRadius: 4,
                },
                {
                    label: 'Nombre de commandes',
                    backgroundColor: '#5CBBF6',
                    data: ordersCount,
                    yAxisID: 'y1',
                    borderRadius: 4,
                },
            ],
        };
    });

    const chartOptions = {
        responsive: true,
        maintainAspectRatio: false,
        scales: {
            y: { type: 'linear', display: true, position: 'left', title: { display: true, text: 'Revenus (€)' } },
            y1: {
                type: 'linear',
                display: true,
                position: 'right',
                grid: { drawOnChartArea: false },
                title: { display: true, text: 'Commandes' },
                ticks: { beginAtZero: true, stepSize: 1 },
            },
        },
    };
</script>

<style scoped>
    .chart-wrapper {
        position: relative;
        height: 400px;
        width: 100%;
    }
</style>
