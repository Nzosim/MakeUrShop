<template>
    <v-card elevation="2" rounded="lg" class="h-100">
        <v-card-item>
            <v-card-title class="text-h6 font-weight-bold">Santé des Commandes</v-card-title>
        </v-card-item>
        <v-divider></v-divider>
        <v-card-text class="d-flex justify-center align-center" style="height: 320px">
            <div v-if="!healthData || healthData.length === 0">Aucun statut de commande</div>
            <ClientOnly v-else>
                <Pie :data="chartData" :options="chartOptions" />
            </ClientOnly>
        </v-card-text>
    </v-card>
</template>

<script setup>
    import { Pie } from 'vue-chartjs';
    import { Chart as ChartJS, Tooltip, Legend, ArcElement } from 'chart.js';
    ChartJS.register(Tooltip, Legend, ArcElement);

    const { data: healthData } = await useFetch('/api/admin/stats/order-health');

    // Mappage des labels SQL pour l'affichage propre
    const statusLabels = {
        en_attente: 'En attente',
        payee: 'Payée',
        expediee: 'Expédiée',
        livree: 'Livrée',
        annulee: 'Annulée',
    };

    const statusColors = {
        en_attente: '#FB8C00', // Orange
        payee: '#2196F3', // Bleu
        expediee: '#9C27B0', // Violet
        livree: '#4CAF50', // Vert
        annulee: '#F44336', // Rouge
    };

    const chartData = computed(() => {
        if (!healthData.value) return { labels: [], datasets: [] };
        return {
            labels: healthData.value.map((h) => statusLabels[h.status] || h.status),
            datasets: [
                {
                    data: healthData.value.map((h) => h.count),
                    backgroundColor: healthData.value.map((h) => statusColors[h.status] || '#9E9E9E'),
                },
            ],
        };
    });

    const chartOptions = { responsive: true, maintainAspectRatio: false, plugins: { legend: { position: 'bottom' } } };
</script>
