function normalizeStripeSecretKey(rawKey = '') {
    const key = String(rawKey).trim();

    if (key.includes('pk_test_') || key.includes('pk_live_')) {
        return '';
    }

    if (!(key.startsWith('sk_test_') || key.startsWith('sk_live_'))) {
        return '';
    }

    return key;
}

export default defineEventHandler(async (event) => {
    const runtimeConfig = useRuntimeConfig(event);
    const body = await readBody(event);

    const amount = Number(body?.amount || 0);
    const currency = String(body?.currency || 'eur').toLowerCase();
    const paymentMethodTypes = Array.isArray(body?.paymentMethodTypes) && body.paymentMethodTypes.length ? body.paymentMethodTypes : ['card', 'paypal', 'klarna'];

    if (!Number.isFinite(amount) || amount <= 0) {
        throw createError({
            statusCode: 400,
            statusMessage: 'Montant invalide pour la creation du paiement.',
        });
    }

    const stripeSecretKey = normalizeStripeSecretKey(runtimeConfig.stripeSecretKey || process.env.NUXT_STRIPE_SECRET_KEY || process.env.STRIPE_SECRET_KEY || '');
    if (!stripeSecretKey) {
        throw createError({
            statusCode: 500,
            statusMessage: 'Cle Stripe secrete manquante ou invalide',
        });
    }

    const params = new URLSearchParams();
    params.set('amount', String(Math.round(amount)));
    params.set('currency', currency);

    paymentMethodTypes.forEach((method, index) => {
        params.set(`payment_method_types[${index}]`, method);
    });

    const response = await fetch('https://api.stripe.com/v1/payment_intents', {
        method: 'POST',
        headers: {
            Authorization: `Bearer ${stripeSecretKey}`,
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: params,
    });

    const data = await response.json();

    if (!response.ok) {
        const stripeMessage = data?.error?.message || 'Erreur Stripe inconnue.';
        throw createError({
            statusCode: response.status,
            statusMessage: stripeMessage,
        });
    }

    return {
        clientSecret: data.client_secret,
        paymentIntentId: data.id,
    };
});
