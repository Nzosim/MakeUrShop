<template>
    <v-navigation-drawer permanent>
        <v-list>
            <v-list-item class="d-flex justify-center">
                <div class="logo-text">MAKEURSHOP</div>
            </v-list-item>
        </v-list>
        <v-list density="compact" nav active-color="primary">
            <v-list-item prepend-icon="mdi-home" title="Accueil" value="prout" href="/dashboard/main"></v-list-item>
            <v-list-item prepend-icon="mdi-cart" title="Commandes" value="prout2" href="/dashboard/order"></v-list-item>
            <v-list-item prepend-icon="mdi-tag" title="Produits" value="myfiles" href="/dashboard/article"></v-list-item>
            <v-list-item prepend-icon="mdi-face-man-profile" title="Clients" value="shared" href="/dashboard/accounts"></v-list-item>
            <v-list-item prepend-icon="mdi-poll" title="Statistiques" value="starred" href="/dashboard/stats"></v-list-item>
            <v-list-item prepend-icon="mdi-text-shadow" title="Configuration" value="starred" href="/dashboard/configuration"></v-list-item>
        </v-list>

        <v-list style="position: absolute; bottom: 10px; width: 100%">
            <v-divider></v-divider>
            <v-list-item
                prepend-avatar="https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQN0p9Jer0iBCVzxQGUsNyXAgk_osWJU8arSw&s"
                subtitle="Administrateur"
                title="Enzo Simonin"
            ></v-list-item>
        </v-list>
    </v-navigation-drawer>
</template>

<style>
    @import url('https://fonts.googleapis.com/css2?family=Poppins:wght@600&display=swap');

    .logo-text {
        font-family: 'Poppins', sans-serif;
        font-size: 24px;
        font-weight: 600;
        white-space: nowrap;
        overflow: hidden;
        letter-spacing: 1px;
    }
</style>
