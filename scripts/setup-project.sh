#!/bin/bash

# ══════════════════════════════════════════════════════════════════
# setup-project.sh
# Initialisation complète d'un projet avec :
# - Backlog.md (gestion des tâches)
# - OpenSpec (spécifications formelles)
# - CLAUDE.md (contexte persistant)
# - Slash commands
# ══════════════════════════════════════════════════════════════════

set -e

# Couleurs
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

PROJECT_NAME="${1:-$(basename $(pwd))}"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo -e "${BLUE}══════════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}   INITIALISATION PROJET : $PROJECT_NAME                       ${NC}"
echo -e "${BLUE}══════════════════════════════════════════════════════════════${NC}"
echo ""

# ══════════════════════════════════════════════════════════════════
# Vérification des outils
# ══════════════════════════════════════════════════════════════════
echo -e "${YELLOW}🔍 Vérification des outils...${NC}"

MISSING_TOOLS=0

if ! command -v backlog &> /dev/null; then
    echo -e "${RED}   ❌ Backlog.md non installé${NC}"
    echo -e "      → Installer avec : npm i -g backlog.md"
    MISSING_TOOLS=1
else
    echo -e "${GREEN}   ✅ Backlog.md${NC}"
fi

if ! command -v openspec &> /dev/null; then
    echo -e "${RED}   ❌ OpenSpec non installé${NC}"
    echo -e "      → Installer avec : npm i -g openspec"
    MISSING_TOOLS=1
else
    echo -e "${GREEN}   ✅ OpenSpec${NC}"
fi

if [ $MISSING_TOOLS -eq 1 ]; then
    echo ""
    echo -e "${RED}Installer les outils manquants puis relancer ce script.${NC}"
    exit 1
fi

echo ""

# ══════════════════════════════════════════════════════════════════
# Étape 1 : Backlog.md
# ══════════════════════════════════════════════════════════════════
echo -e "${YELLOW}📋 Étape 1/4 : Initialisation Backlog.md...${NC}"
if [ ! -f "backlog.md" ]; then
    backlog init "$PROJECT_NAME" --defaults 2>/dev/null || backlog init "$PROJECT_NAME"
    echo -e "${GREEN}   ✅ Backlog.md initialisé${NC}"
else
    echo -e "${GREEN}   ✅ Backlog.md existe déjà${NC}"
fi
echo ""

# ══════════════════════════════════════════════════════════════════
# Étape 2 : OpenSpec
# ══════════════════════════════════════════════════════════════════
echo -e "${YELLOW}📝 Étape 2/4 : Initialisation OpenSpec...${NC}"
if [ ! -d "openspec" ]; then
    # Essayer avec les options non-interactives, sinon mode interactif
    openspec init --tools claude-code 2>/dev/null || openspec init
    echo -e "${GREEN}   ✅ OpenSpec initialisé${NC}"
else
    echo -e "${GREEN}   ✅ OpenSpec existe déjà${NC}"
fi
echo ""

# ══════════════════════════════════════════════════════════════════
# Étape 3 : CLAUDE.md
# ══════════════════════════════════════════════════════════════════
echo -e "${YELLOW}📄 Étape 3/4 : Création/Mise à jour CLAUDE.md...${NC}"

if [ -f "CLAUDE.md" ]; then
    echo -e "${YELLOW}   CLAUDE.md existe. Création d'une version enrichie...${NC}"
    
    # Backup
    BACKUP_FILE="CLAUDE.md.backup.$(date +%Y%m%d_%H%M%S)"
    cp CLAUDE.md "$BACKUP_FILE"
    echo -e "${GREEN}   📦 Backup créé : $BACKUP_FILE${NC}"
    
    # Vérifier si déjà enrichi (contient notre section)
    if grep -q "🤖 INSTRUCTIONS POUR CLAUDE" CLAUDE.md; then
        echo -e "${GREEN}   ✅ CLAUDE.md déjà enrichi avec nos sections${NC}"
    else
        # Appeler le script de fusion s'il existe
        if [ -f "$SCRIPT_DIR/merge-claude-md.sh" ]; then
            bash "$SCRIPT_DIR/merge-claude-md.sh" CLAUDE.md CLAUDE.md
        else
            echo -e "${YELLOW}   ⚠️ Script merge-claude-md.sh non trouvé${NC}"
            echo -e "${YELLOW}   → Ajout manuel des sections nécessaire${NC}"
        fi
    fi
else
    # Créer un CLAUDE.md de base complet
    cat > CLAUDE.md << CLAUDEMD
# $PROJECT_NAME

> Description du projet à compléter

---

## 🤖 INSTRUCTIONS POUR CLAUDE

> ⚠️ **LIRE EN PREMIER** à chaque session Claude Code CLI

### Protocole de Session

**AU DÉMARRAGE :**
1. ✅ Lire ce fichier (CLAUDE.md)
2. ✅ Lire \`backlog.md\` pour les tâches en cours
3. ✅ Lire \`openspec/project.md\` pour les conventions (si existe)
4. ✅ Exécuter \`backlog board view\` pour voir le Kanban
5. ✅ Exécuter \`openspec list\` pour voir les specs actives
6. ✅ Confirmer la compréhension et demander "On continue sur quoi ?"

**SI PERTE DE CONTEXTE :**
1. 🚨 Signaler : "Je dois relire le contexte"
2. 🚨 Relire CLAUDE.md + backlog.md + openspec/project.md
3. 🚨 Reprendre sans demander de répéter

**AVANT FIN DE SESSION :**
1. 📝 Mettre à jour les tâches Backlog
2. 📝 Archiver les specs OpenSpec complétées
3. 📝 Mettre à jour "État du Projet" dans ce fichier

### Principes d'Implémentation

**OBLIGATOIRE :**
- ✅ Code COMPLET et fonctionnel uniquement
- ✅ Gestion d'erreurs exhaustive
- ✅ Validation des inputs
- ✅ Suivre les specs OpenSpec si elles existent
- ✅ Prêt pour production dès le premier jet

**INTERDIT :**
- ❌ Mocks, stubs, TODOs, placeholders
- ❌ "Dans une implémentation complète..."
- ❌ "Vous devriez ajouter..."
- ❌ Validation sociale : "Excellente question !"
- ❌ Langage flou : "pourrait", "peut-être"
- ❌ Implémenter une feature complexe sans spec

### Modes Dynamiques

- **EXPLORATION** (requirements flous) → Analyse, clarification, créer tâches
- **IMPLÉMENTATION** (specs claires) → Code direct, tests, error handling
- **DEBUG** (erreurs) → Isolation, root cause, solutions multiples
- **OPTIMISATION** (performance) → Bottlenecks, mesures, spec avec métriques

### Workflow de Planification

| Complexité | Critères | Action |
|------------|----------|--------|
**PLAN RAPIDE** (aucun critère OpenSpec) :
- Bug fix isolé, refactoring, utilitaire simple, documentation

**OPENSPEC** (au moins 1 critère) :
- Nouveau comportement utilisateur, changement archi, impact multi-features, intégration externe, modification API

### Commandes Essentielles

\`\`\`bash
# Backlog.md
backlog board view
backlog task create "Description"
backlog task start <id>
backlog task move <id> done

# OpenSpec
openspec list
openspec show <n>
openspec archive <n>
\`\`\`

---

## 🏗️ Architecture

### Stack Technique

> ⚠️ À compléter avec ClaudeForge ou manuellement

- **Frontend** : [Technologies]
- **Backend** : [Technologies]
- **Database** : [Technologies]
- **Infra** : [Technologies]

### Commandes

\`\`\`bash
# Dev
[À compléter]

# Build
[À compléter]

# Tests
[À compléter]
\`\`\`

### Structure de Fichiers

\`\`\`
[À compléter]
\`\`\`

### Patterns & Conventions

[À compléter]

---

## 📊 État du Projet

**Dernière MAJ :** $(date +%Y-%m-%d)

| Statut | Élément |
|--------|---------|
| ✅ | [À compléter] |
| 🚧 | [À compléter] |
| ❌ | [À compléter] |

> 📋 **Tâches** : \`backlog board view\`
> 📝 **Specs** : \`openspec list\`

---

## 🔑 Décisions Techniques

| Date | Décision | Pourquoi |
|------|----------|----------|
| | | |

---

*CLAUDE.md = Vue d'ensemble + Instructions*
*backlog.md = Tâches détaillées*
*openspec/specs/ = Spécifications formelles*
CLAUDEMD

    echo -e "${GREEN}   ✅ CLAUDE.md créé${NC}"
fi
echo ""

# ══════════════════════════════════════════════════════════════════
# Étape 4 : Slash commands
# ══════════════════════════════════════════════════════════════════
echo -e "${YELLOW}⚡ Étape 4/4 : Création des slash commands...${NC}"

# Créer le dossier
mkdir -p .claude/commands

# /context
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

# /task
cat > .claude/commands/task.md << 'EOF'
Créer une nouvelle tâche.

1. Demander la description si pas précisée
2. Créer la tâche : `backlog task create "[description]"`
3. Demander si on doit planifier : "Tâche créée. Tu veux que je planifie avec /plan ?"
EOF

# /plan
cat > .claude/commands/plan.md << 'EOF'
Planifier avant d'implémenter.

## Étape 1 : Évaluer la complexité

- Nombre de fichiers impactés ?
- Nouveau comportement utilisateur ?
- Changement d'architecture ?
- Impact sur d'autres features ?

**AU MOINS 1 CRITÈRE OPENSPEC ?**
- Nouveau comportement utilisateur visible
- Changement d'architecture ou patterns
- Impact sur plusieurs features
- Intégration système externe
- Modification d'API / contrat

**→ OUI → OpenSpec**
**→ NON → Plan rapide** (bug fix, refactoring, utilitaire, docs)

## Étape 2A : Critère OpenSpec détecté → Spec formelle

1. `openspec proposal "[Feature]"`
2. Générer specs avec critères d'acceptation
3. Valider avec l'utilisateur
4. `backlog task create "[Feature] - Voir openspec/changes/[name]/"`

## Étape 2B : Aucun critère → Plan rapide

1. Lire fichiers concernés (NE PAS coder)
2. Analyser : Faisabilité, Edge cases, Performance, Intégration
3. Plan en étapes numérotées
4. Valider

## Étape 3 : Validation

"Le plan te convient ? Je peux implémenter ?"
NE JAMAIS implémenter sans validation.
EOF

# /spec
cat > .claude/commands/spec.md << 'EOF'
Créer une spécification OpenSpec.

1. `openspec proposal "[Feature]"`
2. Générer :
   - proposal.md (contexte, objectifs)
   - tasks.md (tâches d'implémentation)
   - specs/*.md (comportement, critères, scénarios)
3. `openspec validate [name]`
4. Présenter pour review
EOF

# /work
cat > .claude/commands/work.md << 'EOF'
Travailler sur une tâche.

1. Identifier la tâche
2. Vérifier spec OpenSpec : `openspec list`
3. Démarrer : `backlog task start <id>`
4. Implémenter selon spec ou plan
5. Code complet, pas de placeholders
6. Mettre à jour avec notes
7. `backlog task move <id> review`
EOF

# /done
cat > .claude/commands/done.md << 'EOF'
Terminer une session.

1. Mettre à jour tâches Backlog
2. Archiver specs complétées : `openspec archive <n>`
3. Mettre à jour "État du Projet" dans CLAUDE.md
4. Résumer : tâches complétées, en cours, prochaines priorités
EOF

# /ship
cat > .claude/commands/ship.md << 'EOF'
Livrer les changements.

1. Vérifier tâches et specs terminées
2. Tests avec couverture
3. Si OK :
   - Linter + fix
   - `openspec archive <n>`
   - `backlog task move <id> done`
   - Git commit avec références
   - Push
4. Si échec : créer tâche bug, afficher erreurs
EOF

echo -e "${GREEN}   ✅ Slash commands créés${NC}"
echo ""

# ══════════════════════════════════════════════════════════════════
# Résumé
# ══════════════════════════════════════════════════════════════════
echo -e "${BLUE}══════════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}✅ INITIALISATION TERMINÉE !${NC}"
echo -e "${BLUE}══════════════════════════════════════════════════════════════${NC}"
echo ""
echo "Structure créée :"
echo "  📄 CLAUDE.md            - Instructions + État global"
echo "  📋 backlog.md           - Liste des tâches"
echo "  📁 backlog/             - Fichiers de tâches détaillés"
echo "  📁 openspec/            - Spécifications formelles"
echo "  📁 .claude/commands/    - Slash commands"
echo ""
echo "Slash commands disponibles :"
echo "  /context  - Charger le contexte complet"
echo "  /task     - Créer une tâche"
echo "  /plan     - Planifier (auto simple/complexe)"
echo "  /spec     - Créer une spec OpenSpec"
echo "  /work     - Travailler sur une tâche"
echo "  /done     - Terminer la session"
echo "  /ship     - Livrer (tests + commit)"
echo ""
echo "Prochaines étapes :"
echo "  1. Compléter CLAUDE.md avec ta stack technique"
echo "     (utiliser ClaudeForge puis ./merge-claude-md.sh)"
echo "  2. Lancer Claude Code : claude"
echo "  3. Première commande : /context"
echo ""
echo -e "${GREEN}Happy coding! 🚀${NC}"
