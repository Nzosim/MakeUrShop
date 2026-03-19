<template>
    <div class="pa-8">
        <h1 class="mb-6">Panier</h1>

        <div v-if="cartItems.length">
            <v-table>
                <thead>
                    <tr>
                        <th>Article</th>
                        <th class="text-center">Taille</th>
                        <th class="text-center">Quantité</th>
                        <th class="text-right">Prix</th>
                    </tr>
                </thead>
                <tbody>
                    <tr v-for="(item, index) in cartItems" :key="index">
                        <td>
                            <div class="d-flex align-center ga-3">
                                <img :src="item.image" :alt="item.name" style="width: 60px; height: 60px; object-fit: cover; border-radius: 4px" />
                                <div>
                                    <p class="font-weight-medium">{{ item.name }}</p>
                                    <p class="text-caption text-grey">ID: {{ item.productId }}</p>
                                </div>
                            </div>
                        </td>
                        <td class="text-center">{{ item.size }}</td>
                        <td class="text-center">{{ item.quantity }}</td>
                        <td class="text-right">{{ item.price }} €</td>
                    </tr>
                </tbody>
            </v-table>

            <div class="d-flex justify-end mt-4">
                <p class="text-h6">Total : {{ total }} €</p>
            </div>
        </div>

        <p v-else>Votre panier est vide.</p>
    </div>
</template>

<script setup>
    const cartItems = ref([]);

    onMounted(() => {
        if (typeof window === 'undefined') return;

        const raw = window.localStorage.getItem('cart');
        try {
            const parsed = raw ? JSON.parse(raw) : [];
            cartItems.value = groupCartItems(parsed);
        } catch (e) {
            cartItems.value = [];
        }
    });

    const total = computed(() => {
        return cartItems.value.reduce((sum, item) => sum + item.price * item.quantity, 0).toFixed(2);
    });

    const groupCartItems = (items) => {
        const groups = {};

        for (const item of items) {
            const key = `${item.productId}-${item.size}-${item.price}`;

            if (!groups[key]) {
                groups[key] = { ...item };
            } else {
                groups[key].quantity += item.quantity ?? 1;
            }
        }

        return Object.values(groups);
    };
</script>
