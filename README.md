# MakeUrShop

[![Project Status](https://img.shields.io/badge/status-en%20d%C3%A9veloppement-orange)]()
[![Nuxt](https://img.shields.io/badge/Nuxt.js-00DC82?logo=nuxtdotjs&logoColor=white)]()
[![Vue](https://img.shields.io/badge/Vue.js-4FC08D?logo=vuedotjs&logoColor=white)]()
[![Vuetify](https://img.shields.io/badge/Vuetify-1867C0?logo=vuetify&logoColor=white)]()
[![Docker](https://img.shields.io/badge/Docker-2496ED?logo=docker&logoColor=white)]()

> Plateforme e-commerce automatisée conçue pour aider les petites boutiques à déployer rapidement leur boutique en ligne, gérer leurs produits, leurs commandes et suivre leurs statistiques.

## Sommaire

- [À propos](#à-propos)
- [Fonctionnalités](#fonctionnalités)
- [Stack technique](#stack-technique)
- [Démarrage rapide](#démarrage-rapide)
- [Structure du projet](#structure-du-projet)
- [État du projet](#état-du-projet)
- [Licence](#licence)
- [Équipe](#équipe)

## À propos

Nous c'est Enzo, Timothé et Joan, trois étudiants en informatique passionnés par le développement web et on a voulu créer un projet utile pour les petites structures qui souhaitent se lancer dans le e-commerce sans avoir à gérer la complexité technique d’une boutique en ligne.
MakeUrShop est un projet pensé pour simplifier le lancement d’un site e-commerce pour les petites structures.  
L’objectif est de proposer une solution simple à prendre en main, rapide à déployer et capable de centraliser la gestion d’une boutique en ligne.

Le projet répond à un besoin concret : réduire la complexité technique liée à la création et à la gestion d’une boutique e-commerce, tout en offrant un outil lisible pour les clients et les administrateurs.

## Fonctionnalités

- Gestion des produits, marques, catégories et stocks
- Gestion des commandes
- Génération des bordereaux d'expédition
- Suivi des expéditions
- Compte client et historique des commandes
- Tableau de bord et statistiques
- Interface pensée pour les clients et les administrateurs
- Déploiement conteneurisé
- Adaptation à plusieurs types de boutiques
- Hébergement sur serveur personnel

## Stack technique

- Nuxt.js
- Vue.js
- Vuetify
- Docker
- Base de données

## Démarrage rapide

### Prérequis

- Node.js
- npm, pnpm, yarn ou brew
- Docker si vous souhaitez utiliser le conteneur
- Git

### Installation

```bash
git clone https://github.com/Nzosim/MakeUrShop.git
cd makeurshop
npm install
```

### Lancer le projet en local

```bash
npm run dev
```

### Avec Docker

```bash
docker-compose up -d
```

## Configuration

### Prérequis

- Création d'un compte Stripe
- Création d'un compte email

```env
python setup_project.py
```

> Cette commande permet de configurer automatiquement l'ensemble du projet

## Structure du projet

```bash
.
├── db
├──── init
├────── init_schema.sql
├── front_back
├──── app
├──── public
├──── server
├──── nuxt.config.ts
├──── package.json
├──── .env
├── .env
├── docker-compose.yml
├── setup_project.py
└── README.md
```

## État du projet

Le projet est **actuellement en cours de développement**.  
Il peut contenir des bugs, des comportements imprévus ou des fonctionnalités incomplètes.

Le projet n’est **pas encore sécurisé pour une utilisation en production**.  
Il ne doit pas être utilisé avec des données sensibles ou dans un environnement commercial réel sans vérification, tests et durcissement de sécurité.

## Licence

Ce projet est distribué sous licence personnalisée/provisoire.  
L’utilisation commerciale, la redistribution ou la réutilisation dans un contexte de production ne sont pas autorisées sans accord préalable des auteurs.

## Équipe

- Enzo Simonin
- Timothé Farina
- Joan Rodrigues
