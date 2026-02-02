<script setup>

    const props = defineProps({
        products: Array,
    })
</script>

<template>
    <v-table theme="dark">
        <thead>
        <tr>
            <th class="text-left">Nom</th>
            <th class="text-left">Stock</th>
        </tr>
        </thead>

        <tbody>
        <tr
            v-for="item in products"
            :key="item.product_name"
        >
            <td>{{ item.product_name }}</td>
            <td>{{ item.stock_number }}</td>
        </tr>
        </tbody>
    </v-table>
</template>
