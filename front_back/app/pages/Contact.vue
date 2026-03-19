<template>
    <v-container>
        <v-col>
            <v-row justify="center" class="mt-12">
                <v-col cols="8" md="5">
                    <v-card class="pa-4 border-accent" rounded="lg">
                        <h2 class="text-center my-2">Nous retrouver</h2>

                        <div class="map-container">
                            <iframe
                                width="100%"
                                height="400"
                                style="border: 0; border-radius: 8px"
                                loading="lazy"
                                allowfullscreen
                                referrerpolicy="no-referrer-when-downgrade"
                                :src="googleMapsUrl"
                            ></iframe>
                        </div>

                        <p class="text-center mt-4 text-body-2">
                            <h4>{{ storeAddress }}  </h4>
                        </p>
                    </v-card>
                </v-col>
                <v-col cols="3" md="4">
                    <v-card class="pa-4 border-accent" rounded="lg">
                        <h2 class="text-center my-2">Nous contacter</h2>

                        <p class="text-center mt-4 text-body-2">
                            <v-icon icon="mdi-email" color="primary" class="mr-1"></v-icon>
                            <a :href="`mailto:${storeEmail}`" class="text-decoration-none text-body-2">{{ storeEmail }}</a>
                        </p>
                        <p class="text-center mt-2 text-body-2">
                            <v-icon icon="mdi-phone" color="primary" class="mr-1"></v-icon>
                            <a :href="`tel:${storePhone}`" class="text-decoration-none text-body-2">{{ storePhone }}</a>
                        </p>
                    </v-card>
                </v-col>
            </v-row>
        </v-col>
    </v-container>
</template>

<script setup>
    import configData from '@/assets/config.json';
    const storeAddress = configData.config.info.storeAddress;
    const storeAddressName = configData.config.info.storeAddressName;
    const storeEmail = configData.config.info.storeEmail;
    const storePhone = configData.config.info.storePhone;

    const googleMapsUrl = computed(() => {
        const query = encodeURIComponent(storeAddressName);
        return `https://maps.google.com/maps?q=${query}&t=&z=15&ie=UTF8&iwloc=&output=embed`;
    });
</script>

<style scoped>
    .map-container {
        width: 100%;
        overflow: hidden;
    }
</style>
