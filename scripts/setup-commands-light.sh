#!/bin/bash

# ══════════════════════════════════════════════════════════════════
# setup-commands-light.sh
# Crée les slash commands SANS Backlog/OpenSpec (mode léger)
# Pour projets utilisant GitHub Issues ou autres outils externes
# ══════════════════════════════════════════════════════════════════

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo -e "${BLUE}══════════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE}   CRÉATION DES SLASH COMMANDS (MODE LÉGER)                   ${NC}"
echo -e "${BLUE}══════════════════════════════════════════════════════════════${NC}"
echo ""
echo -e "${YELLOW}Mode : SANS Backlog.md ni OpenSpec${NC}"
echo -e "${YELLOW}Workflow : /context → /plan → /doc → /done → /ship${NC}"
echo ""

# Créer le dossier
mkdir -p .claude/commands

# Copier les templates depuis le dossier templates/commands
if [ -d "$SCRIPT_DIR/../templates/commands" ]; then
    cp "$SCRIPT_DIR/../templates/commands/context.md" .claude/commands/
    echo "  ✅ /context (charge CLAUDE.md + YAML)"

    cp "$SCRIPT_DIR/../templates/commands/plan.md" .claude/commands/
    echo "  ✅ /plan (planification intelligente)"

    cp "$SCRIPT_DIR/../templates/commands/doc.md" .claude/commands/
    echo "  ✅ /doc (créer doc Divio)"

    cp "$SCRIPT_DIR/../templates/commands/done.md" .claude/commands/
    echo "  ✅ /done (finalisation session)"

    cp "$SCRIPT_DIR/../templates/commands/ship.md" .claude/commands/
    echo "  ✅ /ship (tests + commit + push)"
else
    echo -e "${YELLOW}⚠️  Templates non trouvés dans $SCRIPT_DIR/../templates/commands${NC}"
    echo -e "${YELLOW}    Création inline...${NC}"

    # Fallback : créer inline si templates manquants
    cat > .claude/commands/context.md << 'EOF'
Charger le contexte complet du projet :

1. Lire CLAUDE.md (état du projet + instructions)
2. Lire component-catalog.yml (composants réutilisables)
3. Lire docs-index.yml (documentation Divio existante)
4. Résumer :
   - État actuel du projet
   - Composants disponibles
   - Documentation existante
   - Problèmes bloquants
5. Demander "On continue sur quoi ?"
EOF
    echo "  ✅ /context"

    # Les autres commandes seraient créées inline ici aussi...
fi

echo ""
echo -e "${GREEN}══════════════════════════════════════════════════════════════${NC}"
echo -e "${GREEN}✅ Slash commands créés dans .claude/commands/ (mode léger)${NC}"
echo -e "${GREEN}══════════════════════════════════════════════════════════════${NC}"
echo ""
echo "Commands disponibles :"
echo "  /context  - Charger CLAUDE.md + component-catalog.yml + docs-index.yml"
echo "  /plan     - Planifier avec analyse complexité (doc Divio si besoin)"
echo "  /doc      - Créer doc Divio (4 blocs obligatoires)"
echo "  /done     - Terminer session (màj CLAUDE.md + YAML)"
echo "  /ship     - Livrer (tests + commit + push)"
echo ""
echo "⚠️  Ce mode N'UTILISE PAS Backlog.md ni OpenSpec"
echo "   Utilisez GitHub Issues ou votre outil de gestion externe"
echo ""
