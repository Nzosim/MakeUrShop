<template>
    <section class="result-page">
        <div class="result-card">
            <v-alert type="success" variant="tonal" density="comfortable" class="mb-5">Paiement validé</v-alert>

            <h1 class="mb-3">Merci pour votre commande</h1>
            <p class="mb-6 result-text">Vous allez recevoir un email de confirmation d'ici quelques instants.</p>

            <div class="result-actions">
                <v-btn color="primary" @click="navigateTo('/')">Retour a l'accueil</v-btn>
            </div>
        </div>
    </section>
</template>

<script setup>
    useHead({
        title: 'Confirmation de paiement | MakeUrStore',
    });

    onMounted(() => {
        if (typeof window === 'undefined') {
            return;
        }

        window.localStorage.removeItem('cart');
    });
</script>
