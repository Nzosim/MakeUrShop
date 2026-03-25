<template>
    <div>
        <h1>Nouveau mot de passe</h1>
        <v-text-field v-model="password" type="password" label="Nouveau mot de passe" />
        <v-btn :loading="isSubmitting" :disabled="isSubmitting" @click="submit">Changer</v-btn>
        <p v-if="successMessage">{{ successMessage }}</p>
        <p v-if="errorMessage">{{ errorMessage }}</p>
    </div>
</template>

<script setup>
    const route = useRoute();
    const password = ref('');
    const isSubmitting = ref(false);
    const successMessage = ref('');
    const errorMessage = ref('');

    const submit = async () => {
        successMessage.value = '';
        errorMessage.value = '';

        if (!route.query.token) {
            errorMessage.value = 'Token manquant dans le lien.';
            return;
        }

        if (!password.value) {
            errorMessage.value = 'Veuillez renseigner un nouveau mot de passe.';
            return;
        }

        isSubmitting.value = true;

        try {
            const response = await $fetch('/api/password-reset/reset-password', {
                method: 'POST',
                body: {
                    token: route.query.token,
                    password: password.value,
                },
            });

            successMessage.value = response?.message || 'Mot de passe changé.';
        } catch (error) {
            errorMessage.value = error?.data?.statusMessage || error?.data?.message || 'Une erreur est survenue.';
        } finally {
            isSubmitting.value = false;
        }
    };
</script>
