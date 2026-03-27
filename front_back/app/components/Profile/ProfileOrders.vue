<template>
    <v-card class="pa-6" rounded="lg">
        <h2 class="text-h5 mb-6 text-accent font-weight-bold">Historique des commandes</h2>

        <v-list v-if="orders.length > 0">
            <v-list-item v-for="order in orders" :key="order.id" :title="'Commande #' + order.id" :subtitle="formatDate(order.order_date) + ' - ' + formatStatus(order.statut)" />
        </v-list>

        <div v-else class="text-grey">Aucune commande trouvée.</div>
    </v-card>
</template>

<script setup>
    const orders = ref([]);
    const user = useState('user');

    const fetchOrders = async () => {
        if (!user.value?.id) return;

        try {
            const data = await $fetch('/api/user/getOrder', {
                params: { id: user.value.id },
            });
            orders.value = data;
        } catch (error) {
            console.error('Erreur lors du chargement :', error);
        }
    };

    watch(user, () => fetchOrders(), { immediate: true });

    function formatDate(date) {
        if (!date) return 'Date inconnue';
        return new Date(date).toLocaleDateString('fr-FR');
    }

    function formatStatus(status) {
        if (!status) return 'Statut inconnu';

        if (status === 'en_attente') return 'En attente';
        if (status === 'payee') return 'Payée';
        if (status === 'expediee') return 'Expédiée';
        if (status === 'livree') return 'Livrée';
        if (status === 'annulee') return 'Annulée';

        return status;
    }
</script>
