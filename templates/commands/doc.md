---
description: Créer une nouvelle documentation au format Divio
---

Créer un nouveau document avec les 4 blocs Divio.

1. Demander les informations :
   - Titre du document
   - Domaine/fonction (ex: data_collect, model_train, model_eval)
   - Type principal (tutorial/howto/reference/explanation pour classification docs-index.yml)

2. Vérifier dans docs-index.yml qu'un document similaire n'existe pas déjà

3. Créer le fichier dans le domaine approprié :
   `[domaine]/docs/[nom-document].md`

4. Structure du document (4 blocs Divio OBLIGATOIRES) :
   ```markdown
   # [Titre]

   ## 📚 Tutorial (Apprentissage)
   Guide pas-à-pas pour démarrer avec [sujet].

   ### Prérequis
   - [Liste des prérequis]

   ### Étapes
   1. [Étape 1]
   2. [Étape 2]

   ## 🛠️ How-to (Objectifs)
   Solutions pour résoudre des problèmes spécifiques.

   ### Problème 1 : [Titre]
   **Contexte** : [...]
   **Solution** :
   ```bash
   [commandes]
   ```

   ## 📋 Reference (Information)
   Documentation technique détaillée.

   ### API / Configuration
   [Tables, paramètres, options]

   ### Fichiers
   - `[chemin/fichier]` : [description]

   ## 💡 Explanation (Compréhension)
   Concepts, décisions architecturales, trade-offs.

   ### Pourquoi cette approche ?
   [Explication des choix]

   ### Architecture
   [Diagrammes, décisions]
   ```

5. Mettre à jour docs-index.yml :
   ```yaml
   [type principal]:
     - name: [Titre]
       file: [domaine]/docs/[nom-document].md
   ```

6. Confirmer :
   "Document créé : [chemin]. N'oublie pas de le compléter avec le contenu spécifique !"
