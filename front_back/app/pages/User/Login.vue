<template>
    <v-container>
        <h1 class="my-12 text-center">Connectez-vous à votre compte</h1>

        <v-row justify="center" align="stretch">
            <v-col cols="12" md="5">
                <v-card class="pa-6 border-accent h-100" rounded="lg">
                    <h2 class="text-h5 mb-6 text-center">Connectez-vous</h2>
                    <v-form @submit.prevent="login">
                        <v-text-field v-model="email" label="E-mail" type="email" :rules="rules.email" counter="50" required />
                        <v-text-field v-model="password" label="Mot de passe" type="password" :rules="rules.password" counter="32" required />
                        <v-alert v-if="showAlert" type="error" class="mb-4">Identifiants incorrects</v-alert>
                        <div class="d-flex justify-center">
                            <v-btn type="submit" color="primary" class="mt-4 px-8 categories">Connexion</v-btn>
                        </div>
                        <div class="d-flex justify-center mt-4">
                            <h4><a href="/User/Forgot-password">Mot de passe oublié ?</a></h4>
                        </div>
                    </v-form>
                </v-card>
            </v-col>

            <v-col cols="12" md="5">
                <v-card class="pa-6 border-accent h-100 d-flex flex-column justify-center align-center" rounded="lg">
                    <div class="text-h6 text-center mb-4">Nouveau ici ?</div>
                    <p class="text-center mb-6">Créez un compte pour accéder à toutes nos fonctionnalités.</p>

                    <v-btn color="primary" variant="flat" class="px-8 categories" href="/User/Register">Créer un compte</v-btn>
                </v-card>
            </v-col>
        </v-row>
    </v-container>
</template>

<script setup>
    const user = useState('user', () => null);
    const email = ref('');
    const password = ref('');
    const showAlert = ref(false);

    const sanitizeInput = (val) => {
        if (!val) return '';
        return val.replace(/[{}<>\[\]"']/g, '').trim();
    };

    const rules = {
        email: [(v) => !!v || 'E-mail requis', (v) => v.length <= 50 || 'Maximum 50 caractères', (v) => /.+@.+\..+/.test(v) || 'E-mail non valide'],
        password: [(v) => !!v || 'Mot de passe requis', (v) => v.length <= 32 || 'Maximum 32 caractères'],
    };

    const login = async () => {
        const cleanEmail = sanitizeInput(email.value);
        const cleanPassword = sanitizeInput(password.value);

        try {
            const res = await $fetch('/api/login/login', {
                method: 'POST',
                body: { email: cleanEmail, password: cleanPassword },
            });

            if (res.success) {
                user.value = res.user;
                localStorage.setItem('user', JSON.stringify(res.user));
                navigateTo('/User/Profile');
            } else {
                showAlert.value = true;
            }
        } catch (error) {
            alert('Une erreur est survenue lors de la connexion');
        }
    };
</script>
