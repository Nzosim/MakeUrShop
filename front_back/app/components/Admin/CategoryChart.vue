<template>
    <v-card elevation="2" rounded="lg" class="h-100">
        <v-card-item>
            <v-card-title class="text-h6 font-weight-bold">Parts de Marché par Rayon</v-card-title>
        </v-card-item>
        <v-divider></v-divider>
        <v-card-text class="d-flex justify-center align-center" style="height: 320px">
            <div v-if="!categories || categories.length === 0">Aucune catégorie vendue</div>
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

    const { data: categories } = await useFetch('/api/admin/stats/categories');

    const chartData = computed(() => {
        if (!categories.value) return { labels: [], datasets: [] };
        return {
            labels: categories.value.map((c) => c.name),
            datasets: [
                {
                    data: categories.value.map((c) => c.revenue),
                    backgroundColor: ['#4CAF50', '#E91E63', '#00BCD4', '#9C27B0'],
                },
            ],
        };
    });

    const chartOptions = { responsive: true, maintainAspectRatio: false, plugins: { legend: { position: 'bottom' } } };
</script>
