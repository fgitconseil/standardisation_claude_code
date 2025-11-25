#!/bin/bash

# ══════════════════════════════════════════════════════════════════
# setup-commands.sh
# Crée les slash commands pour Claude Code CLI
# ══════════════════════════════════════════════════════════════════

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}══════════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}   CRÉATION DES SLASH COMMANDS                                 ${NC}"
echo -e "${BLUE}══════════════════════════════════════════════════════════════${NC}"

# Créer le dossier
mkdir -p .claude/commands

# ══════════════════════════════════════════════════════════════════
# /context
# ══════════════════════════════════════════════════════════════════
cat > .claude/commands/context.md << 'EOF'
Charger le contexte complet du projet :

1. Lire CLAUDE.md
2. Lire backlog.md
3. Lire openspec/project.md (si existe)
4. Exécuter `backlog board view`
5. Exécuter `openspec list` (si OpenSpec initialisé)
6. Résumer :
   - État actuel du projet
   - Tâches in-progress
   - Specs/changes actifs
   - Problèmes bloquants
7. Demander "On continue sur quoi ?"
EOF
echo "  ✅ /context"

# ══════════════════════════════════════════════════════════════════
# /task
# ══════════════════════════════════════════════════════════════════
cat > .claude/commands/task.md << 'EOF'
Créer une nouvelle tâche.

1. Demander la description si pas précisée

2. Créer la tâche :
   ```
   backlog task create "[description]"
   ```

3. Demander si on doit planifier maintenant :
   "Tâche créée. Tu veux que je planifie avec /plan ?"
EOF
echo "  ✅ /task"

# ══════════════════════════════════════════════════════════════════
# /plan
# ══════════════════════════════════════════════════════════════════
cat > .claude/commands/plan.md << 'EOF'
Planifier avant d'implémenter.

## Étape 1 : Évaluer si OpenSpec est nécessaire

**AU MOINS 1 CRITÈRE CI-DESSOUS ?**
- Nouveau comportement utilisateur visible
- Changement d'architecture ou patterns
- Impact sur plusieurs features existantes
- Intégration avec système externe
- Modification d'API publique / contrat

**→ OUI (au moins 1) → Étape 2A : OpenSpec**
**→ NON (aucun) → Étape 2B : Plan rapide**

Exemples "Plan rapide" : bug fix, refactoring, utilitaire, docs

---

## Étape 2A : Critère OpenSpec détecté → Spec formelle

1. Créer une proposition OpenSpec :
   ```
   openspec proposal "[Nom de la feature]"
   ```

2. Générer les specs avec :
   - Comportement attendu
   - Critères d'acceptation (Given/When/Then)
   - Scénarios (happy path, edge cases, erreurs)

3. Présenter la spec pour validation

4. Attendre confirmation explicite : "La spec est validée, implémente"

5. Lier à Backlog.md :
   ```
   backlog task create "[Feature] - Voir openspec/changes/[name]/"
   ```

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
EOF
echo "  ✅ /plan"

# ══════════════════════════════════════════════════════════════════
# /spec
# ══════════════════════════════════════════════════════════════════
cat > .claude/commands/spec.md << 'EOF'
Créer une spécification OpenSpec pour une feature.

1. Demander le nom de la feature si pas précisé

2. Créer la proposition :
   ```
   openspec proposal "[Nom de la feature]"
   ```

3. Générer les fichiers de spec :

   **openspec/changes/[feature]/proposal.md :**
   - Contexte et motivation
   - Objectifs
   - Non-objectifs (ce qu'on ne fait PAS)

   **openspec/changes/[feature]/tasks.md :**
   - Liste numérotée des tâches d'implémentation
   - Sous-tâches si nécessaire
   - Estimation de complexité

   **openspec/changes/[feature]/specs/[component].md :**
   - Comportement attendu
   - Critères d'acceptation (Given/When/Then)
   - Scénarios :
     - Happy path
     - Edge cases
     - Gestion d'erreurs
   - Impacts sur l'existant

4. Valider la syntaxe :
   ```
   openspec validate [feature-name]
   ```

5. Présenter à l'utilisateur pour review
EOF
echo "  ✅ /spec"

# ══════════════════════════════════════════════════════════════════
# /work
# ══════════════════════════════════════════════════════════════════
cat > .claude/commands/work.md << 'EOF'
Travailler sur une tâche.

1. Identifier la tâche (demander si pas précisé)

2. Vérifier si une spec OpenSpec existe :
   ```
   openspec list
   ```
   Si oui → Lire la spec avant de coder

3. Démarrer la tâche :
   ```
   backlog task start <task-id>
   ```

4. Si spec OpenSpec existe :
   - Suivre exactement les spécifications
   - Respecter les critères d'acceptation
   - Implémenter tous les scénarios décrits

5. Si pas de spec :
   - Implémenter selon le plan validé
   - Code complet, pas de placeholders

6. Mettre à jour la tâche avec notes d'implémentation

7. Déplacer vers review :
   ```
   backlog task move <task-id> review
   ```
EOF
echo "  ✅ /work"

# ══════════════════════════════════════════════════════════════════
# /done
# ══════════════════════════════════════════════════════════════════
cat > .claude/commands/done.md << 'EOF'
Terminer une session de travail.

1. Mettre à jour les tâches Backlog :
   - Ajouter notes d'implémentation
   - Déplacer les tâches terminées vers "done"

2. Si des specs OpenSpec ont été implémentées :
   - Vérifier que tous les critères d'acceptation sont remplis
   - Archiver les changes complétés :
     ```
     openspec archive <change-name>
     ```
   (Cela merge les specs dans openspec/specs/)

3. Mettre à jour "État du Projet" dans CLAUDE.md

4. Afficher un résumé :
   - ✅ Tâches complétées
   - 📝 Specs archivées
   - 🚧 Tâches en cours
   - 🎯 Prochaines priorités
EOF
echo "  ✅ /done"

# ══════════════════════════════════════════════════════════════════
# /ship
# ══════════════════════════════════════════════════════════════════
cat > .claude/commands/ship.md << 'EOF'
Livrer les changements.

1. Vérifier :
   - Toutes les tâches "in-progress" sont terminées ?
   - Toutes les specs OpenSpec sont implémentées ?

2. Exécuter les tests avec couverture

3. Si tests OK :
   - Linter + fix automatique
   - Archiver les specs OpenSpec complétées :
     ```
     openspec archive <change-name>
     ```
   - Déplacer les tâches vers "done"
   - Git commit avec références :
     ```
     git commit -m "feat: [description]

     Implements: TASK-XX
     Spec: openspec/changes/[feature-name]"
     ```
   - Push

4. Si échec :
   - Créer une tâche bug dans Backlog
   - NE PAS archiver la spec
   - Afficher les erreurs et suggérer des fixes
EOF
echo "  ✅ /ship"

# ══════════════════════════════════════════════════════════════════
# Résumé
# ══════════════════════════════════════════════════════════════════
echo ""
echo -e "${GREEN}══════════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}✅ Slash commands créés dans .claude/commands/${NC}"
echo -e "${GREEN}══════════════════════════════════════════════════════════════${NC}"
echo ""
echo "Commands disponibles :"
echo "  /context  - Charger le contexte complet"
echo "  /task     - Créer une nouvelle tâche"
echo "  /plan     - Planifier (auto-détection simple/complexe)"
echo "  /spec     - Créer une spec OpenSpec directement"
echo "  /work     - Travailler sur une tâche"
echo "  /done     - Terminer la session"
echo "  /ship     - Livrer (tests + commit + push)"
echo ""
echo "Usage dans Claude Code CLI :"
echo "  claude"
echo "  /context"
