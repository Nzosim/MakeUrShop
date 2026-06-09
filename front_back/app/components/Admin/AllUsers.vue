<template>
    <v-card class="ma-5 pa-6" rounded="lg" elevation="2">
        <h2 class="text-h5 font-weight-bold mb-6">Gestion des clients</h2>

        <v-progress-linear v-if="pending" indeterminate color="primary" class="mb-4"></v-progress-linear>

        <v-list v-else-if="users?.length">
            <v-list-group v-for="user in users" :key="user.id" :value="user.id">
                <!-- Header de l'utilisateur -->
                <template v-slot:activator="{ props }">
                    <v-list-item v-bind="props" :prepend-icon="mdiAccount">
                        <v-list-item-title class="font-weight-bold">{{ user.firstname }} {{ user.lastname }}</v-list-item-title>
                        <v-list-item-subtitle>{{ user.email }}</v-list-item-subtitle>

                        <template v-slot:append>
                            <v-chip size="small" variant="outlined">{{ user.orders.length }} commande(s)</v-chip>
                        </template>
                    </v-list-item>
                </template>

                <!-- Liste des commandes de cet utilisateur -->
                <div class="pa-4 bg-grey-lighten-4">
                    <v-expansion-panels variant="popout">
                        <v-expansion-panel v-for="order in user.orders" :key="order.id">
                            <v-expansion-panel-title>
                                <strong>Commande #{{ order.id }}</strong>
                                <v-spacer></v-spacer>
                                <span class="text-caption mr-4">{{ formatDate(order.order_date) }}</span>
                                <v-chip :color="getStatusColor(order.statut)" size="x-small" label>
                                    {{ order.statut }}
                                </v-chip>
                            </v-expansion-panel-title>

                            <v-expansion-panel-text>
                                <v-table density="compact" class="transparent-table">
                                    <thead>
                                        <tr>
                                            <th>Produit</th>
                                            <th>Qté</th>
                                            <th class="text-right">Prix</th>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <tr v-for="item in order.items" :key="item.name">
                                            <td>{{ item.name }}</td>
                                            <td>x{{ item.quantity }}</td>
                                            <td class="text-right">{{ item.unit_price }}€</td>
                                        </tr>
                                    </tbody>
                                </v-table>
                                <div class="text-right pt-2 font-weight-bold">Total : {{ order.total }}€</div>
                            </v-expansion-panel-text>
                        </v-expansion-panel>
                    </v-expansion-panels>
                </div>
            </v-list-group>
        </v-list>

        <v-alert v-else type="info" variant="tonal">Aucune donnée trouvée.</v-alert>
    </v-card>
</template>

<script setup>
    const { data: users, pending, refresh } = useFetch('/api/admin/users-orders');

    const formatDate = (d) => (d ? new Date(d).toLocaleDateString('fr-FR') : '---');

    const getStatusColor = (status) => {
        const colors = {
            payee: 'success',
            en_attente: 'warning',
            expediee: 'info',
            livree: 'primary',
            annulee: 'error',
        };
        return colors[status] || 'grey';
    };
</script>

<style scoped>
    .transparent-table {
        background: transparent !important;
    }
</style>
