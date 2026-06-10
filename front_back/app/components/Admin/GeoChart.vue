<template>
    <v-card elevation="2" rounded="lg" class="h-100">
        <v-card-item>
            <v-card-title class="text-h6 font-weight-bold">Ventes par Département</v-card-title>
        </v-card-item>
        <v-divider></v-divider>
        <v-card-text class="d-flex justify-center align-center" style="height: 320px">
            <div v-if="!geoData || geoData.length === 0">Aucune donnée géographique</div>
            <ClientOnly v-else>
                <Bar :data="chartData" :options="chartOptions" />
            </ClientOnly>
        </v-card-text>
    </v-card>
</template>

<script setup>
    import { Bar } from 'vue-chartjs';
    import { Chart as ChartJS, Title, Tooltip, Legend, BarElement, CategoryScale, LinearScale } from 'chart.js';
    ChartJS.register(Title, Tooltip, Legend, BarElement, CategoryScale, LinearScale);

    const { data: geoData } = await useFetch('/api/admin/stats/geo');

    const chartData = computed(() => {
        if (!geoData.value) return { labels: [], datasets: [] };
        return {
            labels: geoData.value.map((g) => `Dept ${g.department}`),
            datasets: [
                {
                    label: "Chiffre d'affaires (€)",
                    data: geoData.value.map((g) => g.revenue),
                    backgroundColor: '#FF9800',
                    borderRadius: 4,
                },
            ],
        };
    });

    const chartOptions = {
        responsive: true,
        maintainAspectRatio: false,
        indexAxis: 'y', // Transforme le graphique en barres horizontales
        plugins: { legend: { display: false } },
    };
</script>
