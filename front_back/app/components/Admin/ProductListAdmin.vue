<script setup>

    const props = defineProps({
        products: Array,
    })
</script>

<template>
    <v-table theme="dark">
        <thead>
        <tr>
            <th class="text-left">Nom du produit</th>
            <th class="text-left">Id stock</th>
            <th class="text-left">Date de publication</th>
            <th class="text-left">Stock</th>
            <th class="text-left">Price</th>
        </tr>
        </thead>

        <tbody>
        <tr
            v-for="item in products"
            :key="item.product_name"
        >
            <td>{{ item.product_name }}</td>
            <td>{{ item.product_id}}</td>
            <td>{{ item.creation_date}}</td>
            <td>{{ item.stock_number}}</td>
            <td>{{ item.price }}</td>
        </tr>
        </tbody>
    </v-table>
</template>
