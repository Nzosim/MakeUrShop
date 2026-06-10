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
                    <v-btn icon="mdi-minus" size="x-small" variant="outlined" density="compact" :disabled="stock.stock_number <= 0 || stock.saving" @click="adjust(stock, -1)" />
                    <v-text-field
                        v-model.number="stock.stock_number"
                        type="number"
                        density="compact"
                        variant="outlined"
                        hide-details
                        min="0"
                        style="width: 70px"
                        :disabled="stock.saving"
                        :error="!!stock.error"
                        @update:model-value="scheduleSave(stock)"
                        @blur="flushSave(stock)"
                    />
                    <v-btn icon="mdi-plus" size="x-small" variant="outlined" density="compact" :disabled="stock.saving" @click="adjust(stock, +1)" />
                </div>
            </v-col>

            <v-col cols="4" class="px-3 py-2 d-flex align-center">
                <v-chip :color="stock.stock_number > 0 ? 'success' : 'error'" size="small" variant="flat">
                    {{ stock.stock_number > 0 ? 'Disponible' : 'Épuisé' }}
                </v-chip>
                <v-progress-circular v-if="stock.saving" indeterminate size="14" width="2" class="ml-2" />
                <v-tooltip v-else-if="stock.error" :text="stock.error" location="top">
                    <template #activator="{ props: tipProps }">
                        <v-icon v-bind="tipProps" color="error" size="16" class="ml-2">mdi-alert-circle</v-icon>
                    </template>
                </v-tooltip>
                <v-icon v-else-if="stock.saved" color="success" size="16" class="ml-2">mdi-check</v-icon>
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
        product: {
            type: Object,
            required: true,
        },
    });

    const DEBOUNCE_MS = 500;
    const SAVED_INDICATOR_MS = 2000;

    const buildLocal = (stocks) =>
        stocks.map((s) => ({
            ...s,
            saving: false,
            saved: false,
            error: null,
            _lastSaved: s.stock_number,
        }));

    const localStocks = ref(buildLocal(props.product.stocks));

    // Timers gardés hors de la réactivité
    const debounceTimers = new Map();
    const savedTimers = new Map();

    // Resynchronise si le produit change (ex: changement de page)
    watch(
        () => props.product.stocks,
        (newStocks) => {
            localStocks.value = buildLocal(newStocks);
        }
    );

    const save = async (stock) => {
        // Annule un éventuel debounce en attente
        if (debounceTimers.has(stock.id)) {
            clearTimeout(debounceTimers.get(stock.id));
            debounceTimers.delete(stock.id);
        }

        const value = Number(stock.stock_number);

        // Validation
        if (!Number.isInteger(value) || value < 0) {
            stock.error = 'Valeur invalide';
            stock.stock_number = stock._lastSaved;
            return;
        }

        // Rien à sauvegarder si la valeur est inchangée
        if (value === stock._lastSaved) return;

        const previous = stock._lastSaved;
        stock.saving = true;
        stock.saved = false;
        stock.error = null;

        try {
            await $fetch('/api/admin/updateStock', {
                method: 'PUT',
                body: { stock_id: stock.id, stock_number: value },
            });

            stock._lastSaved = value;
            stock.saved = true;

            // Reset visuel après quelques secondes
            if (savedTimers.has(stock.id)) clearTimeout(savedTimers.get(stock.id));
            savedTimers.set(
                stock.id,
                setTimeout(() => {
                    stock.saved = false;
                    savedTimers.delete(stock.id);
                }, SAVED_INDICATOR_MS)
            );
        } catch (err) {
            // Rollback sur erreur
            stock.stock_number = previous;
            stock.error = err?.data?.message || err?.message || 'Erreur de sauvegarde';
        } finally {
            stock.saving = false;
        }
    };

    const scheduleSave = (stock) => {
        stock.error = null;
        if (debounceTimers.has(stock.id)) clearTimeout(debounceTimers.get(stock.id));
        debounceTimers.set(
            stock.id,
            setTimeout(() => save(stock), DEBOUNCE_MS)
        );
    };

    const flushSave = (stock) => {
        if (debounceTimers.has(stock.id)) save(stock);
    };

    const adjust = (stock, delta) => {
        const next = (stock.stock_number || 0) + delta;
        if (next < 0) return;
        stock.stock_number = next;
        scheduleSave(stock);
    };

    onBeforeUnmount(() => {
        debounceTimers.forEach((t) => clearTimeout(t));
        savedTimers.forEach((t) => clearTimeout(t));
        debounceTimers.clear();
        savedTimers.clear();
    });
</script>
