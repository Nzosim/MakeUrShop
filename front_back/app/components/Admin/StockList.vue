<template>
    <v-row class="font-weight-bold text-caption text-grey" dense>
        <v-col cols="3" class="px-3">Taille</v-col>
        <v-col cols="5" class="px-3">Stock</v-col>
        <v-col cols="4" class="px-3">Statut</v-col>
    </v-row>

    <v-divider class="my-1" />

    <template v-for="(stock, index) in localStocks" :key="stock.id">
        <v-row align="center" dense>
            <v-col cols="3" class="px-3 py-2 text-body-2">{{ stock.size }}</v-col>

            <v-col cols="5" class="px-3 py-1">
                <div class="d-flex align-center ga-1">
                    <v-text-field
                        v-model.number="stock.qty"
                        type="number"
                        density="compact"
                        hide-details
                        hide-spin-buttons
                        min="0"
                        style="width: 80px"
                        :disabled="stock.saving"
                        @keyup.enter="save(stock)"
                    />

                    <div class="d-flex flex-column ga-1 ml-1">
                        <v-btn icon="mdi-chevron-up" size="x-small" density="compact" :disabled="stock.saving" @click="stock.qty = (Number(stock.qty) || 0) + 1" />
                        <v-btn
                            icon="mdi-chevron-down"
                            size="x-small"
                            density="compact"
                            :disabled="stock.qty <= 0 || stock.saving"
                            @click="stock.qty = Math.max(0, (Number(stock.qty) || 0) - 1)"
                        />
                    </div>

                    <v-btn
                        v-if="isDirty(stock)"
                        icon="mdi-check"
                        size="small"
                        color="success"
                        variant="flat"
                        density="comfortable"
                        class="ml-2"
                        :loading="stock.saving"
                        @click="save(stock)"
                    />
                </div>
            </v-col>

            <v-col cols="4" class="px-3 py-2 d-flex align-center">
                <v-chip :color="stock.qty > 0 ? 'success' : 'error'" size="small" variant="flat">
                    {{ stock.qty > 0 ? 'Disponible' : 'Épuisé' }}
                </v-chip>
                <v-icon v-if="stock.saved === stock.qty && !stock.error" color="success" size="16" class="ml-2">mdi-check</v-icon>
                <v-tooltip v-if="stock.error" :text="stock.error" location="top">
                    <template #activator="{ props: tipProps }">
                        <v-icon v-bind="tipProps" color="error" size="16" class="ml-2">mdi-alert-circle</v-icon>
                    </template>
                </v-tooltip>
            </v-col>
        </v-row>
        <v-divider v-if="index < localStocks.length - 1" />
    </template>

    <v-row v-if="!localStocks.length" dense>
        <v-col class="px-3 py-2 text-grey text-caption">Aucun stock enregistré</v-col>
    </v-row>
</template>

<script setup>
    const props = defineProps({
        product: { type: Object, required: true },
    });

    const buildLocal = (stocks) =>
        stocks.map((s) => ({
            id: s.id,
            size: s.size,
            qty: s.stock_number, // valeur affichée / éditable
            saved: s.stock_number, // dernière valeur confirmée serveur
            saving: false,
            error: null,
        }));

    const localStocks = ref(buildLocal(props.product.stocks));

    watch(
        () => props.product.stocks,
        (newStocks) => {
            localStocks.value = buildLocal(newStocks);
        }
    );

    const isDirty = (stock) => Number(stock.qty) !== stock.saved;

    const save = async (stock) => {
        const value = Number(stock.qty);

        if (!Number.isInteger(value) || value < 0) {
            stock.error = 'Valeur invalide';
            stock.qty = stock.saved;
            return;
        }

        if (value === stock.saved) return;

        stock.saving = true;
        stock.error = null;

        console.log('→ Envoi:', { stock_id: stock.id, stock_number: value });

        try {
            const res = await $fetch('/api/admin/updateStock', {
                method: 'PUT',
                body: { stock_id: stock.id, stock_number: value },
            });
            console.log('← Réponse:', res);
            stock.saved = value;
        } catch (err) {
            console.error('✗ Erreur:', err);
            stock.qty = stock.saved;
            stock.error = err?.data?.message || err?.message || 'Erreur de sauvegarde';
        } finally {
            stock.saving = false;
        }
    };
</script>
