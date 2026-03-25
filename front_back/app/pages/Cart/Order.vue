<template>
    <section class="checkout-page" :style="pageThemeVars">
        <div class="mb-4 checkout-back-wrap">
            <v-btn variant="text" prepend-icon="mdi-arrow-left" @click="goBack">Retour</v-btn>
        </div>

        <div class="bg-shape bg-shape-a"></div>
        <div class="bg-shape bg-shape-b"></div>

        <div class="checkout-shell">
            <header class="checkout-header">
                <p class="eyebrow">MakeUrShop</p>
                <h1>Paiement securisé</h1>
                <p class="subtitle">Finalisez votre commande en moins d'une minute.</p>
            </header>

            <main class="checkout-grid">
                <section class="panel panel-form">
                    <div class="panel-head">
                        <h2>Informations client</h2>
                    </div>

                    <div class="form-grid">
                        <label class="field" :class="{ 'field-invalid': hasFieldError('firstName') }">
                            <span>Prenom</span>
                            <input v-model="customer.firstName" type="text" placeholder="Joan" />
                        </label>
                        <label class="field" :class="{ 'field-invalid': hasFieldError('lastName') }">
                            <span>Nom</span>
                            <input v-model="customer.lastName" type="text" placeholder="Rodriguez" />
                        </label>
                        <label class="field field-full" :class="{ 'field-invalid': hasFieldError('email') }">
                            <span>Email</span>
                            <input v-model="customer.email" type="email" placeholder="joan@rodriguez.com" />
                        </label>
                        <label class="field" :class="{ 'field-invalid': hasFieldError('phone') }">
                            <span>Telephone</span>
                            <input v-model="customer.phone" type="tel" placeholder="06 00 00 00 00" />
                        </label>
                        <label class="field" :class="{ 'field-invalid': hasFieldError('postalCode') }">
                            <span>Code postal</span>
                            <input v-model="customer.postalCode" type="text" placeholder="75000" />
                        </label>
                        <label class="field" :class="{ 'field-invalid': hasFieldError('city') }">
                            <span>Commune</span>
                            <input v-model="customer.city" type="text" placeholder="Paris" />
                        </label>
                        <label class="field field-full" :class="{ 'field-invalid': hasFieldError('address') }">
                            <span>Adresse</span>
                            <input v-model="customer.address" type="text" placeholder="12 rue du Commerce" />
                        </label>
                    </div>

                    <div class="panel-head payment-head">
                        <h2>Livraison</h2>
                    </div>

                    <div class="delivery-box">
                        <label class="field field-full">
                            <span>Mode de livraison</span>
                            <select v-model="delivery.method">
                                <option v-for="option in deliveryOptions" :key="option.id" :value="option.id">{{ option.label }} - {{ formatPrice(option.price) }}</option>
                            </select>
                        </label>

                        <p class="delivery-estimate">Estimation: {{ selectedDeliveryLabel }}</p>

                        <label class="consent-row mb-2">
                            <input class="mt-1" v-model="delivery.sameAsCustomerAddress" type="checkbox" />
                            <span>Utiliser la meme adresse que les informations client</span>
                        </label>

                        <div class="form-grid" v-if="!delivery.sameAsCustomerAddress && !isRelayDelivery">
                            <label class="field field-full" :class="{ 'field-invalid': hasFieldError('deliveryAddress') }">
                                <span>Adresse de livraison</span>
                                <input v-model="delivery.address" type="text" placeholder="48 avenue des Fleurs" />
                            </label>
                            <label class="field" :class="{ 'field-invalid': hasFieldError('deliveryPostalCode') }">
                                <span>Code postal livraison</span>
                                <input v-model="delivery.postalCode" type="text" placeholder="69002" />
                            </label>
                            <label class="field" :class="{ 'field-invalid': hasFieldError('deliveryCity') }">
                                <span>Commune livraison</span>
                                <input v-model="delivery.city" type="text" placeholder="Lyon" />
                            </label>
                        </div>

                        <label class="field field-full" :class="{ 'field-invalid': hasFieldError('relayPoint') }" v-if="isRelayDelivery">
                            <span>Point relais</span>
                            <input v-model="delivery.relayPoint" type="text" placeholder="Relay - 14 rue Victor Hugo" />
                        </label>

                        <label class="field field-full">
                            <span>Instructions pour le livreur (optionnel)</span>
                            <textarea v-model="delivery.instructions" rows="2" maxlength="180" placeholder="Code portail, etage, digicode..."></textarea>
                        </label>
                    </div>

                    <div class="panel-head payment-head">
                        <h2>Paiement</h2>
                    </div>

                    <div class="payment-zone">
                        <div id="payment-element"></div>
                        <p v-if="!stripeReady" class="hint">Chargement de l'interface de paiement...</p>
                    </div>

                    <label class="consent-row" :class="{ 'consent-error': hasFieldError('termsAccepted') }">
                        <input class="mt-1" v-model="termsAccepted" type="checkbox" />
                        <span>J'accepte les conditions generales de vente.</span>
                    </label>

                    <button class="pay-btn" :disabled="isSubmitting || !stripeReady" @click="submitPayment">
                        <span v-if="!isSubmitting">Payer {{ totalLabel }}</span>
                        <span v-else>Traitement en cours...</span>
                    </button>

                    <p v-if="feedback" :class="['feedback', feedbackType]">{{ feedback }}</p>
                </section>

                <aside class="panel panel-summary">
                    <h2>Recapitulatif</h2>

                    <ul class="line-items">
                        <li v-for="item in cartItems" :key="`${item.productId}-${item.size}-${item.price}`">
                            <span>{{ item.name }} ({{ item.size }}) x{{ item.quantity }}</span>
                            <strong>{{ formatPrice(item.quantity * item.price) }}</strong>
                        </li>
                    </ul>

                    <div class="totals">
                        <p>
                            <span>Sous-total</span>
                            <strong>{{ formatPrice(subtotal) }}</strong>
                        </p>
                        <p>
                            <span>Livraison</span>
                            <strong>{{ formatPrice(shippingCost) }}</strong>
                        </p>
                        <p class="grand-total">
                            <span>Total</span>
                            <strong>{{ totalLabel }}</strong>
                        </p>
                    </div>

                    <p class="secure-note">Paiement chiffré via Stripe. Vos donnees bancaires ne transitent jamais par MakeUrShop.</p>
                </aside>
            </main>
        </div>
    </section>
</template>

<script setup>
    const customer = reactive({
        firstName: '',
        lastName: '',
        email: '',
        phone: '',
        address: '',
        postalCode: '',
        city: '',
    });

    const cartItems = ref([]);
    const deliveryOptions = [
        { id: 'home_standard', label: 'Domicile standard (3-5 jours)', price: 4.9 },
        { id: 'home_express', label: 'Domicile express (24-48h)', price: 9.9 },
        { id: 'relay', label: 'Point relais (2-4 jours)', price: 3.9 },
    ];
    const delivery = reactive({
        method: 'home_standard',
        sameAsCustomerAddress: true,
        address: '',
        postalCode: '',
        city: '',
        relayPoint: '',
        instructions: '',
    });

    const feedback = ref('');
    const feedbackType = ref('info');
    const hasSubmitAttempt = ref(false);
    const termsAccepted = ref(false);
    const isSubmitting = ref(false);
    const stripeReady = ref(false);
    const paymentElementComplete = ref(false);

    const stripeRef = ref(null);
    const elementsRef = ref(null);
    const clientSecretRef = ref('');
    const paymentElementRef = ref(null);
    const isInitializingStripe = ref(false);
    const theme = useTheme();
    const runtimeConfig = useRuntimeConfig();
    const stripePublishableKey = computed(() => runtimeConfig.public.stripePublishableKey || '');

    const subtotal = computed(() => cartItems.value.reduce((sum, item) => sum + Number(item.price) * Number(item.quantity), 0));
    const selectedDelivery = computed(() => deliveryOptions.find((option) => option.id === delivery.method) || deliveryOptions[0]);
    const shippingCost = computed(() => Number(selectedDelivery.value.price));
    const isRelayDelivery = computed(() => delivery.method === 'relay');
    const selectedDeliveryLabel = computed(() => selectedDelivery.value.label);
    const shippingAddress = computed(() => {
        if (isRelayDelivery.value) {
            return {
                line1: delivery.relayPoint.trim(),
                postal_code: customer.postalCode.trim(),
                city: customer.city.trim(),
            };
        }

        if (delivery.sameAsCustomerAddress) {
            return {
                line1: customer.address.trim(),
                postal_code: customer.postalCode.trim(),
                city: customer.city.trim(),
            };
        }

        return {
            line1: delivery.address.trim(),
            postal_code: delivery.postalCode.trim(),
            city: delivery.city.trim(),
        };
    });
    const total = computed(() => subtotal.value + shippingCost.value);
    const totalLabel = computed(() => formatPrice(total.value));
    const stripePrimaryColor = computed(() => theme.global.current.value.colors.primary || theme.global.current.value.colors.secondary || '#000000');
    const stripeBackgroundColor = computed(() => theme.global.current.value.colors.surface || '#ffffff');
    const missingRequiredFields = computed(() => {
        const missing = [];

        if (!customer.firstName.trim()) missing.push('firstName');
        if (!customer.lastName.trim()) missing.push('lastName');
        if (!customer.email.trim()) missing.push('email');
        if (!customer.phone.trim()) missing.push('phone');
        if (!customer.postalCode.trim()) missing.push('postalCode');
        if (!customer.city.trim()) missing.push('city');
        if (!customer.address.trim()) missing.push('address');

        if (isRelayDelivery.value) {
            if (!delivery.relayPoint.trim()) missing.push('relayPoint');
        } else if (!delivery.sameAsCustomerAddress) {
            if (!delivery.address.trim()) missing.push('deliveryAddress');
            if (!delivery.postalCode.trim()) missing.push('deliveryPostalCode');
            if (!delivery.city.trim()) missing.push('deliveryCity');
        }

        if (!termsAccepted.value) missing.push('termsAccepted');

        return missing;
    });
    const pageThemeVars = computed(() => {
        const colors = theme.global.current.value.colors || {};
        const primary = colors.primary || '#A160A1';
        const secondary = colors.secondary || '#4C4D5F';
        const background = colors.background || '#E7E7E7';
        const surface = colors.surface || '#f7f7f7';
        const accent = colors.accent || primary;

        return {
            '--bg': background,
            '--panel': surface,
            '--ink': secondary,
            '--muted': `color-mix(in srgb, ${secondary} 70%, ${surface} 30%)`,
            '--brand': primary,
            '--brand-strong': `color-mix(in srgb, ${primary} 78%, black 22%)`,
            '--brand-soft': `color-mix(in srgb, ${primary} 18%, ${surface} 82%)`,
            '--line': `color-mix(in srgb, ${secondary} 16%, ${surface} 84%)`,
            '--focus-ring': `color-mix(in srgb, ${primary} 28%, transparent)`,
            '--success': colors.success || '#4CAF50',
            '--error': colors.error || '#FF5252',
            '--accent': accent,
        };
    });

    useHead({
        title: 'Paiement | MakeUrStore',
        link: [
            {
                rel: 'stylesheet',
                href: 'https://fonts.googleapis.com/css2?family=Space+Grotesk:wght@400;500;600;700&family=DM+Sans:wght@400;500;700&display=swap',
            },
        ],
        script: [{ src: 'https://js.stripe.com/clover/stripe.js', defer: true }],
    });

    function formatPrice(value) {
        return new Intl.NumberFormat('fr-FR', {
            style: 'currency',
            currency: 'EUR',
        }).format(value);
    }

    function isCustomerFormValid() {
        return Boolean(
            customer.firstName.trim() &&
            customer.lastName.trim() &&
            customer.email.trim() &&
            customer.phone.trim() &&
            customer.address.trim() &&
            customer.postalCode.trim() &&
            customer.city.trim()
        );
    }

    function hasFieldError(fieldName) {
        return hasSubmitAttempt.value && missingRequiredFields.value.includes(fieldName);
    }

    function isDeliveryValid() {
        if (isRelayDelivery.value) {
            return Boolean(delivery.relayPoint.trim());
        }

        if (delivery.sameAsCustomerAddress) {
            return true;
        }

        return Boolean(delivery.address.trim() && delivery.postalCode.trim() && delivery.city.trim());
    }

    function clearCartAfterPayment() {
        if (typeof window === 'undefined') {
            return;
        }

        window.localStorage.removeItem('cart');
        cartItems.value = [];
    }

    function groupCartItems(items) {
        const groups = {};

        for (const item of items) {
            const key = `${item.productId}-${item.size}-${item.price}`;

            if (!groups[key]) {
                groups[key] = {
                    ...item,
                    quantity: Number(item.quantity ?? 1),
                };
            } else {
                groups[key].quantity += Number(item.quantity ?? 1);
            }
        }

        return Object.values(groups);
    }

    function loadCartFromStorage() {
        if (typeof window === 'undefined') {
            return;
        }

        const raw = window.localStorage.getItem('cart');
        try {
            const parsed = raw ? JSON.parse(raw) : [];
            cartItems.value = groupCartItems(parsed);
        } catch {
            cartItems.value = [];
        }
    }

    async function waitForStripe(maxAttempts = 30) {
        for (let attempt = 0; attempt < maxAttempts; attempt += 1) {
            if (window.Stripe) {
                return true;
            }
            await new Promise((resolve) => setTimeout(resolve, 200));
        }
        return false;
    }

    async function createPaymentIntent() {
        const response = await $fetch('/api/stripe/create-payment-intent', {
            method: 'POST',
            body: {
                amount: Math.round(total.value * 100),
                currency: 'eur',
                paymentMethodTypes: ['card', 'paypal', 'klarna'],
            },
        });

        if (!response?.clientSecret) {
            throw new Error('Client secret Stripe manquant.');
        }

        return response.clientSecret;
    }

    async function initStripe() {
        if (isInitializingStripe.value) {
            return;
        }

        isInitializingStripe.value = true;
        const stripeAvailable = await waitForStripe();
        if (!stripeAvailable) {
            feedback.value = 'Impossible de charger Stripe pour le moment.';
            feedbackType.value = 'error';
            isInitializingStripe.value = false;
            return;
        }

        try {
            clientSecretRef.value = await createPaymentIntent();
        } catch (error) {
            feedback.value = error?.data?.statusMessage || error?.message || 'Impossible de preparer le paiement.';
            feedbackType.value = 'error';
            isInitializingStripe.value = false;
            return;
        }

        if (!stripePublishableKey.value) {
            feedback.value = 'NUXT_PUBLIC_STRIPE_PUBLISHABLE_KEY est manquante.';
            feedbackType.value = 'error';
            isInitializingStripe.value = false;
            return;
        }

        stripeRef.value = window.Stripe(stripePublishableKey.value);
        elementsRef.value = stripeRef.value.elements({
            clientSecret: clientSecretRef.value,
            appearance: {
                theme: 'flat',
                variables: {
                    colorPrimary: stripePrimaryColor.value,
                    colorBackground: stripeBackgroundColor.value,
                    borderRadius: '14px',
                    fontFamily: 'DM Sans, sans-serif',
                },
            },
        });

        if (paymentElementRef.value) {
            paymentElementRef.value.unmount();
        }

        paymentElementRef.value = elementsRef.value.create('payment', {
            layout: 'tabs',
            paymentMethodOrder: ['card', 'paypal', 'klarna'],
            wallets: {
                applePay: 'auto',
                googlePay: 'auto',
            },
        });

        paymentElementRef.value.mount('#payment-element');
        paymentElementRef.value.on('change', (event) => {
            paymentElementComplete.value = !!event.complete;
        });
        stripeReady.value = true;
        isInitializingStripe.value = false;
    }

    async function submitPayment() {
        feedback.value = '';
        hasSubmitAttempt.value = true;

        if (!cartItems.value.length || total.value <= 0) {
            feedback.value = 'Votre panier est vide. Ajoutez un article avant de payer.';
            feedbackType.value = 'error';
            return;
        }

        if (missingRequiredFields.value.length > 0) {
            feedback.value = 'Merci de renseigner tous les champs obligatoires.';
            feedbackType.value = 'error';
            return;
        }

        if (!isCustomerFormValid()) {
            feedback.value = 'Merci de renseigner tous les champs client.';
            feedbackType.value = 'error';
            return;
        }

        if (!isDeliveryValid()) {
            feedback.value = 'Merci de completer les informations de livraison.';
            feedbackType.value = 'error';
            return;
        }

        if (!termsAccepted.value) {
            feedback.value = 'Veuillez accepter les conditions generales de vente.';
            feedbackType.value = 'error';
            return;
        }

        if (!paymentElementComplete.value) {
            feedback.value = 'Merci de completer vos informations de paiement.';
            feedbackType.value = 'error';
            return;
        }

        if (!stripeRef.value || !elementsRef.value) {
            feedback.value = 'Le module de paiement nest pas pret.';
            feedbackType.value = 'error';
            return;
        }

        isSubmitting.value = true;

        const submitResult = await elementsRef.value.submit();
        if (submitResult?.error) {
            isSubmitting.value = false;
            feedback.value = submitResult.error.message || 'Merci de verifier les informations de paiement.';
            feedbackType.value = 'error';
            return;
        }

        const result = await stripeRef.value.confirmPayment({
            clientSecret: clientSecretRef.value,
            elements: elementsRef.value,
            confirmParams: {
                receipt_email: customer.email,
                return_url: `${window.location.origin}/Cart/View`,
                payment_method_data: {
                    billing_details: {
                        name: `${customer.firstName} ${customer.lastName}`,
                        email: customer.email,
                        phone: customer.phone,
                        address: {
                            line1: customer.address,
                            postal_code: customer.postalCode,
                            city: customer.city,
                        },
                    },
                },
                shipping: {
                    name: `${customer.firstName} ${customer.lastName}`,
                    phone: customer.phone,
                    address: {
                        line1: shippingAddress.value.line1,
                        postal_code: shippingAddress.value.postal_code,
                        city: shippingAddress.value.city,
                        country: 'FR',
                    },
                },
            },
            redirect: 'if_required',
        });

        isSubmitting.value = false;

        if (result.error) {
            feedback.value = result.error.message || 'Le paiement a echoué, veuillez reessayer.';
            feedbackType.value = 'error';
            return;
        }

        feedback.value = 'Paiement validé. Redirection vers votre recapitulatif...';
        feedbackType.value = 'success';
        clearCartAfterPayment();
        navigateTo('/Cart/View');
    }

    onMounted(() => {
        loadCartFromStorage();

        if (!cartItems.value.length || total.value <= 0) {
            feedback.value = 'Votre panier est vide.';
            feedbackType.value = 'error';
            return;
        }

        initStripe();
    });

    watch(total, (nextTotal) => {
        if (!elementsRef.value || !stripeReady.value || isInitializingStripe.value) {
            return;
        }

        if (!Number.isFinite(nextTotal) || nextTotal <= 0) {
            return;
        }

        initStripe();
    });

    const goBack = async () => {
        if (typeof window !== 'undefined' && window.history.length > 1) {
            window.history.back();
            return;
        }

        await navigateTo('/Cart/Cart');
    };
</script>

<style scoped>
    .checkout-page {
        position: relative;
        min-height: 100vh;
        padding: 3rem 1rem 4rem;
        font-family: 'DM Sans', sans-serif;
        color: var(--ink);
    }

    .checkout-back-wrap {
        position: relative;
        z-index: 3;
    }

    .bg-shape {
        position: absolute;
        z-index: 0;
        filter: blur(30px);
        opacity: 0.35;
        pointer-events: none;
    }

    .bg-shape-a {
        width: 260px;
        height: 260px;
        left: -70px;
        top: 40px;
        background: var(--brand-soft);
        border-radius: 36% 64% 70% 30% / 30% 40% 60% 70%;
        animation: drift 8s ease-in-out infinite;
    }

    .bg-shape-b {
        width: 280px;
        height: 280px;
        right: -80px;
        bottom: 60px;
        background: color-mix(in srgb, var(--accent) 20%, var(--panel) 80%);
        border-radius: 51% 49% 33% 67% / 50% 36% 64% 50%;
        animation: drift 10s ease-in-out infinite reverse;
    }

    .checkout-shell {
        position: relative;
        z-index: 1;
        max-width: 1100px;
        margin: 0 auto;
    }

    .checkout-header {
        margin-bottom: 1.5rem;
        animation: fade-slide 0.7s ease;
    }

    .checkout-header .eyebrow {
        margin: 0;
        letter-spacing: 0.18em;
        text-transform: uppercase;
        font-size: 0.72rem;
        color: var(--brand);
        font-weight: 700;
    }

    .checkout-header h1 {
        margin: 0.2rem 0;
        font-size: clamp(2rem, 4vw, 2.8rem);
        /* font-family: 'Space Grotesk', sans-serif; */
        line-height: 1.08;
    }

    .checkout-header .subtitle {
        margin: 0;
        color: var(--muted);
        font-size: 1rem;
    }

    .checkout-grid {
        display: grid;
        grid-template-columns: 1.5fr 1fr;
        gap: 1.25rem;
    }

    .panel {
        background: color-mix(in srgb, var(--panel) 92%, white 8%);
        border: 1px solid var(--line);
        border-radius: 22px;
        box-shadow: 0 16px 50px color-mix(in srgb, var(--ink) 14%, transparent);
        backdrop-filter: blur(6px);
    }

    .panel-form {
        padding: 1.3rem;
        animation: fade-slide 0.8s ease;
    }

    .panel-summary {
        padding: 1.3rem;
        animation: fade-slide 0.9s ease;
    }

    .panel-head {
        display: flex;
        align-items: center;
        justify-content: space-between;
        margin-bottom: 1rem;
    }

    .panel-head h2,
    .panel-summary h2 {
        margin: 0;
        font-size: 1.15rem;
        font-family: 'Space Grotesk', sans-serif;
    }

    .badge,
    .chip {
        font-size: 0.74rem;
        border-radius: 999px;
        padding: 0.28rem 0.65rem;
        border: 1px solid color-mix(in srgb, var(--brand) 40%, var(--panel) 60%);
        background: var(--brand-soft);
        color: var(--brand-strong);
        font-weight: 700;
    }

    .payment-head {
        margin-top: 1rem;
    }

    .form-grid {
        display: grid;
        grid-template-columns: repeat(2, minmax(0, 1fr));
        gap: 0.75rem;
    }

    .field {
        display: flex;
        flex-direction: column;
        gap: 0.32rem;
    }

    .field span {
        font-size: 0.82rem;
        font-weight: 600;
        color: var(--ink);
    }

    .field input {
        width: 100%;
        border: 1px solid var(--line);
        background: color-mix(in srgb, var(--panel) 94%, white 6%);
        border-radius: 12px;
        padding: 0.7rem 0.8rem;
        font-size: 0.95rem;
        transition:
            border-color 0.2s ease,
            box-shadow 0.2s ease;
    }

    .field input:focus {
        border-color: var(--brand);
        box-shadow: 0 0 0 3px var(--focus-ring);
        outline: none;
    }

    .field.field-invalid input,
    .field.field-invalid select,
    .field.field-invalid textarea {
        border-color: var(--error);
        box-shadow: 0 0 0 3px color-mix(in srgb, var(--error) 24%, transparent);
    }

    .field.field-invalid span {
        color: var(--error);
    }

    .field select,
    .field textarea {
        width: 100%;
        border: 1px solid var(--line);
        background: color-mix(in srgb, var(--panel) 94%, white 6%);
        border-radius: 12px;
        padding: 0.7rem 0.8rem;
        font-size: 0.95rem;
        font-family: inherit;
        color: var(--ink);
        transition:
            border-color 0.2s ease,
            box-shadow 0.2s ease;
        resize: vertical;
    }

    .field select:focus,
    .field textarea:focus {
        border-color: var(--brand);
        box-shadow: 0 0 0 3px var(--focus-ring);
        outline: none;
    }

    .delivery-box {
        border: 1px solid var(--line);
        border-radius: 14px;
        padding: 0.9rem;
        background: color-mix(in srgb, var(--panel) 86%, var(--brand-soft) 14%);
        margin-bottom: 0.95rem;
    }

    .delivery-estimate {
        margin: 0.5rem 0 0.8rem;
        color: var(--muted);
        font-size: 0.87rem;
        font-weight: 600;
    }

    .field-full {
        grid-column: 1 / -1;
    }

    .payment-zone {
        border: 1px dashed var(--line);
        border-radius: 14px;
        background: color-mix(in srgb, var(--panel) 85%, var(--brand-soft) 15%);
        padding: 0.9rem;
    }

    .hint {
        margin: 0.6rem 0 0;
        color: var(--muted);
        font-size: 0.84rem;
    }

    .consent-row {
        margin-top: 0.9rem;
        display: flex;
        align-items: start;
        gap: 0.55rem;
        font-size: 0.88rem;
        color: var(--muted);
    }

    .consent-row.consent-error span {
        color: var(--error);
        font-weight: 600;
    }

    .pay-btn {
        margin-top: 1rem;
        width: 100%;
        border: 0;
        border-radius: 14px;
        padding: 0.92rem;
        color: #fff;
        font-weight: 700;
        font-size: 1rem;
        background: linear-gradient(120deg, var(--brand) 0%, color-mix(in srgb, var(--brand) 72%, white 28%) 100%);
        box-shadow: 0 10px 30px color-mix(in srgb, var(--brand) 36%, transparent);
        transition:
            transform 0.2s ease,
            box-shadow 0.2s ease,
            opacity 0.2s ease;
    }

    .pay-btn:hover:not(:disabled) {
        transform: translateY(-1px);
        box-shadow: 0 14px 32px color-mix(in srgb, var(--brand) 44%, transparent);
    }

    .pay-btn:disabled {
        opacity: 0.6;
        cursor: not-allowed;
    }

    .feedback {
        margin: 0.8rem 0 0;
        font-size: 0.88rem;
        font-weight: 500;
    }

    .feedback.error {
        color: var(--error);
    }

    .feedback.success {
        color: var(--success);
    }

    .line-items {
        margin: 0.85rem 0;
        padding: 0;
        list-style: none;
        display: flex;
        flex-direction: column;
        gap: 0.65rem;
    }

    .line-items li {
        display: flex;
        justify-content: space-between;
        font-size: 0.95rem;
    }

    .line-items span {
        color: var(--muted);
    }

    .line-items strong {
        font-family: 'Space Grotesk', sans-serif;
    }

    .totals {
        margin-top: 1rem;
        border-top: 1px solid var(--line);
        padding-top: 0.9rem;
        display: grid;
        gap: 0.45rem;
    }

    .totals p {
        margin: 0;
        display: flex;
        justify-content: space-between;
        color: var(--muted);
    }

    .totals .grand-total {
        margin-top: 0.3rem;
        padding-top: 0.6rem;
        border-top: 1px dashed var(--line);
        color: var(--ink);
        font-weight: 700;
        font-size: 1.02rem;
    }

    .secure-note {
        margin: 1rem 0 0;
        font-size: 0.84rem;
        color: var(--muted);
        line-height: 1.45;
    }

    @keyframes drift {
        0%,
        100% {
            transform: translateY(0) rotate(0deg);
        }
        50% {
            transform: translateY(-12px) rotate(4deg);
        }
    }

    @keyframes fade-slide {
        from {
            opacity: 0;
            transform: translateY(14px);
        }
        to {
            opacity: 1;
            transform: translateY(0);
        }
    }

    @media (max-width: 960px) {
        .checkout-grid {
            grid-template-columns: 1fr;
        }
    }

    @media (max-width: 620px) {
        .checkout-page {
            padding: 2rem 0.8rem 3rem;
        }

        .panel-form,
        .panel-summary {
            padding: 1rem;
        }

        .form-grid {
            grid-template-columns: 1fr;
        }
    }
</style>
