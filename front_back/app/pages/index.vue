<template>
    <v-btn icon @click="theme.toggle()">
        <v-icon>
            {{ theme.global.name.value === 'light' ? 'mdi-weather-night' : 'mdi-white-balance-sunny' }}
        </v-icon>
    </v-btn>

    Test
    <v-btn color="primary" to="/test/test">Go test page</v-btn>
</template>

<script setup>
    import { useTheme } from 'vuetify';
    const theme = useTheme();
</script>
