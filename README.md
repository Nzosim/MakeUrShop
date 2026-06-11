# Make Ur Shop

Lancement du projet :

```
docker compose up -d
```

Site visible sur :

```
localhost:3000
```

Adminer visible sur :

```
localhost:8080
```

> Les crédentials sont dans le fichier .env

Le fichier `db/init.sql` contient l'initialisation de la base données de devs

# Configuration du projet

```
Création d'un compte Stripe
```

```
Création d'un compte email
```

```
python setup_project.py
```

# Fichier .env à ajouter dans le dossier front_back

```
NUXT_PUBLIC_STRIPE_PUBLISHABLE_KEY=
NUXT_STRIPE_SECRET_KEY=
STRIPE_SECRET_KEY=
```

# Fichier .env à ajouter à la racine du projet

```
DB_HOST=db
DB_USER=root
DB_PASSWORD=root
DB_NAME=makeurshop
MAIL_USER=
MAIL_PASS=
```
