<script setup>
    import ProfileInfos from '~/components/Profile/ProfileInfos.vue';

    const accountEdited = ref(false);
    const user = useState('user');

    const currentTab = ref('infos');

    watch(
        user,
        (val) => {
            if (!val) navigateTo('/User/Login');
        },
        { immediate: true }
    );

    watch(accountEdited, (val) => {
        if (val) {
            setTimeout(() => {
                accountEdited.value = false;
            }, 3000);
        }
    });

    const logout = () => {
        user.value = null;
        localStorage.removeItem('user');
        navigateTo('/User/Login');
    };
</script>

<template>
    <v-container>
        <v-scale-transition origin="top right">
            <v-alert
                v-if="accountEdited"
                type="success"
                variant="tonal"
                density="compact"
                class="added-alert"
                style="position: absolute; top: 80px; right: 24px; width: auto; min-width: 260px; max-width: 380px; z-index: 100"
            >
                Informations modifiées.
            </v-alert>
        </v-scale-transition>
        <h1 class="my-12">Mon compte</h1>

        <v-row v-if="user">
            <!-- MENU -->
            <v-col cols="12" md="4">
                <v-list class="bg-transparent">
                    <v-list-item prepend-icon="mdi-account-circle" title="Informations du compte" :active="currentTab === 'infos'" @click="currentTab = 'infos'" />

                    <v-list-item prepend-icon="mdi-history" title="Historique de commandes" :active="currentTab === 'orders'" @click="currentTab = 'orders'" />

                    <v-list-item prepend-icon="mdi-logout" title="Se déconnecter" class="text-error mt-4" @click="logout" />
                </v-list>
            </v-col>

            <!-- CONTENU DROITE -->
            <v-col cols="12" md="8">
                <profile-infos v-if="currentTab === 'infos'" :user="user" @updated="accountEdited = true" />
                <profile-orders v-if="currentTab === 'orders'" />
            </v-col>
        </v-row>
    </v-container>
</template>
