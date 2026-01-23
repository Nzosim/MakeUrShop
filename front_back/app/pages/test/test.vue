<template>
    <v-container>
        <v-card>
            <v-card-title>Liste des tests</v-card-title>

            <v-list>
                <v-list-item v-for="test in tests" :key="test.id">{{ test.id }} - {{ test.nom }}</v-list-item>
            </v-list>
        </v-card>
    </v-container>
</template>

<script setup>
    const { data: tests } = await useFetch('/api/test/test');
    console.log(tests);
</script>
