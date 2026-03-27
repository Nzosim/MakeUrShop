<template>
    <v-container>
        <v-col justify="center" align="center">
            <h1>Réinitialisation du mot de passe</h1>

            <v-text-field v-model="email" type="email" label="Email" placeholder="Email" />

            <v-btn class="categories" color="primary" :loading="isSubmitting" :disabled="isSubmitting" @click="submit">Envoyer</v-btn>

            <!-- Succès -->
            <v-scale-transition origin="top right">
                <v-alert
                    v-if="successMessage"
                    type="success"
                    variant="tonal"
                    density="compact"
                    class="added-alert"
                    style="position: absolute; top: 100px; right: 24px; width: auto; min-width: 260px; max-width: 380px; z-index: 100"
                >
                    {{ successMessage }}
                </v-alert>
            </v-scale-transition>

            <!-- Erreur -->
            <v-scale-transition origin="top right">
                <v-alert
                    v-if="errorMessage"
                    type="error"
                    variant="tonal"
                    density="compact"
                    class="added-alert"
                    style="position: absolute; top: 100px; right: 24px; width: auto; min-width: 260px; max-width: 380px; z-index: 100"
                >
                    {{ errorMessage }}
                </v-alert>
            </v-scale-transition>

            <!-- Pour debug (optionnel) -->
            <!-- <a v-if="debugResetLink" :href="debugResetLink">Ouvrir le lien de réinitialisation</a> -->
        </v-col>
    </v-container>
</template>

<script setup>
    import { ref } from 'vue';

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
