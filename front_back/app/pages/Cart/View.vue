<template>
    <v-alert
        v-if="passOrder"
        type="warning"
        variant="tonal"
        density="compact"
        class="added-alert"
        style="position: absolute; top: 80px; right: 24px; width: auto; min-width: 260px; max-width: 380px; z-index: 100"
    >
        Connectez-vous avant de passer votre commande.
    </v-alert>

    <div class="pa-8">
        <div class="mb-4">
            <v-btn variant="text" prepend-icon="mdi-arrow-left" @click="goBack">Retour</v-btn>
        </div>

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
                            <div class="d-flex align-center ga-3 mt-1 mb-1">
                                <v-icon class="bin" size="25" color="red" @click="removeItem(item)">mdi-delete-circle</v-icon>
                                <img :src="item.image" :alt="item.name" style="width: 60px; height: 60px; object-fit: cover; border-radius: 4px" />
                                <div>
                                    <p class="font-weight-medium">{{ item.name }}</p>
                                </div>
                            </div>
                        </td>
                        <td class="text-center">{{ item.size }}</td>
                        <td class="text-center">
                            <v-icon class="bin" size="25" color="grey" @click="decreaseQuantity(item)">mdi-minus-circle</v-icon>
                            {{ item.quantity }}
                            <v-icon class="bin" size="25" color="grey" @click="increaseQuantity(item)">mdi-plus-circle</v-icon>
                        </td>
                        <td class="text-right">{{ item.price }} €</td>
                    </tr>
                </tbody>
            </v-table>

            <div class="d-flex justify-end mt-4" style="gap: 2rem; align-items: center">
                <p class="text-h6">Total : {{ total }} €</p>
                <v-btn color="primary" @click="handleOrder">Commander</v-btn>
            </div>
        </div>

        <p v-else>Votre panier est vide.</p>
    </div>
</template>

<script setup>
    useHead({
        title: 'Panier | MakeUrStore',
    });

    const cartItems = ref([]);
    const cartValuesLocalStorage = ref([]);

    const passOrder = ref(false);

    const goBack = async () => {
        if (typeof window !== 'undefined' && window.history.length > 1) {
            window.history.back();
            return;
        }

        await navigateTo('/');
    };

    onMounted(() => {
        if (typeof window === 'undefined') return;

        const raw = window.localStorage.getItem('cart');
        try {
            const parsed = raw ? JSON.parse(raw) : [];
            cartValuesLocalStorage.value = Array.isArray(parsed) ? parsed : [];
            cartItems.value = groupCartItems(cartValuesLocalStorage.value);
            console.log(cartItems.value);
        } catch (e) {
            cartValuesLocalStorage.value = [];
            cartItems.value = [];
        }
    });

    const total = computed(() => {
        return cartItems.value.reduce((sum, item) => sum + item.price * item.quantity, 0).toFixed(2);
    });

    const groupCartItems = (items) => {
        const result = [];
        for (const item of items) {
            const idx = result.findIndex((i) => i.productId === item.productId && i.size === item.size && i.price === item.price);
            if (idx === -1) {
                result.push({ ...item });
            } else {
                result[idx].quantity += item.quantity ?? 1;
            }
        }
        return result;
    };

    const syncCart = () => {
        if (typeof window === 'undefined') return;
        window.localStorage.setItem('cart', JSON.stringify(cartValuesLocalStorage.value));
        cartItems.value = groupCartItems(cartValuesLocalStorage.value);
    };

    const increaseQuantity = (item) => {
        cartValuesLocalStorage.value.push({ ...item, quantity: 1 });
        syncCart();
    };

    const decreaseQuantity = (item) => {
        const idx = cartValuesLocalStorage.value.findIndex((i) => i.productId === item.productId && i.size === item.size && i.price === item.price);
        if (idx !== -1) {
            cartValuesLocalStorage.value.splice(idx, 1);
            syncCart();
        }
    };

    const removeItem = (item) => {
        cartValuesLocalStorage.value = cartValuesLocalStorage.value.filter((i) => !(i.productId === item.productId && i.size === item.size && i.price === item.price));
        syncCart();
    };

    // Gestion du bouton Commander
    const handleOrder = () => {
        // On suppose que l'info de connexion est dans localStorage.user (à adapter si besoin)
        let isLogged = false;
        try {
            const user = typeof window !== 'undefined' ? JSON.parse(window.localStorage.getItem('user')) : null;
            isLogged = !!user && !!user.id;
        } catch (e) {
            isLogged = false;
        }
        if (isLogged) {
            // Redirige vers la page de commande
            window.location.href = '/Cart/Order';
        } else {
            passOrder.value = true;
            setTimeout(() => {
                passOrder.value = false;
            }, 2000);
        }
    };
</script>
