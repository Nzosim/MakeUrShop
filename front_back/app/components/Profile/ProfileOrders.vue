<template>
    <v-card class="pa-6" rounded="lg">
        <h2 class="text-h5 mb-6 text-accent font-weight-bold">Historique des commandes</h2>

        <v-list v-if="orders.length > 0">
            <v-list-item v-for="order in orders" :key="order.id" class="flex-column align-stretch" @click="toggleOrder(order.id)" style="cursor: pointer">
                <!-- Résumé de la commande avec icône -->
                <div class="d-flex justify-space-between align-center w-100">
                    <span class="font-weight-bold">Commande #{{ order.id }}</span>
                    <div class="d-flex align-center">
                        <span class="text-body-2 mr-2">{{ formatDate(order.order_date) }} - {{ formatStatus(order.statut) }}</span>
                        <v-icon :class="{ 'rotate-90': expandedOrder === order.id }" small>mdi-chevron-right</v-icon>
                    </div>
                </div>

                <!-- Détails produits (menu déroulant) -->
                <v-expand-transition>
                    <div v-if="expandedOrder === order.id" class="mt-4 ml-4">
                        <v-list dense class="bg-grey-lighten-4 rounded px-0">
                            <v-list-item v-for="item in order.items" :key="item.id" class="py-2 px-4">
                                <div class="d-flex align-center w-100" style="gap: 16px">
                                    <v-avatar size="70" rounded="0" class="flex-shrink-0">
                                        <v-img :src="item.image" cover />
                                    </v-avatar>

                                    <div class="flex-grow-1">
                                        <span class="text-subtitle-2 font-weight-medium text-wrap">
                                            {{ item.name }}
                                        </span>
                                    </div>

                                    <div class="text-right flex-shrink-0">
                                        <span class="text-subtitle-1 font-weight-bold">
                                            {{ parseFloat(item.unit_price).toFixed(2) }}€
                                            <span v-if="item.quantity > 1" class="text-subtitle-2 text-grey ml-1">x{{ item.quantity }}</span>
                                        </span>
                                    </div>
                                </div>
                            </v-list-item>

                            <v-divider class="my-2"></v-divider>
                            <v-list-item class="d-flex justify-end px-4">
                                <span class="text-h6 font-weight-bold">Total : {{ parseFloat(order.total).toFixed(2) }}€</span>
                            </v-list-item>
                        </v-list>
                    </div>
                </v-expand-transition>
            </v-list-item>
        </v-list>

        <div v-else class="text-grey text-center py-4">Aucune commande trouvée.</div>
    </v-card>
</template>

<script setup>
    import { ref, watch } from 'vue';

    const orders = ref([]);
    const user = useState('user');
    const expandedOrder = ref(null);

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
        const statuses = {
            en_attente: 'En attente',
            payee: 'Payée',
            expediee: 'Expédiée',
            livree: 'Livrée',
            annulee: 'Annulée',
        };
        return statuses[status] || status || 'Statut inconnu';
    }

    function toggleOrder(id) {
        expandedOrder.value = expandedOrder.value === id ? null : id;
    }
</script>

<style>
    .rotate-90 {
        transform: rotate(90deg);
        transition: transform 0.2s;
    }
</style>
