<template>
    <v-container>
        <div>
            <v-col justify="center" align="center">
                <h1>Réinitialisation du mot de passe</h1>
                <v-text-field v-model="email" type="email" label="Email" placeholder="Email" />
                <v-btn class="categories" color="primary" :loading="isSubmitting" :disabled="isSubmitting" @click="submit">Envoyer</v-btn>
                <p v-if="successMessage">{{ successMessage }}</p>
                <p v-if="errorMessage">{{ errorMessage }}</p>
                <!-- <a v-if="debugResetLink" :href="debugResetLink">Ouvrir le lien de réinitialisation</a> -->
            </v-col>
        </div>
    </v-container>
</template>

<script setup>
    const email = ref('');
    const isSubmitting = ref(false);
    const successMessage = ref('');
    const errorMessage = ref('');
    const debugResetLink = ref('');

    const submit = async () => {
        successMessage.value = '';
        errorMessage.value = '';
        debugResetLink.value = '';

        if (!email.value) {
            errorMessage.value = 'Veuillez renseigner un email.';
            return;
        }

        isSubmitting.value = true;

        try {
            const response = await $fetch('/api/password-reset/forgot-password', {
                method: 'POST',
                body: { email: email.value },
            });

            if (response?.debug?.userFound === false) {
                errorMessage.value = 'Aucun compte trouvé avec cet email.';
            } else {
                successMessage.value = response?.message || 'Email envoyé.';
            }

            debugResetLink.value = response?.resetLink || '';
        } catch (error) {
            errorMessage.value = error?.data?.statusMessage || error?.data?.message || 'Une erreur est survenue.';
        } finally {
            isSubmitting.value = false;
        }
    };
</script>
