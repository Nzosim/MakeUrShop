<template>
    <v-card class="mt-5 ml-5 mr-5 pa-6" rounded="lg">
        <div class="d-flex justify-space-between align-center mb-6">
            <div>
                <h2 class="text-h5 text-accent font-weight-bold mb-1">Gestion des commandes</h2>
                <p class="text-caption text-medium-emphasis mb-0">Affichage admin des commandes clients</p>
            </div>

            <div class="d-flex align-center" style="gap: 12px; min-width: 320px">
                <v-select
                    v-model="selectedSort"
                    :items="sortOptions"
                    item-title="title"
                    item-value="value"
                    :return-object="false"
                    label="Trier par"
                    variant="outlined"
                    density="compact"
                    hide-details
                />
            </div>
        </div>

        <v-list v-if="sortedOrders.length > 0">
            <v-list-item v-for="order in sortedOrders" :key="order.id" class="flex-column align-stretch" @click="changeOrder(order.id)" style="cursor: pointer">
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

                <div class="d-flex justify-end align-center mb-4" style="gap: 8px">
                    <v-btn
                        v-if="order.statut === 'payee'"
                        color="secondary"
                        variant="outlined"
                        size="small"
                        @click.stop="generateShippingSlip(order)"
                        :loading="generatedOrderId === order.id"
                    >
                        Générer le bordereau
                    </v-btn>
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
    import appConfig from '~/assets/config.json';

    const orders = ref([]);
    const expandedOrder = ref(null);
    const updatingOrderId = ref(null);
    const generatedOrderId = ref(null);
    const selectedSort = ref('status_date');
    const storeInfo = appConfig?.config?.info || {};
    const shipperName = storeInfo.storeName || 'MakeUrStore';
    const shipperAddress = storeInfo.storeAddress || 'Adresse expéditeur non configurée';
    const shipperPhone = storeInfo.storePhone || '';
    const shipperEmail = storeInfo.storeEmail || '';
    const sortOptions = [
        { title: 'Type puis date', value: 'status_date' },
        { title: 'Date puis type', value: 'date_status' },
        { title: 'Date (plus récente)', value: 'date_desc' },
        { title: 'Date (plus ancienne)', value: 'date_asc' },
        { title: 'Montant total (décroissant)', value: 'total_desc' },
        { title: 'Montant total (croissant)', value: 'total_asc' },
        { title: 'Numéro de commande (décroissant)', value: 'id_desc' },
        { title: 'Numéro de commande (croissant)', value: 'id_asc' },
    ];

    const sortedOrders = computed(() => {
        const statusOrder = {
            en_attente: 1,
            payee: 2,
            expediee: 3,
            livree: 4,
            annulee: 5,
        };

        const sortKey = typeof selectedSort.value === 'string' ? selectedSort.value : selectedSort.value?.value || 'status_date';

        return [...orders.value].sort((a, b) => {
            const stepA = statusOrder[a.statut] || 999;
            const stepB = statusOrder[b.statut] || 999;

            const dateA = new Date(a.order_date).getTime();
            const dateB = new Date(b.order_date).getTime();
            const totalA = Number(a.total || 0);
            const totalB = Number(b.total || 0);

            switch (sortKey) {
                case 'status_date':
                    if (stepA !== stepB) return stepA - stepB;
                    return dateB - dateA;

                case 'date_status':
                    if (dateA !== dateB) return dateB - dateA;
                    return stepA - stepB;

                case 'date_desc':
                    return dateB - dateA;

                case 'date_asc':
                    return dateA - dateB;

                case 'total_desc':
                    return totalB - totalA;

                case 'total_asc':
                    return totalA - totalB;

                case 'id_desc':
                    return b.id - a.id;

                case 'id_asc':
                    return a.id - b.id;

                default:
                    if (stepA !== stepB) return stepA - stepB;
                    return dateB - dateA;
            }
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

    function changeOrder(id) {
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

    function getCustomerFullName(order) {
        const firstName = order?.customer?.firstname || '';
        const lastName = order?.customer?.lastname || '';
        const fullName = `${firstName} ${lastName}`.trim();
        return fullName || 'Client inconnu';
    }

    function getShippingAddressLines(order) {
        const shippingAddress = order?.shipping_address || {};
        const firstLine = shippingAddress.address || 'Adresse inconnue';
        const cityLine = [shippingAddress.zip_code, shippingAddress.city].filter(Boolean).join(' ');
        const countryLine = shippingAddress.country || 'Pays inconnu';

        return [firstLine, cityLine || 'Ville inconnue', countryLine];
    }

    function getShippingSlipReference(order) {
        const orderDate = new Date(order?.order_date);
        const safeDate = Number.isNaN(orderDate.getTime()) ? '00000000' : orderDate.toISOString().slice(0, 10).replaceAll('-', '');
        return `MS-${order?.id || '0'}-${safeDate}`;
    }

    function drawFakeBarcode(pdf, code, x, y, width, height) {
        const encoded = String(code || 'MS-0').replaceAll(/\s+/g, '');
        const bars = [];

        for (const char of encoded) {
            const charCode = char.charCodeAt(0);
            for (let bit = 0; bit < 7; bit += 1) {
                bars.push((charCode >> bit) & 1 ? 2 : 1);
            }
            bars.push(1);
        }

        const totalUnits = bars.reduce((acc, value) => acc + value, 0) || 1;
        const unitWidth = width / totalUnits;
        let currentX = x;

        pdf.setDrawColor(30, 30, 30);
        pdf.rect(x - 1.5, y - 1.5, width + 3, height + 3);

        pdf.setFillColor(25, 25, 25);
        for (let i = 0; i < bars.length; i += 1) {
            const barWidth = bars[i] * unitWidth;

            if (i % 2 === 0) {
                pdf.rect(currentX, y, barWidth, height, 'F');
            }

            currentX += barWidth;
        }
    }

    async function generateShippingSlip(order) {
        if (import.meta.server) return;

        try {
            generatedOrderId.value = order.id;

            const { jsPDF } = await import('jspdf');
            const pdf = new jsPDF({ unit: 'mm', format: 'a4' });

            const marginX = 15;
            let currentY = 18;
            const lineHeight = 6;
            const slipReference = getShippingSlipReference(order);

            drawFakeBarcode(pdf, slipReference, 130, 14, 65, 16);
            pdf.setFont('helvetica', 'normal');
            pdf.setFontSize(8);
            pdf.text(slipReference, 130, 33);

            pdf.setFont('helvetica', 'bold');
            pdf.setFontSize(18);
            pdf.text("Bordereau d'envoi", marginX, currentY);

            currentY += 9;
            pdf.setFont('helvetica', 'normal');
            pdf.setFontSize(11);
            pdf.text(`Commande #${order.id}`, marginX, currentY);
            currentY += lineHeight;
            pdf.text(`Date de commande : ${formatDate(order.order_date)}`, marginX, currentY);

            currentY += 10;
            pdf.setFont('helvetica', 'bold');
            pdf.text('Expediteur', marginX, currentY);
            currentY += lineHeight;
            pdf.setFont('helvetica', 'normal');
            pdf.text(shipperName, marginX, currentY);
            currentY += lineHeight;

            const shipperAddressLines = pdf.splitTextToSize(shipperAddress, 90);
            for (const line of shipperAddressLines) {
                pdf.text(line, marginX, currentY);
                currentY += lineHeight;
            }

            if (shipperPhone) {
                pdf.text(`Tel : ${shipperPhone}`, marginX, currentY);
                currentY += lineHeight;
            }

            if (shipperEmail) {
                pdf.text(`Email : ${shipperEmail}`, marginX, currentY);
                currentY += lineHeight;
            }

            currentY += 10;
            pdf.setFont('helvetica', 'bold');
            pdf.text('Destinataire', marginX, currentY);
            currentY += lineHeight;
            pdf.setFont('helvetica', 'normal');
            pdf.text(getCustomerFullName(order), marginX, currentY);

            const addressLines = getShippingAddressLines(order);
            for (const line of addressLines) {
                currentY += lineHeight;
                pdf.text(line, marginX, currentY);
            }

            currentY += 12;
            pdf.setFont('helvetica', 'bold');
            pdf.text('Articles a preparer', marginX, currentY);
            currentY += 4;
            pdf.line(marginX, currentY, 195, currentY);

            currentY += 8;
            pdf.setFont('helvetica', 'normal');
            for (const item of order.items || []) {
                const quantity = Number(item.quantity || 0);
                const itemLine = `${quantity} x ${item.name || 'Article sans nom'}`;
                const wrappedLines = pdf.splitTextToSize(itemLine, 170);

                for (const wrappedLine of wrappedLines) {
                    if (currentY > 270) {
                        pdf.addPage();
                        currentY = 20;
                    }
                    pdf.text(wrappedLine, marginX, currentY);
                    currentY += lineHeight;
                }
            }

            currentY += 4;
            pdf.line(marginX, currentY, 195, currentY);
            currentY += 8;
            pdf.setFont('helvetica', 'bold');
            const totalValue = Number(order.total || 0).toFixed(2);
            pdf.text(`Total commande : ${totalValue} EUR`, marginX, currentY);

            const orderDate = new Date(order.order_date);
            const safeDate = Number.isNaN(orderDate.getTime()) ? 'date-inconnue' : orderDate.toISOString().slice(0, 10);
            pdf.save(`bordereau-commande-${order.id}-${safeDate}.pdf`);
        } catch (error) {
            console.error('Erreur lors de la génération du bordereau PDF:', error);
        } finally {
            generatedOrderId.value = null;
        }
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
