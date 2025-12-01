#!/bin/bash

# ══════════════════════════════════════════════════════════════════
# merge-claude-md.sh
# Fusionne ClaudeForge + Sections de contexte persistant + OpenSpec
# ══════════════════════════════════════════════════════════════════

set -e

# Couleurs
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Fichiers
CLAUDEFORGE_OUTPUT="${1:-CLAUDE.md}"
OUTPUT_FILE="${2:-CLAUDE.md}"
BACKUP_FILE="CLAUDE.md.backup.$(date +%Y%m%d_%H%M%S)"

echo -e "${BLUE}══════════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}   FUSION CLAUDE.md : ClaudeForge + Contexte Persistant       ${NC}"
echo -e "${BLUE}══════════════════════════════════════════════════════════════${NC}"

# Vérifier que le fichier ClaudeForge existe
if [ ! -f "$CLAUDEFORGE_OUTPUT" ]; then
    echo -e "${RED}❌ Fichier $CLAUDEFORGE_OUTPUT non trouvé${NC}"
    echo -e "${YELLOW}Usage: ./merge-claude-md.sh [fichier_claudeforge] [fichier_sortie]${NC}"
    exit 1
fi

# Backup
echo -e "${YELLOW}📦 Sauvegarde de l'original → $BACKUP_FILE${NC}"
cp "$CLAUDEFORGE_OUTPUT" "$BACKUP_FILE"

# Extraire le titre du projet (première ligne commençant par #)
PROJECT_TITLE=$(grep -m1 "^# " "$CLAUDEFORGE_OUTPUT" || echo "# Mon Projet")

# Extraire les lignes de métadonnées après le titre (lignes **key**: value ou ligne vide)
PROJECT_META=$(awk '
    /^# / { found_title = 1; next }
    found_title && /^\*\*.*\*\*:/ { print; next }
    found_title && /^$/ && !seen_empty { seen_empty = 1; print; next }
    found_title && /^---/ { exit }
    found_title && seen_empty { exit }
' "$CLAUDEFORGE_OUTPUT")

echo -e "${GREEN}📝 Projet détecté : $PROJECT_TITLE${NC}"

# Extraire le contenu technique de ClaudeForge
# On garde tout à partir du premier --- ou du premier ##
CLAUDEFORGE_CONTENT=$(awk '
    BEGIN { content_started = 0 }
    /^---/ && !content_started { content_started = 1; next }
    /^## / && !content_started { content_started = 1 }
    content_started { print }
' "$CLAUDEFORGE_OUTPUT")

# Créer le fichier fusionné avec le titre et les métadonnées
echo "$PROJECT_TITLE" > "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"
if [ -n "$PROJECT_META" ]; then
    echo "$PROJECT_META" >> "$OUTPUT_FILE"
fi

# PARTIE A : Instructions Claude
cat >> "$OUTPUT_FILE" << 'PART_A'

---

## 🤖 INSTRUCTIONS POUR CLAUDE

> ⚠️ **LIRE EN PREMIER** à chaque session Claude Code CLI

### Protocole de Session

**AU DÉMARRAGE :**
1. ✅ Lire ce fichier (CLAUDE.md)
2. ✅ Lire `backlog.md` pour les tâches en cours
3. ✅ Lire `openspec/project.md` pour les conventions (si existe)
4. ✅ Lire `component-catalog.yml` pour les composants réutilisables
5. ✅ Lire `docs-index.yml` pour la documentation existante
6. ✅ Exécuter `backlog board view` pour voir le Kanban
7. ✅ Exécuter `openspec list` pour voir les specs actives (si existe)
8. ✅ **Analyser avant d'agir** :
   - Vérifier `component-catalog.yml` : Un composant similaire existe-t-il ?
   - Vérifier `docs-index.yml` : Une doc sur ce sujet existe-t-elle ?
   - **PRINCIPE : Réutiliser > Créer**
9. ✅ Confirmer la compréhension et demander "On continue sur quoi ?"

**RÈGLES ANTI-DUPLICATION :**
- ❌ NE PAS créer de documentation redondante
- ✅ TOUJOURS consulter `component-catalog.yml` avant de créer un nouveau composant
- ✅ TOUJOURS consulter `docs-index.yml` avant de créer une nouvelle documentation

**SI PERTE DE CONTEXTE :**
1. 🚨 Signaler : "Je dois relire le contexte"
2. 🚨 Relire CLAUDE.md + backlog.md + openspec/project.md + component-catalog.yml + docs-index.yml
3. 🚨 Reprendre sans demander de répéter

**AVANT FIN DE SESSION :**
1. 📝 Mettre à jour les tâches Backlog
2. 📝 Archiver les specs OpenSpec complétées
3. 📝 Mettre à jour "État du Projet" dans ce fichier
4. 📝 Mettre à jour `component-catalog.yml` si nouveau composant créé
5. 📝 Mettre à jour `docs-index.yml` si nouvelle documentation créée
6. 📝 Ajouter DA-XXX dans README.md si décision architecturale prise

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

**PLAN RAPIDE** (aucun critère OpenSpec) :
- Bug fix isolé, refactoring, utilitaire simple, documentation

**OPENSPEC** (au moins 1 critère) :
- Nouveau comportement utilisateur visible
- Changement d'architecture ou patterns
- Impact sur plusieurs features
- Intégration système externe
- Modification d'API / contrat

### Commandes Essentielles

```bash
# Backlog.md
backlog board view
backlog task create "Description"
backlog task start <id>
backlog task move <id> done

# OpenSpec (features complexes)
openspec list
openspec show <n>
openspec archive <n>
```

---

PART_A

# PARTIE B : Contenu ClaudeForge
echo "" >> "$OUTPUT_FILE"
echo "$CLAUDEFORGE_CONTENT" >> "$OUTPUT_FILE"

# PARTIE C : Suivi du projet
cat >> "$OUTPUT_FILE" << PART_C

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
PART_C

echo ""
echo -e "${GREEN}✅ Fusion terminée !${NC}"
echo -e "${GREEN}   → Fichier créé : $OUTPUT_FILE${NC}"
echo -e "${GREEN}   → Backup : $BACKUP_FILE${NC}"
echo ""
echo -e "${BLUE}Prochaines étapes :${NC}"
echo -e "  1. Vérifier le contenu de $OUTPUT_FILE"
echo -e "  2. Compléter la section 'État du Projet'"
echo -e "  3. Créer les slash commands : ./setup-commands.sh"
