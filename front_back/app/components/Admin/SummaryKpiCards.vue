<template>
    <v-row class="mb-6">
        <v-col cols="12" sm="4">
            <v-card rounded="lg" class="py-4 border-grey-lighten-2 bg-white">
                <div class="d-flex align-center justify-space-between px-5">
                    <div>
                        <div class="text-caption text-uppercase tracking-wider text-grey-darken-1 font-weight-bold">Nombre de Clients</div>
                        <div class="text-h4 font-weight-medium mt-2 text-grey-darken-4 number-font">
                            {{ kpis?.total_customers || 0 }}
                        </div>
                    </div>
                    <v-icon icon="mdi-account-group" color="grey-darken-1" size="28"></v-icon>
                </div>
            </v-card>
        </v-col>

        <v-col cols="12" sm="4">
            <v-card rounded="lg" class="py-4 border-grey-lighten-2 bg-white">
                <div class="d-flex align-center justify-space-between px-5">
                    <div>
                        <div class="text-caption text-uppercase tracking-wider text-grey-darken-1 font-weight-bold">Panier Moyen</div>
                        <div class="text-h4 font-weight-medium mt-2 text-grey-darken-4 number-font">
                            {{ parseFloat(kpis?.avg_order_value || 0).toFixed(2) }}
                            <span class="text-h5 text-grey ml-1">€</span>
                        </div>
                    </div>
                    <v-icon icon="mdi-currency-eur" color="grey-darken-1" size="28"></v-icon>
                </div>
            </v-card>
        </v-col>

        <v-col cols="12" sm="4">
            <v-card rounded="lg" class="py-4 border-grey-lighten-2 bg-white">
                <div class="d-flex align-center justify-space-between px-5">
                    <div>
                        <div class="text-caption text-uppercase tracking-wider text-grey-darken-1 font-weight-bold">Commandes / Client</div>
                        <div class="text-h4 font-weight-medium mt-2 text-grey-darken-4 number-font">
                            {{ parseFloat(kpis?.avg_orders_per_customer || 0).toFixed(1) }}
                        </div>
                    </div>
                    <v-icon icon="mdi-shopping-refresh" color="grey-darken-1" size="28"></v-icon>
                </div>
            </v-card>
        </v-col>
    </v-row>
</template>

<script setup>
    const { data: kpis } = await useFetch('/api/admin/stats/summary-kpis');
</script>

<style scoped>
    /* Espacement des lettres pour le style "Dashboard Premium" sur les petits titres */
    .tracking-wider {
        letter-spacing: 0.08em !important;
    }

    /* Optionnel : Donne un style "compteur" très propre aux chiffres */
    .number-font {
        font-family:
            'Inter',
            -apple-system,
            BlinkMacSystemFont,
            sans-serif;
        letter-spacing: -0.03em;
    }
</style>
