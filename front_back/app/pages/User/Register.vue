<template>
    <v-container>
        <h1 class="my-12 text-center">Créer un compte</h1>

        <v-row justify="center">
            <v-col cols="12" md="6">
                <v-card class="pa-6 border-accent" rounded="lg">
                    <v-form @submit.prevent="register">
                        <v-text-field v-model="lastName" label="Nom" :rules="rules.required" counter="30" required />
                        <v-text-field v-model="firstName" label="Prénom" :rules="rules.required" counter="30" required />

                        <v-text-field v-model="phoneNumber" label="Téléphone" :rules="rules.phone" />
                        <v-text-field v-model="email" label="E-mail" type="email" :rules="rules.email" counter="50" required />

                        <v-text-field v-model="password" label="Mot de passe" type="password" :rules="rules.password" counter="32" required />
                        <v-text-field v-model="confirmPassword" label="Confirmation du mot de passe" type="password" :rules="rules.confirm" required />

                        <v-alert v-if="errorMsg" type="error" variant="tonal" class="mb-4 mt-2" closable @click:close="errorMsg = ''">
                            {{ errorMsg }}
                        </v-alert>

                        <div class="d-flex justify-center mt-6">
                            <v-btn type="submit" color="primary" class="px-10" :loading="loading">Créer mon compte</v-btn>
                        </div>
                    </v-form>
                </v-card>
            </v-col>
        </v-row>
    </v-container>
</template>

<script setup>
    const user = useState('user', () => null);

    // Champs du formulaire
    const lastName = ref('');
    const firstName = ref('');
    const phoneNumber = ref('');
    const email = ref('');
    const password = ref('');
    const confirmPassword = ref('');

    // États de l'interface
    const errorMsg = ref('');
    const loading = ref(false);

    const sanitize = (val) => {
        if (!val) return '';
        return val
            .toString()
            .replace(/[{}<>\[\]"']/g, '')
            .trim();
    };

    const rules = {
        required: [(v) => !!v || 'Requis', (v) => (v && v.length <= 30) || 'Max 30 car.'],
        email: [(v) => !!v || 'Requis', (v) => /.+@.+\..+/.test(v) || 'E-mail non valide'],
        phone: [(v) => !v || /^[0-9+ ]{10,15}$/.test(v) || 'Numéro non valide'],
        password: [(v) => !!v || 'Requis', (v) => v.length >= 8 || '8 caractères minimum'],
        confirm: [(v) => !!v || 'Requis', (v) => v === password.value || 'Les mots de passe diffèrent'],
    };

    const register = async () => {
        // Reset de l'alerte
        errorMsg.value = '';
        loading.value = true;

        const payload = {
            lastName: sanitize(lastName.value),
            firstName: sanitize(firstName.value),
            phoneNumber: sanitize(phoneNumber.value),
            email: sanitize(email.value).toLowerCase(),
            password: sanitize(password.value),
        };

        try {
            const res = await $fetch('/api/register/register', {
                method: 'POST',
                body: payload,
            });

            if (res.success) {
                user.value = res.user;
                localStorage.setItem('user', JSON.stringify(res.user));
                navigateTo('/User/Profile');
            } else {
                // On affiche le message d'erreur spécifique renvoyé par le serveur
                errorMsg.value = res.message || "Échec de l'inscription";
            }
        } catch (error) {
            errorMsg.value = 'Erreur de connexion au serveur.';
        } finally {
            loading.value = false;
        }
    };
</script>
