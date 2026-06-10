from datetime import date
import json
from pathlib import Path
import re
import shutil
import subprocess
import sys


racine = Path(__file__).resolve().parent
dossier_app = racine / "front_back"
fichier_mentions = dossier_app / "app" / "contents" / "legal-mentions" / "legal-mentions.md"
fichier_cgv = dossier_app / "app" / "contents" / "cgv" / "cgv.md"
fichier_histoire = dossier_app / "app" / "contents" / "about" / "brand_history.md"
fichier_description = dossier_app / "app" / "contents" / "common" / "brand_description.md"
fichier_confidentialite = dossier_app / "app" / "contents" / "privacy-policy" / "privacy-policy.md"
fichier_config = dossier_app / "app" / "assets" / "config.json"
image_logo = dossier_app / "app" / "assets" / "img" / "small_logo_makeurshop.png"
image_accueil_1 = dossier_app / "app" / "contents" / "index" / "visual_index_1.png"
image_accueil_2 = dossier_app / "app" / "contents" / "index" / "visual_index_2.png"
image_about = dossier_app / "app" / "contents" / "about" / "timeline.png"
env = racine / ".env"
fichier_init_categories = racine / "db" / "init" / "init_categories.sql"

# Cherche une info dans le fichier markdown avec une regex
def chercher_md(pattern, texte, defaut=""):
    resultat = re.search(pattern, texte, re.MULTILINE)
    if resultat:
        return resultat.group(1).strip()
    return defaut


# Récupère seulement une partie du fichier, par exemple "Éditeur du site"
def chercher_partie(texte, titre):
    pattern = rf"^## (?:\d+\. )?{re.escape(titre)}\n(.*?)(?=\n## (?:\d+\. )?|\Z)"
    resultat = re.search(pattern, texte, re.MULTILINE | re.DOTALL)
    if resultat:
        return resultat.group(1)
    return ""


def recuperer_paragraphes(texte):
    paragraphes = []
    for partie in texte.split("\n\n"):
        partie = partie.strip()
        if partie and not partie.startswith("#"):
            paragraphes.append(partie)
    return paragraphes


# Si l'utilisateur appuie sur entrée, on garde la valeur par défaut
def demander(question, defaut):
    reponse = input(f"{question} [{defaut}] : ").strip()
    if reponse == "":
        return defaut
    return reponse


def demander_nombre(question, defaut):
    while True:
        reponse = input(f"{question} [{defaut}] : ").strip()
        if reponse == "":
            return int(defaut)
        if reponse.isdigit():
            return int(reponse)
        print("Merci d'entrer un nombre.")


def lire_ancienne_config():
    # Le fichier peut être mal fermé, donc je lis aussi les valeurs avec des regex
    if not fichier_config.exists():
        return {}, ""

    texte = fichier_config.read_text(encoding="utf-8")
    try:
        return json.loads(texte), texte
    except json.JSONDecodeError:
        return {}, texte


def valeur_config(texte, cle, defaut=""):
    return chercher_md(rf'"{re.escape(cle)}"\s*:\s*"([^"]*)"', texte, defaut)


def categories_config(texte):
    partie = chercher_md(r'"names"\s*:\s*\[(.*?)\]', texte)
    if not partie:
        return []
    return re.findall(r'"([^"]+)"', partie)


def copier_image(label, destination):
    # Si rien n'est écrit, on garde l'image déjà présente
    chemin = input(f"{label} - chemin de l'image [garder l'image actuelle] : ").strip()
    if chemin == "":
        print("Image conservée")
        return

    source = Path(chemin).expanduser()
    if not source.exists() or not source.is_file():
        raise RuntimeError(f"Image introuvable : {source}")

    destination.parent.mkdir(parents=True, exist_ok=True)
    shutil.copyfile(source, destination)
    print(f"Image copiée vers {destination}")


# Formate la date du jour en français pour le markdown
def date_du_jour():
    mois = [
        "janvier",
        "février",
        "mars",
        "avril",
        "mai",
        "juin",
        "juillet",
        "août",
        "septembre",
        "octobre",
        "novembre",
        "décembre",
    ]
    aujourdhui = date.today()
    return f"{aujourdhui.day} {mois[aujourdhui.month - 1]} {aujourdhui.year}"


def configurer_mentions_legales():
    # On vérifie si le fichier existe
    if not fichier_mentions.exists():
        raise RuntimeError(f"Le fichier des mentions légales est introuvable : {fichier_mentions}")

    # Lecture du fichier actuel pour reprendre les anciennes valeurs par défaut
    contenu = fichier_mentions.read_text(encoding="utf-8")
    partie_editeur = chercher_partie(contenu, "Éditeur du site")
    partie_hebergeur = chercher_partie(contenu, "Hébergeur")

    ancien_nom_site = chercher_md(r"^# Mentions légales – (.+)$", contenu, "MakeUrShop")

    print("\nConfiguration des mentions légales")
    nom_site = demander("Nom du site", ancien_nom_site)

    # Si le nom de société était le même que le nom du site, on garde cette logique
    ancien_nom_societe = chercher_md(
        r"- \*\*Nom de la société :\*\* (.+)$",
        partie_editeur,
        ancien_nom_site,
    )

    if ancien_nom_societe == ancien_nom_site:
        nom_societe_defaut = nom_site
    else:
        nom_societe_defaut = ancien_nom_societe

    # Questions pour la partie éditeur du site
    nom_societe = demander("Nom de la société", nom_societe_defaut)
    forme_juridique = demander(
        "Forme juridique",
        chercher_md(r"- \*\*Forme juridique :\*\* (.+)$", partie_editeur, "SAS"),
    )
    capital = demander(
        "Capital social",
        chercher_md(r"- \*\*Capital social :\*\* (.+)$", partie_editeur, "10 000 €"),
    )
    adresse = demander(
        "Adresse du siège social",
        chercher_md(r"- \*\*Adresse du siège social :\*\* (.+)$", partie_editeur),
    )
    email = demander("Email", chercher_md(r"- \*\*Email :\*\* (.+)$", partie_editeur))
    telephone = demander("Téléphone", chercher_md(r"- \*\*Téléphone :\*\* (.+)$", partie_editeur))
    siret = demander("SIRET", chercher_md(r"- \*\*SIRET :\*\* (.+)$", partie_editeur))
    directeur = demander(
        "Directeur de la publication",
        chercher_md(r"- \*\*Directeur de la publication :\*\* (.+)$", partie_editeur),
    )

    # Questions pour la partie hébergeur
    hebergeur = demander(
        "Nom de l'hébergeur",
        chercher_md(r"- \*\*Nom de l’hébergeur :\*\* (.+)$", partie_hebergeur, "OVH"),
    )
    adresse_hebergeur = demander(
        "Adresse de l'hébergeur",
        chercher_md(r"- \*\*Adresse :\*\* (.+)$", partie_hebergeur),
    )
    telephone_hebergeur = demander(
        "Téléphone de l'hébergeur",
        chercher_md(r"- \*\*Téléphone :\*\* (.+)$", partie_hebergeur),
    )
    site_hebergeur = demander(
        "Site web de l'hébergeur",
        chercher_md(r"- \*\*Site web :\*\* \[(.+)\]\(.+\)$", partie_hebergeur, "https://www.ovh.com"),
    )

    # On reconstruit tout le fichier markdown avec les réponses
    nouveau_contenu = f"""# Mentions légales – {nom_site}

**Dernière mise à jour : {date_du_jour()}**

Bienvenue sur le site **{nom_site}**. Conformément à la législation française, nous vous informons des éléments suivants concernant notre site.

---

## 1. Éditeur du site

- **Nom de la société :** {nom_societe}
- **Forme juridique :** {forme_juridique}
- **Capital social :** {capital}
- **Adresse du siège social :** {adresse}
- **Email :** {email}
- **Téléphone :** {telephone}
- **SIRET :** {siret}
- **Directeur de la publication :** {directeur}

## 2. Hébergeur

- **Nom de l’hébergeur :** {hebergeur}
- **Adresse :** {adresse_hebergeur}
- **Téléphone :** {telephone_hebergeur}
- **Site web :** [{site_hebergeur}]({site_hebergeur})

## 3. Propriété intellectuelle

1. Tous les contenus présents sur le site (textes, images, vidéos, logos, design) sont la propriété de **{nom_societe}**.
2. Toute reproduction ou utilisation sans autorisation écrite est strictement interdite.

## 4. Responsabilité

1. {nom_societe} ne peut être tenue responsable des dommages directs ou indirects résultant de l’accès ou de l’utilisation du site.
2. {nom_societe} s’efforce de garantir l’exactitude des informations, mais celles-ci peuvent évoluer.

## 5. Données personnelles

1. Les informations collectées via le site sont utilisées pour le traitement des commandes et le suivi client.
2. Conformément au RGPD, vous pouvez accéder, rectifier ou supprimer vos données en contactant **{email}**.

## 6. Cookies

1. Le site utilise des cookies pour améliorer l’expérience utilisateur et analyser la fréquentation.
2. Vous pouvez configurer votre navigateur pour refuser les cookies, mais certaines fonctionnalités pourraient être limitées.

## 7. Loi applicable

Les présentes mentions légales sont régies par la **loi française**.  
En cas de litige, les tribunaux français sont seuls compétents.
"""

    # Écriture du nouveau contenu dans le fichier
    fichier_mentions.write_text(nouveau_contenu, encoding="utf-8")
    print("Mentions légales mises à jour")


def configurer_cgv():
    # Même principe que les mentions légales, mais pour le fichier des CGV
    if not fichier_cgv.exists():
        raise RuntimeError(f"Le fichier des CGV est introuvable : {fichier_cgv}")

    contenu = fichier_cgv.read_text(encoding="utf-8")
    partie_societe = chercher_partie(contenu, "Informations sur la société")
    partie_paiement = chercher_partie(contenu, "Prix et paiement")
    partie_livraison = chercher_partie(contenu, "Livraison")
    partie_retour = chercher_partie(contenu, "Rétractation et retour")

    ancien_nom_boutique = chercher_md(r"^# Conditions Générales de Vente \(CGV\) – (.+)$", contenu, "MakeUrShop")

    print("\nConfiguration des CGV")
    nom_boutique = demander("Nom de la boutique", ancien_nom_boutique)
    secteur = demander(
        "Secteur d'activité",
        chercher_md(r"- \*\*Secteur :\*\* (.+)$", partie_societe, "Vente en ligne"),
    )
    adresse = demander(
        "Adresse de la société",
        chercher_md(r"- \*\*Adresse :\*\* (.+)$", partie_societe),
    )
    email = demander("Email", chercher_md(r"- \*\*Email :\*\* (.+)$", partie_societe))
    telephone = demander("Téléphone", chercher_md(r"- \*\*Téléphone :\*\* (.+)$", partie_societe))
    siret = demander("SIRET", chercher_md(r"- \*\*SIRET :\*\* (.+)$", partie_societe))

    moyens_paiement = demander(
        "Moyens de paiement acceptés",
        chercher_md(r"3\. Moyens de paiement acceptés : (.+)\.$", partie_paiement, "cartes bancaires"),
    )
    zone_livraison = demander(
        "Zone de livraison",
        chercher_md(r"1\. Livraison en (.+)\.$", partie_livraison, "France métropolitaine"),
    )
    delai_retractation = demander(
        "Délai de rétractation",
        chercher_md(r"1\. Vous disposez de \*\*(.+)\*\* à compter", partie_retour, "14 jours"),
    )
    delai_remboursement = demander(
        "Délai de remboursement",
        chercher_md(r"4\. Remboursement sous \*\*(.+)\*\* après", partie_retour, "14 jours"),
    )

    nouveau_contenu = f"""# Conditions Générales de Vente (CGV) – {nom_boutique}

**Dernière mise à jour : {date_du_jour()}**

Bienvenue sur **{nom_boutique}**. Avant de passer commande sur notre boutique en ligne, nous vous invitons à lire attentivement nos Conditions Générales de Vente. En passant commande, vous acceptez nos conditions.

---

## 1. Informations sur la société

- **Nom de la boutique :** {nom_boutique}
- **Secteur :** {secteur}
- **Adresse :** {adresse}
- **Email :** {email}
- **Téléphone :** {telephone}
- **SIRET :** {siret}

## 2. Produits

1. Les produits proposés sur {nom_boutique} sont conformes à la législation française.
2. Les photographies et descriptions sont fidèles, mais des variations de couleur ou de taille peuvent exister.
3. Les stocks sont limités et disponibles jusqu’à épuisement.

## 3. Commandes

1. Les commandes se font exclusivement via le site web.
2. Vous devez fournir des informations exactes et complètes.
3. {nom_boutique} se réserve le droit d'annuler ou de refuser toute commande en cas de problème (erreur de prix, indisponibilité, etc.).

## 4. Prix et paiement

1. Les prix sont indiqués en **euros (€), toutes taxes comprises (TTC)**.
2. Les frais de livraison sont indiqués avant la validation finale de la commande.
3. Moyens de paiement acceptés : {moyens_paiement}.
4. Le paiement est sécurisé grâce à notre prestataire certifié.

## 5. Livraison

1. Livraison en {zone_livraison}.
2. Délais de livraison indiqués lors de la commande.
3. En cas de retard ou de problème, vous serez informé par email ou téléphone.

## 6. Rétractation et retour

1. Vous disposez de **{delai_retractation}** à compter de la réception pour exercer votre droit de rétractation.
2. Les produits doivent être retournés **non portés, dans leur emballage d’origine**.
3. Frais de retour à la charge du client, sauf erreur de {nom_boutique}.
4. Remboursement sous **{delai_remboursement}** après réception du produit retourné.

## 7. Garantie et responsabilité

1. Tous les produits bénéficient de la garantie légale de conformité et de la garantie contre les vices cachés.
2. {nom_boutique} n’est pas responsable des dommages indirects liés à l’utilisation des produits.

## 8. Protection des données

1. Les informations personnelles collectées servent au **traitement des commandes** et **à l’amélioration de nos services**.
2. Conformément au RGPD, vous pouvez accéder, modifier ou supprimer vos données personnelles.
3. Contact : **{email}**

## 9. Propriété intellectuelle

1. Tous les contenus du site (textes, images, logos, vidéos) sont la propriété de {nom_boutique}.
2. Toute reproduction totale ou partielle est interdite sans autorisation écrite.

## 10. Loi applicable et juridiction

1. Les présentes CGV sont régies par la **loi française**.
2. En cas de litige, seuls les tribunaux français sont compétents.

Merci de votre confiance et bonne navigation sur **{nom_boutique}**
"""

    fichier_cgv.write_text(nouveau_contenu, encoding="utf-8")
    print("CGV mises à jour")


def configurer_description_marque():
    # Description courte utilisée dans les pages communes
    if not fichier_description.exists():
        raise RuntimeError(f"Le fichier de description est introuvable : {fichier_description}")

    contenu = fichier_description.read_text(encoding="utf-8")
    paragraphes = recuperer_paragraphes(contenu)

    print("\nConfiguration de la description de marque")
    nom_marque = demander(
        "Nom de la marque",
        chercher_md(r"^([A-Za-z0-9À-ÿ' -]+) est une marque", contenu, "MakeUrShop"),
    )
    phrase_1 = demander(
        "Phrase 1",
        paragraphes[0] if len(paragraphes) > 0 else f"{nom_marque} est une marque de vêtements contemporaine.",
    )
    phrase_2 = demander(
        "Phrase 2",
        paragraphes[1] if len(paragraphes) > 1 else "La marque propose des pièces modernes et accessibles.",
    )
    phrase_3 = demander(
        "Phrase 3",
        paragraphes[2] if len(paragraphes) > 2 else "Elle mélange confort, qualité et style.",
    )
    phrase_4 = demander(
        "Phrase 4",
        paragraphes[3] if len(paragraphes) > 3 else "Chaque collection est pensée pour accompagner le quotidien.",
    )

    nouveau_contenu = f"""{phrase_1}

{phrase_2}

{phrase_3}

{phrase_4}
"""

    ancien_nom = chercher_md(r"^([A-Za-z0-9À-ÿ' -]+) est une marque", contenu, "MakeUrShop")
    nouveau_contenu = nouveau_contenu.replace(ancien_nom, nom_marque)
    fichier_description.write_text(nouveau_contenu, encoding="utf-8")
    print("Description de marque mise à jour")


def configurer_histoire_marque():
    # Page about, avec l'histoire et la philosophie de la marque
    if not fichier_histoire.exists():
        raise RuntimeError(f"Le fichier d'histoire de marque est introuvable : {fichier_histoire}")

    contenu = fichier_histoire.read_text(encoding="utf-8")
    ancien_nom = chercher_md(r"À l’origine de \*\*(.+?)\*\*", contenu, "MakeUrShop")
    titres = re.findall(r"^## (.+)$", contenu, re.MULTILINE)

    titre_1 = titres[0] if len(titres) > 0 else 'Le Manifeste du "User-Centric"'
    partie_1 = chercher_partie(contenu, titre_1)
    titre_2 = titres[1] if len(titres) > 1 else 'Notre Philosophie : "Less is More, Identity is Everything"'
    partie_2 = chercher_partie(contenu, titre_2)
    titre_3 = titres[2] if len(titres) > 2 else "Inspirations Hybrides"
    partie_3 = chercher_partie(contenu, titre_3)

    print("\nConfiguration de l'histoire de marque")
    nom_marque = demander("Nom de la marque", ancien_nom)
    nouveau_titre_1 = demander("Titre de la première partie", titre_1)
    intro = demander(
        "Texte de présentation",
        recuperer_paragraphes(partie_1)[0] if recuperer_paragraphes(partie_1) else "",
    )
    cible = demander(
        "Texte sur la cible de la marque",
        recuperer_paragraphes(partie_1)[1] if len(recuperer_paragraphes(partie_1)) > 1 else "",
    )

    nouveau_titre_2 = demander("Titre de la philosophie", titre_2)
    philosophie = demander(
        "Texte de philosophie",
        recuperer_paragraphes(partie_2)[0] if recuperer_paragraphes(partie_2) else "",
    )
    coupe = demander("Texte sur la coupe", chercher_md(r"\*\*La Coupe :\*\* (.+)$", partie_2))
    matiere = demander("Texte sur la matière", chercher_md(r"\*\*La Matière :\*\* (.+)$", partie_2))
    detail = demander("Texte sur le détail", chercher_md(r"\*\*Le Détail :\*\* (.+)$", partie_2))

    nouveau_titre_3 = demander("Titre des inspirations", titre_3)
    inspiration = demander(
        "Texte d'inspiration",
        recuperer_paragraphes(partie_3)[0] if recuperer_paragraphes(partie_3) else "",
    )
    citation = demander(
        "Citation finale",
        chercher_md(r'^> "(.+)"$', partie_3),
    )

    nouveau_contenu = f"""## {nouveau_titre_1}

{intro}

{cible}

## {nouveau_titre_2}

{philosophie}

**La Coupe :** {coupe}

**La Matière :** {matiere}

**Le Détail :** {detail}

## {nouveau_titre_3}

{inspiration}

> "{citation}"
"""

    nouveau_contenu = nouveau_contenu.replace(ancien_nom, nom_marque)
    fichier_histoire.write_text(nouveau_contenu, encoding="utf-8")
    print("Histoire de marque mise à jour")


def configurer_politique_confidentialite():
    # Politique de confidentialité du site
    if not fichier_confidentialite.exists():
        raise RuntimeError(f"Le fichier de confidentialité est introuvable : {fichier_confidentialite}")

    contenu = fichier_confidentialite.read_text(encoding="utf-8")
    partie_collecte = chercher_partie(contenu, "Collecte des données")
    ancien_nom_site = chercher_md(r"^# Politique de confidentialité – (.+)$", contenu, "MakeUrShop")
    ancien_email = chercher_md(r"Pour exercer vos droits : \*\*(.+)\*\*", contenu, "support@makeurshop.com")

    print("\nConfiguration de la politique de confidentialité")
    nom_site = demander("Nom du site", ancien_nom_site)
    email = demander("Email de contact RGPD", ancien_email)
    donnees_personnelles = demander(
        "Données personnelles collectées",
        chercher_md(r"- Informations personnelles : (.+)\.$", partie_collecte, "nom, prénom, email, téléphone, adresse"),
    )
    donnees_paiement = demander(
        "Données de paiement / commande",
        chercher_md(r"- (Informations de paiement et commande)\.$", partie_collecte, "Informations de paiement et commande"),
    )
    donnees_navigation = demander(
        "Données de navigation",
        chercher_md(r"- Informations de navigation sur notre site \((.+)\)\.$", partie_collecte, "cookies, analytics"),
    )

    nouveau_contenu = f"""# Politique de confidentialité – {nom_site}

**Dernière mise à jour : {date_du_jour()}**

La protection de vos données personnelles est essentielle pour **{nom_site}**. Cette politique explique comment nous collectons, utilisons et protégeons vos informations.

---

## 1. Collecte des données

Nous collectons les données suivantes :

- Informations personnelles : {donnees_personnelles}.
- {donnees_paiement}.
- Informations de navigation sur notre site ({donnees_navigation}).

## 2. Utilisation des données

Vos données sont utilisées pour :

1. Traiter vos commandes et livraisons.
2. Gérer votre compte utilisateur.
3. Améliorer nos services et notre site web.
4. Vous envoyer des communications marketing (si consentement donné).

## 3. Partage des données

1. Vos données ne sont **jamais vendues** à des tiers.
2. Elles peuvent être partagées avec nos prestataires pour la livraison, le paiement ou l’hébergement, dans le strict cadre de nos services.

## 4. Sécurité des données

1. {nom_site} met en œuvre des mesures techniques et organisationnelles pour protéger vos informations.
2. Vos données sont stockées sur des serveurs sécurisés.
3. Seules les personnes autorisées ont accès à vos informations.

## 5. Droits des utilisateurs

Conformément au RGPD, vous pouvez :

- Accéder à vos données personnelles.
- Les rectifier ou les supprimer.
- Vous opposer à leur traitement ou demander leur limitation.
- Retirer votre consentement à tout moment.

Pour exercer vos droits : **{email}**

## 6. Cookies et traceurs

1. Le site utilise des cookies pour améliorer l’expérience et analyser la fréquentation.
2. Vous pouvez les gérer ou les refuser via les paramètres de votre navigateur.

## 7. Modifications

{nom_site} peut mettre à jour cette politique à tout moment.  
La date de la dernière mise à jour sera toujours indiquée en haut du document.
"""

    fichier_confidentialite.write_text(nouveau_contenu, encoding="utf-8")
    print("Politique de confidentialité mise à jour")


def configurer_config_json():
    # Fichier utilisé par le footer, la page contact et la config navbar
    ancienne_config, texte_config = lire_ancienne_config()

    contenu_cgv = fichier_cgv.read_text(encoding="utf-8") if fichier_cgv.exists() else ""
    contenu_mentions = fichier_mentions.read_text(encoding="utf-8") if fichier_mentions.exists() else ""

    infos_cgv = chercher_partie(contenu_cgv, "Informations sur la société")
    infos_mentions = chercher_partie(contenu_mentions, "Éditeur du site")

    info_config = ancienne_config.get("config", {}).get("info", {})
    navbar_config = ancienne_config.get("config", {}).get("navBar", {})

    nom_defaut = (
        chercher_md(r"- \*\*Nom de la boutique :\*\* (.+)$", infos_cgv)
        or chercher_md(r"- \*\*Nom de la société :\*\* (.+)$", infos_mentions)
        or info_config.get("storeName")
        or valeur_config(texte_config, "storeName", "MakeUrShop")
    )
    email_defaut = (
        chercher_md(r"- \*\*Email :\*\* (.+)$", infos_cgv)
        or chercher_md(r"- \*\*Email :\*\* (.+)$", infos_mentions)
        or info_config.get("storeEmail")
        or valeur_config(texte_config, "storeEmail", "info@makeurshop.fr")
    )
    telephone_defaut = (
        chercher_md(r"- \*\*Téléphone :\*\* (.+)$", infos_cgv)
        or chercher_md(r"- \*\*Téléphone :\*\* (.+)$", infos_mentions)
        or info_config.get("storePhone")
        or valeur_config(texte_config, "storePhone", "+33612345678")
    )
    adresse_defaut = (
        chercher_md(r"- \*\*Adresse :\*\* (.+)$", infos_cgv)
        or chercher_md(r"- \*\*Adresse du siège social :\*\* (.+)$", infos_mentions)
        or info_config.get("storeAddress")
        or valeur_config(texte_config, "storeAddress", "")
    )
    siret_defaut = (
        chercher_md(r"- \*\*SIRET :\*\* (.+)$", infos_cgv)
        or chercher_md(r"- \*\*SIRET :\*\* (.+)$", infos_mentions)
        or info_config.get("storeSiret")
        or valeur_config(texte_config, "storeSiret", "")
    )
    adresse_nom_defaut = (
        info_config.get("storeAddressName")
        or valeur_config(texte_config, "storeAddressName")
        or adresse_defaut
    )

    anciennes_categories = navbar_config.get("names") or categories_config(texte_config)
    ancien_nombre_categories = (
        navbar_config.get("categoriesNb")
        or chercher_md(r'"categoriesNb"\s*:\s*(\d+)', texte_config)
        or len(anciennes_categories)
        or 3
    )

    print("\nConfiguration du fichier config.json")
    nom_boutique = demander("Nom affiché de la boutique", nom_defaut)
    email = demander("Email de contact", email_defaut)
    telephone = demander("Téléphone de contact", telephone_defaut)
    adresse = demander("Adresse complète", adresse_defaut)
    adresse_nom = demander("Nom de l'adresse pour Google Maps", adresse_nom_defaut)
    siret = demander("SIRET", siret_defaut)

    nombre_categories = demander_nombre("Nombre de catégories dans la navbar", ancien_nombre_categories)
    categories = []
    for index in range(nombre_categories):
        defaut = anciennes_categories[index] if index < len(anciennes_categories) else f"Catégorie {index + 1}"
        categories.append(demander(f"Nom de la catégorie {index + 1}", defaut))

    nouvelle_config = {
        "config": {
            "navBar": {
                "categoriesNb": nombre_categories,
                "names": categories,
            },
            "info": {
                "storeName": nom_boutique,
                "storeEmail": email,
                "storePhone": telephone,
                "storeAddress": adresse,
                "storeAddressName": adresse_nom,
                "storeSiret": siret,
            },
        }
    }

    fichier_config.write_text(json.dumps(nouvelle_config, indent=4, ensure_ascii=False) + "\n", encoding="utf-8")
    print("config.json mis à jour")


def configurer_images():
    # Les noms de fichiers restent les mêmes pour ne rien changer dans le code du site
    print("\nConfiguration des images")
    copier_image("Logo navbar", image_logo)
    copier_image("Image accueil 1", image_accueil_1)
    copier_image("Image accueil 2", image_accueil_2)
    copier_image("Image page à propos", image_about)


def installer_dependances():
    # npm doit être installé pour pouvoir installer les dépendances du projet
    if shutil.which("npm") is None:
        raise RuntimeError("npm est introuvable. Installez Node.js/npm avant de relancer ce script")

    print(f"Installation des dépendances npm dans {dossier_app}...")
    subprocess.run(["npm", "install"], cwd=dossier_app, check=True)
    print("Installation npm terminée")

def configurer_env():
    # Clés de base pour un site type e‑commerce Nuxt / backend
    cles = [
        "DB_HOST",
        "DB_USER",
        "DB_PASSWORD",
        "DB_NAME",
        "MAIL_USER",
        "MAIL_PASS",
    ]

    # Valeurs par défaut
    defauts = {
        "DB_HOST": "db",
        "DB_USER": "root",
        "DB_PASSWORD": "root",
        "DB_NAME": "makeurshop",
        "MAIL_USER": "makeurshop.projet4a@gmail.com",
        "MAIL_PASS": "naebjbxchcnkdmef",
    }

    # Lecture du fichier .env actuel
    if not env.exists():
        # Si le fichier n’existe pas, on part sur les défauts
        valeurs = defauts.copy()
    else:
        contenu = env.read_text(encoding="utf-8")
        valeurs = {}
        for cle in cles:
            defaut = defauts[cle]
            # On cherche `CLE=value` ou `CLE="value"`
            resultat = re.search(
                rf"^{cle}\s*=\s*[\"']*([^\"'\n]+)[\"']*",
                contenu,
                re.MULTILINE
            )
            if resultat:
                valeurs[cle] = resultat.group(1)
            else:
                valeurs[cle] = defaut

    print("\nConfiguration du fichier .env")

    # On demande les valeurs à l’utilisateur
    for cle in cles:
        defaut = valeurs[cle]
        reponse = input(f"{cle} [{defaut}] : ").strip()
        if reponse != "":
            valeurs[cle] = reponse

    # Génération du nouveau contenu
    lignes = []
    for cle in cles:
        val = valeurs[cle]
        lignes.append(f'{cle}={val}')

    nouveau_contenu = "\n".join(lignes) + "\n"
    env.write_text(nouveau_contenu, encoding="utf-8")
    print(".env configuré et sauvegardé")

def configurer_bdd_categories():
    print("\nConfiguration des sous-catégories pour les catégories déjà définies dans config.json")

    # Créer le dossier db/init si il n'existe pas
    fichier_init_categories.parent.mkdir(parents=True, exist_ok=True)

    # Lire les catégories de config.json
    ancienne_config, texte_config = lire_ancienne_config()
    navbar_config = ancienne_config.get("config", {}).get("navBar", {})
    categories = navbar_config.get("names") or categories_config(texte_config)

    if not categories:
        raise RuntimeError("Pas de catégories trouvées dans config.json. Configuration les catégories d'abord avec configurer_config_json().")

    print(f"Catégories trouvées dans config.json : {categories}")

    # Si le fichier n'existe pas, on le crée avec le CREATE TABLE + INSERT
    if not fichier_init_categories.exists():
        contenu_actuel = (
            "-- Categories et sous-catégories\n"
            "\n"
            "DROP TABLE IF EXISTS `category`;\n"
            "CREATE TABLE `category` (\n"
            "  `id` int NOT NULL AUTO_INCREMENT,\n"
            "  `name` varchar(150) NOT NULL,\n"
            "  `category_parent_id` int DEFAULT NULL,\n"
            "  PRIMARY KEY (`id`),\n"
            "  KEY `category_parent_id` (`category_parent_id`),\n"
            "  CONSTRAINT `category_ibfk_1` FOREIGN KEY (`category_parent_id`) REFERENCES `category` (`id`)\n"
            ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;\n"
            "\n"
            "INSERT INTO `category` (`id`, `name`, `category_parent_id`) VALUES\n"
        )
        fichier_init_categories.write_text(contenu_actuel, encoding="utf-8")
    else:
        contenu_actuel = fichier_init_categories.read_text(encoding="utf-8")

    # 1. Pour chaque catégorie (déjà dans config.json), demander le nombre de sous-catégories et leurs noms
    categories_parentes = []
    for nom_cat in categories:
        categories_parentes.append({"nom": nom_cat, "sous_categories": []})

        nombre_sous = demander_nombre(f"Nombre de sous-catégories pour '{nom_cat}'", 2)

        for j in range(nombre_sous):
            defaut = f"Sous-catégorie {j + 1}"
            nom_sous = demander(f"Nom de la sous-catégorie {j + 1} pour '{nom_cat}'", defaut)
            categories_parentes[-1]["sous_categories"].append(nom_sous)

    # 2. Trouver la partie INSERT INTO `category` ... jusqu'à le ";" final
    match_insert_category = re.search(
        r"(INSERT INTO `category` \(`id`, `name`, `category_parent_id`\) VALUES\n)(.*?)(;)\n",
        contenu_actuel,
        re.MULTILINE | re.DOTALL
    )

    if match_insert_category:
        debut_insert = match_insert_category.group(1)
        position_depart_bloc = match_insert_category.start()
        position_fin_bloc = match_insert_category.end()

        partie_avant = contenu_actuel[:position_depart_bloc]
        partie_apres = contenu_actuel[position_fin_bloc:]
    else:
        debut_insert = ""
        partie_avant = (
            "-- Categories et sous-catégories\n"
            "\n"
            "DROP TABLE IF EXISTS `category`;\n"
            "CREATE TABLE `category` (\n"
            "  `id` int NOT NULL AUTO_INCREMENT,\n"
            "  `name` varchar(150) NOT NULL,\n"
            "  `category_parent_id` int DEFAULT NULL,\n"
            "  PRIMARY KEY (`id`),\n"
            "  KEY `category_parent_id` (`category_parent_id`),\n"
            "  CONSTRAINT `category_ibfk_1` FOREIGN KEY (`category_parent_id`) REFERENCES `category` (`id`)\n"
            ") ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;\n"
            "\n"
            "INSERT INTO `category` (`id`, `name`, `category_parent_id`) VALUES\n"
        )
        partie_apres = ""

    # 3. Générer les nouvelles INSERT pour `category`
    insert_lines = []
    id_counter = 1

    # Catégories parentes (category_parent_id = NULL)
    for cat in categories_parentes:
        line = f"({id_counter}, '{cat['nom']}', NULL)"
        insert_lines.append(line)
        id_counter += 1

    # Sous-catégories (avec category_parent_id)
    for i, cat in enumerate(categories_parentes):
        parent_id = i + 1
        for sous in cat["sous_categories"]:
            line = f"({id_counter}, '{sous}', {parent_id})"
            insert_lines.append(line)
            id_counter += 1

    # Mettre des commas à la fin de chaque ligne sauf la dernière
    for i in range(len(insert_lines)):
        if i < len(insert_lines) - 1:
            insert_lines[i] += ","

    nouvelles_insert = debut_insert + "\n".join(insert_lines) + "\n;"

    # 4. Reconstruire le fichier complet (CORRECTION : utiliser partie_avant)
    nouveau_contenu = partie_avant + nouvelles_insert + partie_apres

    # 5. Écrire dans le fichier
    fichier_init_categories.write_text(nouveau_contenu, encoding="utf-8")

    print(f"Fichier d'initialisation des catégories modifié : {fichier_init_categories}")
    

def main():
    try:
        # Configuration du projet
        configurer_env()
        configurer_mentions_legales()
        configurer_cgv()
        configurer_description_marque()
        configurer_histoire_marque()
        configurer_politique_confidentialite()
        configurer_config_json()
        configurer_images()
        installer_dependances()
        configurer_bdd_categories()
    except subprocess.CalledProcessError as erreur:
        print(f"Erreur pendant npm install ({erreur.returncode})", file=sys.stderr)
        return erreur.returncode
    except RuntimeError as erreur:
        print(erreur, file=sys.stderr)
        return 1

    return 0


if __name__ == "__main__":
    sys.exit(main())
