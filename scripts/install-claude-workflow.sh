#!/bin/bash

# ══════════════════════════════════════════════════════════════════
# install-claude-workflow.sh
# Installation COMPLÈTE du workflow Claude avec état des lieux du projet
#
# Installe :
# - ClaudeForge (analyse codebase + génération CLAUDE.md)
# - Backlog.md (gestion des tâches)
# - OpenSpec (spécifications formelles)
# - Slash commands personnalisés
# ══════════════════════════════════════════════════════════════════

set -e

# Couleurs
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TARGET_DIR="${1:-.}"

# ══════════════════════════════════════════════════════════════════
# Fonctions utilitaires
# ══════════════════════════════════════════════════════════════════

check_command() {
    command -v "$1" &> /dev/null
}

install_node_tool() {
    local tool=$1
    local package=$2
    echo -e "${CYAN}   📦 Installation de $tool...${NC}"
    npm install -g "$package" || {
        echo -e "${RED}   ❌ Échec installation $tool${NC}"
        echo -e "${YELLOW}   → Essayer avec: sudo npm install -g $package${NC}"
        return 1
    }
    echo -e "${GREEN}   ✅ $tool installé${NC}"
}

# ══════════════════════════════════════════════════════════════════
# En-tête
# ══════════════════════════════════════════════════════════════════

cat << "EOF"
╔════════════════════════════════════════════════════════════════╗
║                                                                ║
║     INSTALLATION WORKFLOW CLAUDE - ÉTAT DES LIEUX COMPLET      ║
║                                                                ║
║  • ClaudeForge  → Analyse codebase + CLAUDE.md technique      ║
║  • Backlog.md   → Gestion des tâches                           ║
║  • OpenSpec     → Spécifications formelles                     ║
║  • Commands     → 7 slash commands personnalisés               ║
║                                                                ║
╚════════════════════════════════════════════════════════════════╝
EOF

echo ""
echo -e "${BLUE}📂 Projet cible : $TARGET_DIR${NC}"
echo ""

# Validation
if [ ! -d "$TARGET_DIR" ]; then
    echo -e "${RED}❌ Le répertoire $TARGET_DIR n'existe pas${NC}"
    exit 1
fi

# ══════════════════════════════════════════════════════════════════
# Choix du mode d'installation
# ══════════════════════════════════════════════════════════════════

echo -e "${CYAN}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${CYAN} CHOIX DU MODE                                                  ${NC}"
echo -e "${CYAN}═══════════════════════════════════════════════════════════════${NC}"
echo ""
echo "Deux modes disponibles :"
echo ""
echo -e "${GREEN}1. Mode COMPLET (défaut)${NC}"
echo "   ✅ ClaudeForge + Backlog.md + OpenSpec"
echo "   ✅ Gestion tâches Kanban intégrée"
echo "   ✅ Specs formelles Divio"
echo "   ✅ Workflow : /context → /task → /plan → /spec → /work → /done → /ship"
echo ""
echo -e "${YELLOW}2. Mode LÉGER${NC}"
echo "   ✅ ClaudeForge uniquement"
echo "   ✅ YAML files (component-catalog.yml, docs-index.yml)"
echo "   ✅ Utilise GitHub Issues ou outil externe pour tâches"
echo "   ✅ Workflow : /context → /plan → /doc → /done → /ship"
echo ""
read -p "Choisir le mode (1 ou 2) [défaut: 1]: " MODE_CHOICE
MODE_CHOICE=${MODE_CHOICE:-1}

if [ "$MODE_CHOICE" = "2" ]; then
    INSTALL_MODE="light"
    echo -e "${YELLOW}📦 Mode LÉGER sélectionné${NC}"
else
    INSTALL_MODE="full"
    echo -e "${GREEN}📦 Mode COMPLET sélectionné${NC}"
fi
echo ""

# ══════════════════════════════════════════════════════════════════
# PHASE 0 : Vérification Node.js/npm
# ══════════════════════════════════════════════════════════════════

echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE} PHASE 0 : Vérification des prérequis                          ${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo ""

if ! check_command node; then
    echo -e "${RED}❌ Node.js non installé${NC}"
    echo -e "${YELLOW}→ Installer Node.js depuis https://nodejs.org/${NC}"
    exit 1
fi

if ! check_command npm; then
    echo -e "${RED}❌ npm non installé${NC}"
    echo -e "${YELLOW}→ npm devrait être installé avec Node.js${NC}"
    exit 1
fi

NODE_VERSION=$(node --version)
NPM_VERSION=$(npm --version)
echo -e "${GREEN}✅ Node.js $NODE_VERSION${NC}"
echo -e "${GREEN}✅ npm $NPM_VERSION${NC}"
echo ""

# ══════════════════════════════════════════════════════════════════
# PHASE 1 : Installation ClaudeForge
# ══════════════════════════════════════════════════════════════════

echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE} PHASE 1 : Installation ClaudeForge (analyse codebase)         ${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo ""

CLAUDEFORGE_DIR="$HOME/.claudeforge"

if [ -d "$CLAUDEFORGE_DIR" ]; then
    echo -e "${GREEN}✅ ClaudeForge déjà cloné dans $CLAUDEFORGE_DIR${NC}"
else
    echo -e "${CYAN}📥 Clonage de ClaudeForge...${NC}"
    git clone https://github.com/alirezarezvani/ClaudeForge.git "$CLAUDEFORGE_DIR" || {
        echo -e "${RED}❌ Échec du clonage de ClaudeForge${NC}"
        exit 1
    }
    echo -e "${GREEN}✅ ClaudeForge cloné${NC}"
fi

# Installer ClaudeForge manuellement (install.sh est interactif, on fait l'équivalent)
echo -e "${CYAN}🔧 Installation du command /enhance-claude-md...${NC}"

# Créer les répertoires Claude Code
mkdir -p "$HOME/.claude/skills" "$HOME/.claude/commands" "$HOME/.claude/agents"

# Copier les composants ClaudeForge (user-level pour tous les projets)
if [ -d "$CLAUDEFORGE_DIR/skill" ] && [ -d "$CLAUDEFORGE_DIR/command" ] && [ -d "$CLAUDEFORGE_DIR/agent" ]; then
    # Sauvegarder si déjà installé
    if [ -d "$HOME/.claude/skills/claudeforge-skill" ]; then
        echo -e "${YELLOW}⚠️  ClaudeForge déjà installé, création backup...${NC}"
        mv "$HOME/.claude/skills/claudeforge-skill" "$HOME/.claude/skills/claudeforge-skill.backup.$(date +%Y%m%d_%H%M%S)" 2>/dev/null || true
        mv "$HOME/.claude/commands/enhance-claude-md" "$HOME/.claude/commands/enhance-claude-md.backup.$(date +%Y%m%d_%H%M%S)" 2>/dev/null || true
        mv "$HOME/.claude/agents/claude-md-guardian.md" "$HOME/.claude/agents/claude-md-guardian.md.backup.$(date +%Y%m%d_%H%M%S)" 2>/dev/null || true
    fi

    # Copier les composants
    cp -r "$CLAUDEFORGE_DIR/skill" "$HOME/.claude/skills/claudeforge-skill"
    cp -r "$CLAUDEFORGE_DIR/command" "$HOME/.claude/commands/enhance-claude-md"
    cp "$CLAUDEFORGE_DIR/agent/claude-md-guardian.md" "$HOME/.claude/agents/"

    echo -e "${GREEN}✅ ClaudeForge installé (user-level)${NC}"
    echo -e "${GREEN}   → Skill: ~/.claude/skills/claudeforge-skill/${NC}"
    echo -e "${GREEN}   → Command: /enhance-claude-md${NC}"
    echo -e "${GREEN}   → Agent: claude-md-guardian${NC}"
else
    echo -e "${RED}❌ Composants ClaudeForge introuvables${NC}"
    echo -e "${YELLOW}   Répertoire ClaudeForge incomplet ou corrompu${NC}"
fi

echo ""

# ══════════════════════════════════════════════════════════════════
# PHASE 2 : Installation Backlog.md (si mode COMPLET)
# ══════════════════════════════════════════════════════════════════

if [ "$INSTALL_MODE" = "full" ]; then
    echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE} PHASE 2 : Installation Backlog.md (gestion des tâches)        ${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
    echo ""

    if check_command backlog; then
        BACKLOG_VERSION=$(backlog --version 2>/dev/null || echo "installé")
        echo -e "${GREEN}✅ Backlog.md déjà installé ($BACKLOG_VERSION)${NC}"
    else
        install_node_tool "Backlog.md" "backlog.md"
    fi

    echo ""
else
    echo -e "${YELLOW}⏭️  PHASE 2 SKIPPED : Backlog.md (mode léger)${NC}"
    echo ""
fi

# ══════════════════════════════════════════════════════════════════
# PHASE 3 : Installation OpenSpec (si mode COMPLET)
# ══════════════════════════════════════════════════════════════════

if [ "$INSTALL_MODE" = "full" ]; then
    echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE} PHASE 3 : Installation OpenSpec (spécifications)              ${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
    echo ""

    if check_command openspec; then
        OPENSPEC_VERSION=$(openspec --version 2>/dev/null || echo "installé")
        echo -e "${GREEN}✅ OpenSpec déjà installé ($OPENSPEC_VERSION)${NC}"
    else
        install_node_tool "OpenSpec" "openspec"
    fi

    echo ""
else
    echo -e "${YELLOW}⏭️  PHASE 3 SKIPPED : OpenSpec (mode léger)${NC}"
    echo ""
fi

# ══════════════════════════════════════════════════════════════════
# PHASE 4 : Copie des scripts du workflow
# ══════════════════════════════════════════════════════════════════

echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE} PHASE 4 : Copie des scripts du workflow                       ${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo ""

SCRIPTS=(
    "setup-project.sh"
    "setup-commands.sh"
    "setup-commands-light.sh"
    "merge-claude-md.sh"
)

for script in "${SCRIPTS[@]}"; do
    if [ -f "$SCRIPT_DIR/$script" ]; then
        cp "$SCRIPT_DIR/$script" "$TARGET_DIR/"
        chmod +x "$TARGET_DIR/$script" 2>/dev/null || true
        echo -e "${GREEN}   ✅ $script${NC}"
    else
        echo -e "${RED}   ❌ $script non trouvé${NC}"
        exit 1
    fi
done

# Copier .gitignore.claude
if [ -f "$SCRIPT_DIR/.gitignore.claude" ]; then
    cp "$SCRIPT_DIR/.gitignore.claude" "$TARGET_DIR/"
    echo -e "${GREEN}   ✅ .gitignore.claude${NC}"
fi

echo ""

# ══════════════════════════════════════════════════════════════════
# PHASE 5 : Préparation pour ClaudeForge (étape manuelle)
# ══════════════════════════════════════════════════════════════════

echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE} PHASE 5 : Préparation CLAUDE.md (ClaudeForge)                 ${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo ""

cd "$TARGET_DIR"

if [ -f "CLAUDE.md" ]; then
    echo -e "${GREEN}✅ CLAUDE.md existe déjà${NC}"
    echo -e "${CYAN}💡 Pour l'enrichir avec analyse technique de ClaudeForge :${NC}"
    echo -e "${YELLOW}   1. Lancer: claude${NC}"
    echo -e "${YELLOW}   2. Exécuter: /enhance-claude-md${NC}"
    echo -e "${YELLOW}   3. Puis enrichir avec: ./merge-claude-md.sh${NC}"
else
    echo -e "${YELLOW}⚠️  CLAUDE.md n'existe pas encore${NC}"
    echo -e "${CYAN}💡 Pour créer un CLAUDE.md complet avec analyse :${NC}"
    echo -e "${YELLOW}   1. Lancer: claude${NC}"
    echo -e "${YELLOW}   2. Exécuter: /enhance-claude-md${NC}"
    echo -e "${YELLOW}   3. Suivre les instructions interactives${NC}"
    echo -e "${YELLOW}   4. Puis enrichir avec: ./merge-claude-md.sh${NC}"
fi

echo ""
echo -e "${CYAN}📝 Note:${NC} ClaudeForge analyse votre codebase et génère"
echo -e "   un CLAUDE.md technique avec stack, architecture et patterns."
echo ""

# ══════════════════════════════════════════════════════════════════
# PHASE 6 : Initialisation Backlog.md et OpenSpec
# ══════════════════════════════════════════════════════════════════

echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE} PHASE 6 : Initialisation Backlog.md et OpenSpec               ${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo ""

PROJECT_NAME=$(basename "$TARGET_DIR")

# Backlog.md
if [ ! -f "backlog.md" ] && [ ! -d "backlog" ]; then
    echo -e "${CYAN}📋 Initialisation Backlog.md...${NC}"
    backlog init "$PROJECT_NAME" --defaults 2>/dev/null || backlog init "$PROJECT_NAME" || {
        echo -e "${YELLOW}⚠️  Erreur init Backlog.md${NC}"
    }
    echo -e "${GREEN}✅ Backlog.md initialisé${NC}"
else
    echo -e "${GREEN}✅ Backlog.md existe déjà (préservé)${NC}"
fi

# OpenSpec
if [ ! -d "openspec" ]; then
    echo -e "${CYAN}📝 Initialisation OpenSpec...${NC}"
    openspec init --tools claude-code 2>/dev/null || openspec init || {
        echo -e "${YELLOW}⚠️  Erreur init OpenSpec${NC}"
    }
    echo -e "${GREEN}✅ OpenSpec initialisé${NC}"
else
    echo -e "${GREEN}✅ OpenSpec existe déjà (préservé)${NC}"
fi

echo ""

# ══════════════════════════════════════════════════════════════════
# PHASE 7 : Création des slash commands
# ══════════════════════════════════════════════════════════════════

echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE} PHASE 7 : Création des slash commands                         ${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo ""

if [ "$INSTALL_MODE" = "light" ]; then
    # Mode léger : copier templates depuis templates/commands
    mkdir -p "$TARGET_DIR/.claude/commands"

    if [ -d "$SCRIPT_DIR/../templates/commands" ]; then
        cp "$SCRIPT_DIR/../templates/commands"/*.md "$TARGET_DIR/.claude/commands/" 2>/dev/null || {
            echo -e "${YELLOW}⚠️  Templates commands non trouvés, utilisation du script de fallback${NC}"
            bash "$TARGET_DIR/setup-commands-light.sh" || true
        }
        echo -e "${GREEN}✅ Slash commands copiés (mode léger)${NC}"
        echo "   Commands: /context, /plan, /doc, /done, /ship"
    else
        echo -e "${YELLOW}⚠️  Dossier templates/commands non trouvé${NC}"
        bash "$TARGET_DIR/setup-commands-light.sh" || true
    fi
else
    # Mode complet : utiliser le script classique
    bash "$TARGET_DIR/setup-commands.sh" || {
        echo -e "${YELLOW}⚠️  Erreur création des commands${NC}"
    }
fi

echo ""

# ══════════════════════════════════════════════════════════════════
# PHASE 8 : Initialisation Documents Structurants (YAML)
# ══════════════════════════════════════════════════════════════════

echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE} PHASE 8 : Initialisation Documents Structurants (YAML)        ${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo ""

echo -e "${CYAN}📄 Copie templates YAML optimisés...${NC}"

# docs-index.yml
if [ ! -f "docs-index.yml" ]; then
    if [ -f "$SCRIPT_DIR/../templates/docs-index.yml" ]; then
        cp "$SCRIPT_DIR/../templates/docs-index.yml" "docs-index.yml"
        echo -e "${GREEN}   ✅ docs-index.yml créé (format machine-readable)${NC}"
    else
        echo -e "${YELLOW}   ⚠️  Template docs-index.yml non trouvé${NC}"
    fi
else
    echo -e "${GREEN}   ✅ docs-index.yml existe déjà (préservé)${NC}"
fi

# component-catalog.yml
if [ ! -f "component-catalog.yml" ]; then
    if [ -f "$SCRIPT_DIR/../templates/component-catalog.yml" ]; then
        cp "$SCRIPT_DIR/../templates/component-catalog.yml" "component-catalog.yml"
        echo -e "${GREEN}   ✅ component-catalog.yml créé (format machine-readable)${NC}"
    else
        echo -e "${YELLOW}   ⚠️  Template component-catalog.yml non trouvé${NC}"
    fi
else
    echo -e "${GREEN}   ✅ component-catalog.yml existe déjà (préservé)${NC}"
fi

echo ""
echo -e "${CYAN}💡 Ces fichiers YAML sont chargés au démarrage Claude (~140 tokens)${NC}"
echo -e "${CYAN}   • component-catalog.yml : Composants réutilisables${NC}"
echo -e "${CYAN}   • docs-index.yml : Index documentation Divio${NC}"
echo -e "${CYAN}   → Évite duplication en consultant l'existant avant création${NC}"
echo ""

# ══════════════════════════════════════════════════════════════════
# PHASE 9 : État des lieux final
# ══════════════════════════════════════════════════════════════════

echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${BLUE} PHASE 9 : État des lieux du projet                            ${NC}"
echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
echo ""

echo -e "${CYAN}📊 Génération de l'état des lieux...${NC}"
echo ""

# Compter les fichiers
FILE_COUNT=$(find . -type f 2>/dev/null | wc -l)
DIR_COUNT=$(find . -type d 2>/dev/null | wc -l)

# Langages détectés
echo "🔍 Analyse du projet :"
echo "   • Fichiers : $FILE_COUNT"
echo "   • Dossiers : $DIR_COUNT"

if [ -f "package.json" ]; then
    echo "   • Type : Projet Node.js/JavaScript"
fi
if [ -f "requirements.txt" ] || [ -f "setup.py" ] || [ -f "pyproject.toml" ]; then
    echo "   • Type : Projet Python"
fi
if [ -f "Cargo.toml" ]; then
    echo "   • Type : Projet Rust"
fi
if [ -f "go.mod" ]; then
    echo "   • Type : Projet Go"
fi

echo ""

# Résumé des outils installés
echo "📦 Outils installés et configurés :"
echo "   ✅ ClaudeForge ($CLAUDEFORGE_DIR)"
echo "   ✅ Backlog.md ($(command -v backlog))"
echo "   ✅ OpenSpec ($(command -v openspec))"
echo ""

echo "📄 Fichiers créés :"
echo "   ✅ CLAUDE.md (état de la codebase)"
echo "   ✅ backlog.md + backlog/ (gestion des tâches)"
echo "   ✅ openspec/ (spécifications)"
echo "   ✅ .claude/commands/ (7+ slash commands)"
echo "   ✅ component-catalog.yml (composants réutilisables)"
echo "   ✅ docs-index.yml (index documentation Divio)"
echo ""

# ══════════════════════════════════════════════════════════════════
# RÉSUMÉ FINAL
# ══════════════════════════════════════════════════════════════════

cat << "EOF"
╔════════════════════════════════════════════════════════════════╗
║                                                                ║
║                  ✅ INSTALLATION TERMINÉE !                    ║
║                                                                ║
║     Votre projet dispose maintenant d'un état des lieux       ║
║              complet et d'un workflow optimisé                ║
║                                                                ║
╚════════════════════════════════════════════════════════════════╝
EOF

echo ""
echo -e "${BLUE}🎯 PROCHAINES ÉTAPES :${NC}"
echo ""
echo -e "${CYAN}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${CYAN} ÉTAPE A : Générer l'état des lieux avec ClaudeForge (IMPORTANT!)${NC}"
echo -e "${CYAN}═══════════════════════════════════════════════════════════════${NC}"
echo ""
echo "1️⃣  Lancer Claude Code :"
echo "   claude"
echo ""
echo "2️⃣  Générer/Enrichir CLAUDE.md avec analyse technique :"
echo "   /enhance-claude-md"
echo "   # Suivez les instructions interactives"
echo "   # ClaudeForge va analyser votre codebase complète"
echo ""
echo "3️⃣  (Optionnel) Enrichir avec nos sections :"
echo "   ./merge-claude-md.sh CLAUDE.md CLAUDE.md"
echo ""
echo -e "${CYAN}═══════════════════════════════════════════════════════════════${NC}"
echo -e "${CYAN} ÉTAPE B : Utiliser le workflow                                 ${NC}"
echo -e "${CYAN}═══════════════════════════════════════════════════════════════${NC}"
echo ""
echo "4️⃣  Charger le contexte complet :"
echo "   /context"
echo ""
echo "5️⃣  Consulter le Kanban des tâches :"
echo "   backlog board view"
echo "   # ou : backlog browser (interface web)"
echo ""
echo "6️⃣  Créer votre première tâche :"
echo "   /task \"Votre première tâche\""
echo ""
echo "7️⃣  Planifier avant d'implémenter :"
echo "   /plan"
echo ""
echo -e "${YELLOW}📋 VERSIONNEMENT GIT :${NC}"
echo ""
echo "À versionner (pour collaboration) :"
echo "   git add CLAUDE.md backlog.md backlog/ openspec/"
echo "   git add .claude/commands/ *.sh .gitignore"
echo "   git commit -m 'feat: Add Claude Code workflow with full project analysis'"
echo ""
echo -e "${GREEN}Documentation complète : workflow_final_complet_autoporteur.md${NC}"
echo ""
echo -e "${CYAN}Happy coding! 🚀${NC}"
echo ""
