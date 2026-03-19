<template>
    <v-container>
        <h1 class="my-12 text-center">Connectez-vous à votre compte</h1>

        <v-row justify="center">
            <v-col cols="12" md="5">
                <v-card class="pa-6 border-accent" rounded="lg">
                    <v-form @submit.prevent="login">
                        <v-text-field v-model="email" label="E-mail" type="email" required />
                        <v-text-field v-model="password" label="Mot de passe" type="password" required />

                        <div class="d-flex justify-center">
                            <v-btn type="submit" color="primary" class="mt-4 categories">Me connecter</v-btn>
                        </div>
                    </v-form>
                </v-card>
            </v-col>

            <v-col cols="12" md="5">
                <v-card class="pa-6 border-accent" rounded="lg">
                    <div class="text-center mb-4">Vous n'avez pas encore de compte ?</div>

                    <div class="d-flex justify-center">
                        <v-btn color="primary" class="mt-4 categories">Créer mon compte</v-btn>
                    </div>
                </v-card>
            </v-col>
        </v-row>
    </v-container>
</template>

<script setup>
    // État global réactif pour l'utilisateur
    const user = useState('user', () => null);

    const email = ref('');
    const password = ref('');

    const login = async () => {
        const res = await $fetch('/api/login/login', {
            method: 'POST',
            body: { email: email.value, password: password.value },
        });

        if (res.success) {
            user.value = res.user;

            localStorage.setItem('user', JSON.stringify(res.user));

            alert('Connexion réussie');
            navigateTo('/User/Profile');
        } else {
            alert('Identifiants incorrects');
        }
    };
</script>
