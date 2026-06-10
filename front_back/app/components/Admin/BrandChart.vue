<template>
    <v-card elevation="2" rounded="lg" class="h-100">
        <v-card-item><v-card-title class="text-h6 font-weight-bold">Top 5 Marques (€)</v-card-title></v-card-item>
        <v-divider></v-divider>
        <v-card-text class="d-flex justify-center align-center" style="height: 320px">
            <div v-if="!brands || brands.length === 0">Aucune donnée disponible</div>
            <ClientOnly v-else>
                <Doughnut :data="chartData" :options="chartOptions" />
            </ClientOnly>
        </v-card-text>
    </v-card>
</template>

<script setup>
    import { Doughnut } from 'vue-chartjs';
    import { Chart as ChartJS, Tooltip, Legend, ArcElement } from 'chart.js';
    ChartJS.register(Tooltip, Legend, ArcElement);

    const { data: brands } = await useFetch('/api/admin/stats/brands');

    const chartData = computed(() => {
        if (!brands.value) return { labels: [], datasets: [] };
        return {
            labels: brands.value.map((b) => b.name),
            datasets: [
                {
                    data: brands.value.map((b) => b.revenue),
                    backgroundColor: ['#1867C0', '#5CBBF6', '#4CAF50', '#FB8C00', '#E91E63'],
                },
            ],
        };
    });

    const chartOptions = { responsive: true, maintainAspectRatio: false, plugins: { legend: { position: 'bottom' } } };
</script>
