<template>
    <v-card class="mt-5 ml-5 mr-5 pa-6" rounded="lg">
        <h2 class="text-h5 mb-6 text-accent font-weight-bold">Gestion des commandes</h2>

        <v-list v-if="sortedOrders.length > 0">
            <v-list-item v-for="order in sortedOrders" :key="order.id" class="flex-column align-stretch" @click="toggleOrder(order.id)" style="cursor: pointer">
                <!-- Résumé de la commande avec icône -->
                <div class="d-flex justify-space-between align-center w-100">
                    <span class="font-weight-bold">Commande #{{ order.id }}</span>
                    <div class="d-flex align-center">
                        <span class="text-body-2 mr-2">{{ formatDate(order.order_date) }} - {{ formatStatus(order.statut) }}</span>
                        <v-icon :class="{ 'rotate-90': expandedOrder === order.id }" small>mdi-chevron-right</v-icon>
                    </div>
                </div>
                <v-alert v-if="order.statut === 'annulee'" type="error" variant="tonal" class="mb-4">Cette commande a ete annulee.</v-alert>

                <v-stepper v-else :model-value="getStatusStep(order.statut)" hide-actions flat class="mb-4 rounded bg-grey-lighten-5">
                    <v-stepper-header>
                        <v-stepper-item :value="1" title="En attente"></v-stepper-item>
                        <v-divider></v-divider>
                        <v-stepper-item :value="2" title="Payee"></v-stepper-item>
                        <v-divider></v-divider>
                        <v-stepper-item :value="3" title="Expediee"></v-stepper-item>
                        <v-divider></v-divider>
                        <v-stepper-item :value="4" title="Livree"></v-stepper-item>
                    </v-stepper-header>
                </v-stepper>

                <div class="d-flex justify-end mb-4">
                    <v-btn v-if="canAdvanceStatus(order.statut)" color="primary" size="small" @click.stop="advanceOrderStatus(order)" :loading="updatingOrderId === order.id">
                        {{ getNextStatusLabel(order.statut) }}
                    </v-btn>
                    <span v-else class="text-grey text-caption">Commande finalisée</span>
                </div>

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
    import { computed, ref } from 'vue';

    const orders = ref([]);
    const expandedOrder = ref(null);
    const updatingOrderId = ref(null);

    const sortedOrders = computed(() => {
        const statusOrder = {
            en_attente: 1,
            payee: 2,
            expediee: 3,
            livree: 4,
            annulee: 5,
        };

        return [...orders.value].sort((a, b) => {
            const stepA = statusOrder[a.statut] || 999;
            const stepB = statusOrder[b.statut] || 999;

            if (stepA !== stepB) {
                return stepA - stepB;
            }

            return new Date(b.order_date).getTime() - new Date(a.order_date).getTime();
        });
    });

    const fetchOrders = async () => {
        try {
            const data = await $fetch('/api/order/getAllOrder');
            orders.value = data;
        } catch (error) {
            console.error('Erreur lors du chargement :', error);
        }
    };

    fetchOrders();

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

    function getStatusStep(status) {
        const steps = {
            en_attente: 1,
            payee: 2,
            expediee: 3,
            livree: 4,
        };

        return steps[status] || 1;
    }

    function toggleOrder(id) {
        expandedOrder.value = expandedOrder.value === id ? null : id;
    }

    function canAdvanceStatus(status) {
        return status !== 'livree' && status !== 'annulee';
    }

    function getNextStatusLabel(status) {
        const labels = {
            en_attente: 'Marquer comme payée',
            payee: 'Marquer comme expédiée',
            expediee: 'Marquer comme livrée',
        };
        return labels[status] || 'Mettre à jour';
    }

    async function advanceOrderStatus(order) {
        try {
            updatingOrderId.value = order.id;
            const result = await $fetch('/api/order/updateOrderStatus', {
                method: 'POST',
                body: {
                    orderId: order.id,
                },
            });

            if (result.success) {
                // MAJ local
                const index = orders.value.findIndex((o) => o.id === order.id);
                if (index !== -1) {
                    orders.value[index].statut = result.newStatus;
                }
            }
        } catch (error) {
            console.error('Erreur lors de la mise à jour du statut:', error);
        } finally {
            updatingOrderId.value = null;
        }
    }
</script>

<style>
    .rotate-90 {
        transform: rotate(90deg);
        transition: transform 0.2s;
    }
</style>
