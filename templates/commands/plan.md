Planifier avant d'implémenter.

## Étape 1 : Évaluer la complexité

**AU MOINS 1 CRITÈRE CI-DESSOUS ?**
- Nouveau comportement utilisateur visible
- Changement d'architecture ou patterns
- Impact sur plusieurs features existantes
- Intégration avec système externe
- Modification d'API publique / contrat

**→ OUI (au moins 1) → Étape 2A : Documentation Divio formelle**
**→ NON (aucun) → Étape 2B : Plan rapide**

Exemples "Plan rapide" : bug fix, refactoring, utilitaire

---

## Étape 2A : Critère détecté → Documentation formelle

1. Consulter docs-index.yml pour voir si doc similaire existe

2. Créer documentation Divio avec `/doc` :
   - Titre de la feature
   - Domaine (data_collect, model_train, etc.)
   - Type principal (tutorial/howto/reference/explanation)

3. Compléter les 4 blocs Divio :
   - 📚 Tutorial : Guide pas-à-pas
   - 🛠️ How-to : Solutions problèmes spécifiques
   - 📋 Reference : Détails techniques (API, config, fichiers)
   - 💡 Explanation : Concepts, décisions, architecture

4. Présenter la doc pour validation

5. Attendre confirmation explicite : "La doc est validée, implémente"

---

## Étape 2B : Aucun critère → Plan rapide

1. Lire les fichiers concernés (NE PAS coder encore)

2. Analyser avec 4 perspectives :
   - **Faisabilité** : Chemin d'implémentation
   - **Edge cases** : Cas limites et erreurs
   - **Performance** : Implications
   - **Intégration** : Dépendances

3. Créer un plan en étapes numérotées

4. Attendre validation avant d'implémenter

---

## Étape 3 : Validation

Présenter le plan/spec et demander :
"Le plan te convient ? Je peux implémenter ?"

NE JAMAIS implémenter sans validation explicite.
