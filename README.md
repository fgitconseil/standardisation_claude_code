# Workflow Claude Code - Standardisation Complète

> **Installation automatique** : ClaudeForge + Backlog.md + OpenSpec + Slash Commands
>
> Transforme n'importe quel projet en projet optimisé pour Claude Code avec un état des lieux complet de la codebase.

**Version**: 1.2.2 | **Last Updated**: 2025-12-02 | **Maintainers**: @fgitconseil

---

## 📑 Table des Matières

- [Quick Start (2 commandes!)](#-quick-start-2-commandes)
- [Architecture Complète](#-architecture-complète)
- [Installation Détaillée](#-installation-détaillée)
- [Composants du Workflow](#-composants-du-workflow)
- [Workflow en 5 Étapes](#-workflow-en-5-étapes)
- [7 Slash Commands](#-7-slash-commands-personnalisés)
- [Scripts Disponibles](#-scripts-disponibles)
- [Décisions Architecturales](#-décisions-architecturales)
- [Troubleshooting](#-troubleshooting)
- [Contribution](#-contribution)

---

## 🚀 Quick Start (2 commandes!)

### 1. Installation automatique

```bash
# Depuis n'importe où
bash /chemin/vers/standardisation_claude_code/scripts/install-claude-workflow.sh /chemin/vers/votre-projet
```

**Le script vous demandera de choisir un mode** :

#### Mode 1 : COMPLET (défaut)
- ✅ ClaudeForge + Backlog.md + OpenSpec
- ✅ Gestion tâches Kanban intégrée
- ✅ Specs formelles Divio
- ✅ Workflow : `/context` → `/task` → `/plan` → `/spec` → `/work` → `/done` → `/ship`

#### Mode 2 : LÉGER
- ✅ ClaudeForge uniquement
- ✅ YAML files (component-catalog.yml, docs-index.yml)
- ✅ Utilise GitHub Issues ou outil externe pour tâches
- ✅ Workflow : `/context` → `/plan` → `/doc` → `/done` → `/ship`

**Choisissez le Mode LÉGER si** :
- Vous utilisez déjà GitHub Issues, Jira, Linear, etc.
- Vous préférez une approche minimaliste
- Vous ne voulez pas installer de dépendances npm supplémentaires

**Choisissez le Mode COMPLET si** :
- Vous voulez une solution tout-en-un
- Vous aimez avoir un Kanban board en CLI
- Vous créez des features complexes nécessitant specs formelles

**Temps d'installation** : ~5-10 minutes (Mode COMPLET) | ~2-3 minutes (Mode LÉGER)

**💡 Recommandation** : Installez aussi [context7 MCP server](#-mcp-server-recommandé) pour avoir des docs de bibliothèques toujours à jour (évite les hallucinations d'API)

### 2. Générer l'état des lieux de votre projet

```bash
cd votre-projet
claude
/enhance-claude-md  # Lance l'analyse complète de la codebase par ClaudeForge
```

**ClaudeForge va** :
- 🔍 Analyser toute votre codebase (fichiers, structure, dépendances)
- 📊 Détecter stack technique, architecture, patterns utilisés
- 📝 Générer un CLAUDE.md complet avec toutes les informations

**Temps d'analyse** :
- Petit projet (< 100 fichiers) : 1-2 minutes
- Projet moyen (1k-10k fichiers) : 5-10 minutes
- Gros projet (> 50k fichiers) : 15-30 minutes

### 3. Enrichir avec le workflow standardisé

```bash
./merge-claude-md.sh CLAUDE.md CLAUDE.md
# Ajoute : Instructions pour Claude, Moyens (Backlog vanilla + OpenSpec), État du Projet
```

**Le script ajoute** :
- 🤖 Instructions pour Claude (Protocole de Session, Principes d'Implémentation)
- 🛠️ Moyens Disponibles (Backlog CLI + OpenSpec)
- 📊 Section "État du Projet" à compléter
- 🔑 Section "Décisions Techniques" à compléter

### 4. Utiliser le workflow

```bash
/context  # [AU DÉMARRAGE] Charger le contexte complet
/task "Nouvelle feature"
/plan     # Auto-détection simple/complexe
/work     # Implémenter
/done     # Fin de session
```

---

## 🏗️ Architecture Complète

### Architecture Unifiée : 2 Skills + 1 CLI

```
┌─────────────────────────────────────────────────────────────────┐
│              ARCHITECTURE UNIFIÉE SKILLS + CLI                  │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ClaudeForge (Skill)         # Gère CLAUDE.md                  │
│  ~/.claude/skills/claudeforge-skill/                           │
│  ✅ Intelligence contextuelle (analyse codebase)                │
│  ✅ Slash commands natifs (/enhance-claude-md)                 │
│                                                                 │
│  Specs Wrapper (Skill)       # Gère specs/docs Divio           │
│  ~/.claude/skills/specs-skill/                                 │
│  ✅ Intelligence contextuelle (lit CLAUDE.md)                   │
│  ✅ Slash commands natifs (/spec, /validate-spec)              │
│  ↓ appelle                                                      │
│  OpenSpec CLI (vanilla)      # Logique métier                  │
│  npm install -g openspec                                        │
│  ✅ Portabilité (CI/CD)                                         │
│  ✅ Maintenance externe (Fission-AI)                            │
│                                                                 │
│  Backlog.md (CLI vanilla)    # Gère tâches                    │
│  npm install -g backlog.md                                      │
│  ✅ Portabilité (CI/CD)                                         │
│  ✅ Maintenance externe                                         │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

**Philosophie** :
- **Skills** = Intelligence contextuelle + Intégration Claude Code
- **CLI vanilla** = Logique métier + Portabilité + Maintenance externe
- **Wrapper léger** = Meilleur des deux mondes

### Diagramme de Contexte

```
┌─────────────────────────────────────────────────────────────────┐
│                    CONTEXTE DU PROJET                           │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │                    CLAUDE.md                             │  │
│  │  ┌────────────────────────────────────────────────────┐  │  │
│  │  │ [AJOUTÉ par merge-claude-md.sh]                    │  │  │
│  │  │ • Instructions pour Claude                         │  │  │
│  │  │ • Protocole de Session                             │  │  │
│  │  │ • Principes d'Implémentation                       │  │  │
│  │  │ • Moyens: Backlog vanilla + OpenSpec              │  │  │
│  │  └────────────────────────────────────────────────────┘  │  │
│  │  ┌────────────────────────────────────────────────────┐  │  │
│  │  │ [GÉNÉRÉ par ClaudeForge]                           │  │  │
│  │  │ • Titre + Métadonnées                              │  │  │
│  │  │ • Stack technique détectée                         │  │  │
│  │  │ • Architecture du projet                           │  │  │
│  │  │ • Patterns identifiés                              │  │  │
│  │  │ • Commandes dev/build/test                         │  │  │
│  │  └────────────────────────────────────────────────────┘  │  │
│  │  ┌────────────────────────────────────────────────────┐  │  │
│  │  │ [AJOUTÉ par merge-claude-md.sh]                    │  │  │
│  │  │ • État du Projet (tableau statuts)                 │  │  │
│  │  │ • Décisions Techniques (historique)                │  │  │
│  │  └────────────────────────────────────────────────────┘  │  │
│  └──────────────────────────────────────────────────────────┘  │
│                              │                                  │
│              ┌───────────────┴───────────────┐                  │
│              ▼                               ▼                  │
│  ┌─────────────────────┐         ┌─────────────────────┐       │
│  │     Backlog.md      │         │      OpenSpec       │       │
│  │  (CLI vanilla)      │         │  (Specs formelles)  │       │
│  ├─────────────────────┤         ├─────────────────────┤       │
│  │ • Liste des tâches  │         │ • Context           │       │
│  │ • Kanban board      │         │ • Specs détaillées  │       │
│  │ • Statuts           │         │ • Acceptance        │       │
│  │ • QUOI faire        │         │ • COMMENT le faire  │       │
│  │                     │         │ • Pour features     │       │
│  │ Commands:           │         │   complexes         │       │
│  │ backlog board view  │         │                     │       │
│  │ backlog task create │         │ Commands:           │       │
│  │ backlog task start  │         │ openspec list       │       │
│  │ backlog task move   │         │ openspec show <n>   │       │
│  └─────────────────────┘         └─────────────────────┘       │
│                                                                 │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │              .claude/commands/ (7 commands)              │  │
│  ├──────────────────────────────────────────────────────────┤  │
│  │ /context → Charge CLAUDE.md + backlog.md + openspec/    │  │
│  │ /task → backlog task create                              │  │
│  │ /plan → Auto-détection simple/complexe                   │  │
│  │ /spec → Force création OpenSpec                          │  │
│  │ /work → Implémente selon spec/plan                       │  │
│  │ /done → Màj backlog + État Projet                        │  │
│  │ /ship → Tests + commit + push                            │  │
│  └──────────────────────────────────────────────────────────┘  │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

### Principes de Design

1. **Automatisation maximale** - Installation en une commande
2. **Générique** - Fonctionne pour tout type de projet
3. **Non-intrusif** - N'altère pas le code source existant
4. **Versionnable** - État du projet partageable via Git
5. **Réversible** - Peut être désinstallé proprement

---

## 📁 Structure du Projet

```
standardisation_claude_code/
├── README.md                              # Ce fichier (guide complet)
├── .gitignore                             # Exclusions Git
├── .gitignore.claude                      # Template gitignore pour projets cibles
└── scripts/                               # Scripts d'installation et workflow
    ├── install-claude-workflow.sh        # Installation complète (8 phases)
    ├── merge-claude-md.sh                # Fusion ClaudeForge + Instructions Claude
    ├── setup-project.sh                  # Setup initial projet (backlog, openspec)
    └── setup-commands.sh                 # Création des 7 slash commands
```

**Après installation dans votre projet** :

```
votre-projet/
├── CLAUDE.md                              # État des lieux complet
├── backlog.md                             # Liste des tâches
├── backlog/                               # Données Backlog.md
│   ├── tasks/                            # Tâches individuelles
│   ├── completed/                        # Tâches terminées
│   ├── archive/                          # Archive
│   └── config.yml                        # Configuration
├── openspec/                              # Spécifications formelles
│   ├── project.md                        # Config projet
│   ├── specs/                            # Specs actives
│   └── archive/                          # Specs complétées
├── .claude/commands/                      # 7 slash commands
│   ├── context.md
│   ├── task.md
│   ├── plan.md
│   ├── spec.md
│   ├── work.md
│   ├── done.md
│   └── ship.md
├── setup-project.sh                       # Script setup
├── setup-commands.sh                      # Script commands
└── merge-claude-md.sh                     # Script fusion CLAUDE.md
```

---

## 📦 Installation Détaillée

### Prérequis (vérifiés automatiquement)

Le script vérifie et guide l'installation si nécessaire :
- **Node.js** (v16+) et **npm** - [nodejs.org](https://nodejs.org/)
- **Git** - pour cloner ClaudeForge

```bash
# Vérifier vos prérequis
node --version  # v16+ requis
npm --version
git --version
```

### 8 Phases d'Installation Automatique

| Phase | Action | Résultat | Durée |
|-------|--------|----------|-------|
| **0** | Vérifie Node.js/npm | ✅ Validation prérequis | < 1s |
| **1** | Installe ClaudeForge | ✅ Clone + install → `/enhance-claude-md` disponible | 2-3 min |
| **2** | Installe Backlog.md | ✅ `npm install -g backlog.md` → CLI disponible | 30s |
| **3** | Installe OpenSpec | ✅ `npm install -g openspec` → CLI disponible | 30s |
| **4** | Copie scripts workflow | ✅ setup-*.sh, merge-*.sh dans projet | < 1s |
| **5** | Affiche instructions | ℹ️ Comment lancer `/enhance-claude-md` | < 1s |
| **6** | Initialise Backlog + OpenSpec | ✅ backlog.md, backlog/, openspec/ créés | 5s |
| **7** | Crée 7 slash commands | ✅ .claude/commands/ prêt | < 1s |
| **8** | État des lieux basique | 📊 Compte fichiers, détecte type projet | 2-5s |

**Total** : ~5-10 minutes

### Installation Complète (Étapes)

```bash
# 1. Cloner ce repo (une seule fois)
git clone https://github.com/fgitconseil/standardisation_claude_code.git

# 2. Lancer l'installation sur votre projet
cd standardisation_claude_code
bash scripts/install-claude-workflow.sh /chemin/vers/votre-projet

# 3. Aller dans votre projet
cd /chemin/vers/votre-projet

# 4. Lancer Claude Code
claude

# 5. Générer CLAUDE.md avec analyse complète
/enhance-claude-md
# Suivre les instructions interactives

# 6. Fusionner avec instructions Claude
./merge-claude-md.sh CLAUDE.md CLAUDE.md

# 7. Utiliser le workflow
/context  # Charger contexte
```

---

## 🧩 Composants du Workflow

### 1. ClaudeForge (Analyse Technique)

**Rôle** : Analyser la codebase et générer un CLAUDE.md technique complet.

**Installation** :
```bash
# Automatique via install-claude-workflow.sh
# ou manuel:
cd ~/.claudeforge
git clone https://github.com/alirezarezvani/ClaudeForge.git
cd ClaudeForge && bash install.sh
```

**Fonctionnalités** :
- ✅ Détecte automatiquement la stack technique
- ✅ Analyse l'architecture du projet
- ✅ Identifie les patterns utilisés
- ✅ Génère un CLAUDE.md structuré

**Outputs** :
- Skill: `~/.claude/skills/claudeforge-skill/`
- Command: `/enhance-claude-md` (disponible dans Claude Code)
- Agent: `claude-md-guardian` (maintenance CLAUDE.md)

**Limitations** :
- Génère uniquement le contenu technique
- Ne contient pas les instructions pour Claude (workflow)
- Ne documente pas les moyens disponibles (Backlog, OpenSpec)

> ⚠️ C'est pour ça qu'on utilise `merge-claude-md.sh` après !

### 2. Backlog.md (Gestion des Tâches)

**Rôle** : Gestion des tâches avec Kanban board en CLI (**vanilla, pas MCP**).

**Installation** :
```bash
npm install -g backlog.md
```

**Fonctionnalités** :
- ✅ CLI pour créer/éditer/lister les tâches
- ✅ Kanban board interactif (`backlog board view`)
- ✅ Interface web optionnelle (`backlog browser`)
- ✅ Statuts : todo, in_progress, blocked, done

**Commandes principales** :
```bash
backlog board view            # Voir Kanban
backlog task create "..."     # Créer tâche
backlog task start <id>       # Démarrer tâche
backlog task move <id> done   # Terminer tâche
backlog task edit <id>        # Éditer tâche
```

**Performance** :
- `backlog board view` : < 1 seconde
- `backlog task create` : < 1 seconde
- `backlog browser` : 2-3 secondes (serveur web)

> ⚠️ **Important** : Ce workflow utilise **Backlog.md vanilla** (CLI standard), **PAS Backlog.md MCP** (tools `mcp__backlog__*`).

### 3. OpenSpec + Specs Skill (Spécifications Divio)

**Rôle** : Créer des spécifications formelles avec intelligence contextuelle.

**Architecture** :
- **Specs Skill** (wrapper) : Intelligence contextuelle, génération adaptative
- **OpenSpec CLI** (vanilla) : Logique métier, portabilité CI/CD

**Installation** :
```bash
npm install -g openspec
# + Specs Skill installé automatiquement par install-claude-workflow.sh
```

**Fonctionnalités** :
- ✅ Template Divio (1 fichier avec 4 blocs)
- ✅ Génération contextuelle (analyse CLAUDE.md + code)
- ✅ Versioning et archivage

**Format OpenSpec v2 (Divio)** :
```markdown
# Feature Name

## 📚 Tutorial (Learning-oriented)
[Guide d'apprentissage pas-à-pas]

## 🛠️ How-to Guides (Goal-oriented)
### Tâches d'Implémentation
- [ ] Task 1: [Description]
  - Fichiers impactés: [Liste]
  - Estimation: [X heures]

### Solutions Pratiques
[Comment résoudre problèmes spécifiques]

## 📋 Reference (Information-oriented)
### Comportement Attendu
[API, interfaces, configuration]

### Critères d'Acceptation
- Given: [Contexte]
- When: [Action]
- Then: [Résultat]

## 💡 Explanation (Understanding-oriented)
### Contexte et Motivation
[Pourquoi cette feature]

### Architecture
[Design technique, décisions]

### Fichiers Impactés
[Liste des fichiers à modifier/créer]
```

**Slash commands** (via Specs Skill) :
```bash
/spec "Feature Name"         # Créer spec Divio contextualisée
/validate-spec               # Valider spec + cohérence
/list-specs                  # Lister avec progression
```

**Intelligence contextuelle** :
- ✅ Lit CLAUDE.md (stack technique, architecture, patterns)
- ✅ Analyse code (fichiers impactés, interfaces existantes)
- ✅ Génère template adapté (exemples code dans bonne stack)
- ✅ Crée tâche Backlog automatiquement
- ✅ Met à jour État Projet

**Performance** :
- `/spec` création : 2-5 secondes (analyse + génération)
- `openspec list` : < 1 seconde
- `openspec show <n>` : < 1 seconde

**Quand utiliser OpenSpec** (au moins 1 critère) :
- ✅ Nouveau comportement utilisateur visible
- ✅ Changement d'architecture ou patterns
- ✅ Impact sur plusieurs features
- ✅ Intégration système externe
- ✅ Modification d'API / contrat

**Quand NE PAS utiliser OpenSpec** :
- ❌ Bug fix isolé
- ❌ Refactoring simple
- ❌ Utilitaire simple
- ❌ Documentation seule

---

## 📚 Documents Structurants (v1.2)

Le workflow installe automatiquement 2 fichiers YAML ultra-légers pour maintenir la cohérence du projet et éviter la duplication.

### Format YAML Machine-Readable

**Optimisation tokens** :
- Format YAML compact (vs Markdown verbeux)
- Projet vide : ~140 tokens total
- Projet mature (30 composants + 50 docs) : ~320 tokens
- **96% réduction vs format Markdown** (8000 tokens → 320 tokens)

### 1. component-catalog.yml

**Rôle** : Catalogue centralisé des composants réutilisables (UI, Backend, Infrastructure, Utilities)

**Format** :
```yaml
stats:
  total: 3
  ui: 1
  backend: 2

components:
  - name: UserAuth
    type: backend
    version: v1.0.0
    stack: FastAPI
    file: src/auth/user_auth.py
```

**Quand l'utiliser** :
- ✅ Avant de créer un nouveau composant → Vérifier s'il existe déjà
- ✅ Après création d'un composant réutilisable → Ajouter dans catalogue
- ✅ Pour découvrir composants existants avant implémentation

**Maintenance** :
- **Automatique** : Via `/done` (checklist propose ajout si nouveau composant)
- **Manuel** : Ajouter ligne dans `components:` + incrémenter `stats:`

### 2. docs-index.yml

**Rôle** : Index de toute la documentation selon framework Divio (4 quadrants)

**Format** :
```yaml
tutorials:
  - name: Getting Started
    file: docs/tutorials/getting-started.md

howto:
  - name: Deploy to Production
    file: docs/howto/deploy.md

reference:
  - name: API Reference
    file: docs/reference/api.md

explanation:
  - name: Architecture Decisions
    file: docs/explanation/architecture.md
```

**Quand l'utiliser** :
- ✅ Avant de créer une doc → Vérifier qu'elle n'existe pas
- ✅ Après création de doc → Ajouter dans quadrant Divio approprié
- ✅ Pour naviguer dans la documentation existante

**Maintenance** :
- **Automatique** : Via `/done` (checklist propose ajout si nouvelle doc)
- **Manuel** : Ajouter ligne dans quadrant approprié (`tutorials/howto/reference/explanation`)

### Workflow Mis à Jour

```bash
# AU DÉMARRAGE
/context
# → Charge automatiquement :
#    • CLAUDE.md
#    • backlog.md
#    • openspec/project.md
#    • component-catalog.yml  ← NOUVEAU
#    • docs-index.yml         ← NOUVEAU

# TRAVAIL
/task "Ajouter feature X"
/plan
/spec "Feature X"  # Crée spec.md Divio si complexe
# Claude consulte component-catalog.yml et docs-index.yml
# → Réutilise composants existants
# → Évite documentation redondante

# FIN DE SESSION
/done
# → Checklist automatique :
#    • Mettre à jour backlog
#    • Archiver specs OpenSpec
#    • Mettre à jour État Projet
#    • Mettre à jour component-catalog.yml (si nouveau composant)
#    • Mettre à jour docs-index.yml (si nouvelle doc)
#    • Ajouter DA-XXX dans README (si décision architecturale)
```

### Bénéfices

**Anti-duplication** :
- Claude connaît l'existant dès le démarrage
- Principe "Réutiliser > Créer" appliqué systématiquement
- Évite 45 min/session de duplication (ROI 180x vs surcharge +15 sec)

**Performance** :
- Chargement silencieux au startup
- 0 friction utilisateur
- Scalable jusqu'à 100+ composants (320 tokens max)

**Format YAML** :
- Machine-readable optimal pour LLM
- Parsable et filtrable
- Extensible (possibilité lazy loading futur si >100 composants)

---

## 🎯 Workflow en 5 Étapes

```
┌─────────────────────────────────────────────────────────────┐
│                  DÉMARRAGE DE SESSION                       │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
                       /context
                            │
                  ┌─────────┴─────────┐
                  │ Claude lit :      │
                  │ • CLAUDE.md       │
                  │ • backlog.md      │
                  │ • openspec/       │
                  └─────────┬─────────┘
                            │
┌─────────────────────────────────────────────────────────────┐
│                 CRÉATION DE TÂCHE                           │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
               /task "Nouvelle feature"
                            │
                  ┌─────────┴─────────┐
                  │ backlog task      │
                  │ create "..."      │
                  └─────────┬─────────┘
                            │
┌─────────────────────────────────────────────────────────────┐
│                    PLANIFICATION                            │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
                         /plan
                            │
                  ┌─────────┴─────────┐
                  │ Auto-détection :  │
                  │ Simple → Plan     │
                  │ Complexe → OpenSpec│
                  └─────────┬─────────┘
                            │
┌─────────────────────────────────────────────────────────────┐
│                  IMPLÉMENTATION                             │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
                         /work
                            │
                  ┌─────────┴─────────┐
                  │ Claude implémente │
                  │ selon spec/plan   │
                  └─────────┬─────────┘
                            │
┌─────────────────────────────────────────────────────────────┐
│                  FIN DE SESSION                             │
└─────────────────────────────────────────────────────────────┘
                            │
                            ▼
                         /done
                            │
                  ┌─────────┴─────────┐
                  │ • Màj backlog     │
                  │ • Màj État Projet │
                  │ • Archive specs   │
                  └───────────────────┘
```

### Commandes en Détail

```bash
# 1. Démarrage (OBLIGATOIRE à chaque session)
claude
/context

# 2. Créer une tâche
/task "Ajouter authentification OAuth"
# Ou: backlog task create "Ajouter authentification OAuth"

# 3. Planifier
/plan
# Auto-détecte: simple (plan rapide) ou complexe (OpenSpec)

# 4. Implémenter
/work
# Claude charge la tâche + spec si existe et implémente

# 5. Terminer
/done
# Màj backlog, archive specs, màj État Projet

# 6. (Optionnel) Livrer
/ship
# Tests + commit + push
```

---

## 📚 7 Slash Commands Personnalisés

| Command | Description | Détails |
|---------|-------------|---------|
| `/context` | **AU DÉMARRAGE** - Charge tout le contexte | Lit CLAUDE.md + backlog.md + openspec/<br>Exécute `backlog board view` et `openspec list`<br>Confirme: "On continue sur quoi ?" |
| `/task` | Créer une tâche Backlog.md | Usage: `/task "Description"`<br>Exécute: `backlog task create "Description"` |
| `/plan` | Planifier (auto simple/complexe) | Détecte automatiquement:<br>- Simple → Plan rapide<br>- Complexe → Crée OpenSpec |
| `/spec` | Créer spec OpenSpec directement | Force création spec formelle<br>Même si tâche simple |
| `/work` | Implémenter une tâche | 1. Charge tâche Backlog<br>2. Charge spec OpenSpec si existe<br>3. Implémente selon spec/plan |
| `/done` | Terminer la session | 1. Màj tâches Backlog<br>2. Archive specs complétées<br>3. Màj "État du Projet" CLAUDE.md |
| `/ship` | Tests + commit + push | 1. Exécute tests<br>2. Crée commit (Co-Authored-By: Claude)<br>3. Push si demandé |

### Contenu des Commands

Les commands sont dans `.claude/commands/` de votre projet.

**Exemple : `/context`**
```markdown
---
description: AU DÉMARRAGE - Charge le contexte complet
---

# Chargement du contexte

Tu dois LIRE dans cet ordre :
1. CLAUDE.md (état des lieux du projet)
2. backlog.md (tâches en cours)
3. openspec/project.md (conventions, si existe)

Puis EXÉCUTER :
- backlog board view (voir Kanban)
- openspec list (voir specs actives)

Puis CONFIRMER :
"Contexte chargé. On continue sur quoi ?"
```

---

## 🔧 Scripts Disponibles

### `scripts/install-claude-workflow.sh`

**Installation complète automatique** sur un projet cible.

```bash
bash scripts/install-claude-workflow.sh /chemin/vers/projet
```

**Ce qu'il fait** :
1. Vérifie prérequis (Node.js, npm, Git)
2. Installe ClaudeForge dans `~/.claudeforge/`
3. Installe Backlog.md globalement (`npm install -g`)
4. Installe OpenSpec globalement (`npm install -g`)
5. Copie les scripts workflow dans le projet
6. Affiche instructions pour `/enhance-claude-md`
7. Initialise `backlog.md` et `openspec/`
8. Crée les 7 slash commands dans `.claude/commands/`
9. Génère état des lieux basique

**Gestion des erreurs** :
- ✅ Vérifie chaque prérequis avant de continuer
- ✅ Backup automatique si fichiers existants
- ✅ Messages d'erreur clairs avec solutions

### `scripts/merge-claude-md.sh`

**Fusionne** le CLAUDE.md généré par ClaudeForge avec les instructions Claude standardisées.

```bash
cd votre-projet
./merge-claude-md.sh CLAUDE.md CLAUDE.md
```

**Ce qu'il fait** :

1. **Extrait** le contenu technique de ClaudeForge :
   - Titre + Métadonnées (`**Architecture**: ...`)
   - Tout le contenu après `---`

2. **Ajoute** les sections workflow :
   - 🤖 Instructions pour Claude (Protocole, Principes, Modes)
   - 🛠️ Moyens Disponibles (Backlog vanilla + OpenSpec)
   - 📊 État du Projet (tableau à compléter)
   - 🔑 Décisions Techniques (historique à compléter)

3. **Construit** le fichier fusionné :
```markdown
# [Titre] (ClaudeForge)
[Métadonnées] (ClaudeForge)

---

## 🤖 INSTRUCTIONS POUR CLAUDE (Ajouté)
[Protocole de Session]
[Principes d'Implémentation]
[Modes Dynamiques]
[Workflow de Planification]
[Moyens: Backlog vanilla + OpenSpec]

---

[Contenu technique complet] (ClaudeForge)

---

## 📊 État du Projet (Ajouté)
[Tableau de statuts]

---

## 🔑 Décisions Techniques (Ajouté)
[Historique décisions]
```

**Backup automatique** :
```bash
# Crée automatiquement :
CLAUDE.md.backup.20251124_183025
```

### `scripts/setup-project.sh`

Initialise `backlog.md` et `openspec/` (appelé automatiquement par `install-claude-workflow.sh`).

```bash
bash setup-project.sh
```

### `scripts/setup-commands.sh`

Crée les 7 slash commands dans `.claude/commands/` (appelé automatiquement par `install-claude-workflow.sh`).

```bash
bash setup-commands.sh
```

---

## 🏛️ Décisions Architecturales

### DA-001: Backlog.md Vanilla (pas MCP)

**Date**: 2025-11-24 | **Statut**: ✅ APPROUVÉ

**Contexte** :
- Backlog.md existe en 2 versions : CLI vanilla et MCP
- Certains projets utilisent Backlog.md MCP (tools `mcp__backlog__*`)
- Le workflow standard doit être générique

**Décision** :
Utiliser **Backlog.md vanilla** (CLI commands) dans le workflow standardisé.

**Raisons** :
1. Plus simple et universel (commands bash standard)
2. Pas de dépendance MCP server
3. Fonctionne out-of-the-box après `npm install -g`
4. Plus large compatibilité avec tous types de projets

**Conséquences** :
- Commands: `backlog task create`, `backlog board view`
- Pas: `mcp__backlog__task_create`, `mcp__backlog__*`
- Documentation doit clarifier : "Backlog vanilla (CLI)"

### DA-002: ClaudeForge Installation Non-Interactive

**Date**: 2025-11-24 | **Statut**: ✅ APPROUVÉ

**Contexte** :
- ClaudeForge `install.sh` pose des questions interactives
- Bloquant pour script d'installation automatique

**Décision** :
Forcer installation non-interactive avec variables d'environnement.

**Implementation** :
```bash
export CI=true
export SKIP_PROMPTS=yes
export AUTO_CONFIRM=yes
bash install.sh < /dev/null
```

**Conséquences** :
- Installation silencieuse
- Valeurs par défaut utilisées
- Pas d'interaction utilisateur nécessaire

### DA-003: Fusion CLAUDE.md (pas écrasement)

**Date**: 2025-11-24 | **Statut**: ✅ APPROUVÉ

**Contexte** :
- ClaudeForge génère un CLAUDE.md technique complet
- Besoin d'ajouter instructions workflow sans perdre contenu technique

**Décision** :
Script `merge-claude-md.sh` **fusionne** au lieu d'écraser.

**Structure finale** :
```
# Titre + Métadonnées (ClaudeForge)
## Instructions pour Claude (ajouté)
## Moyens Disponibles (ajouté)
[Contenu technique complet] (ClaudeForge)
## État du Projet (ajouté)
## Décisions Techniques (ajouté)
```

**Conséquences** :
- Préserve analyse technique de ClaudeForge
- Enrichit avec workflow standardisé
- Un seul fichier CLAUDE.md complet

### DA-004: Slash Commands Personnalisés

**Date**: 2025-11-24 | **Statut**: ✅ APPROUVÉ

**Contexte** :
- Claude Code supporte slash commands via `.claude/commands/`
- Besoin de simplifier le workflow

**Décision** :
Créer 7 slash commands standardisés pour tous les projets.

**Commands** :
1. `/context` - Charge contexte (AU DÉMARRAGE)
2. `/task` - Crée tâche Backlog
3. `/plan` - Planification intelligente
4. `/spec` - Force OpenSpec
5. `/work` - Implémente
6. `/done` - Fin de session
7. `/ship` - Livraison

**Conséquences** :
- Workflow unifié entre projets
- Moins de commandes à mémoriser
- Auto-documentation via description

### DA-005: Structure Modulaire Documentation

**Date**: 2025-11-24 | **Statut**: ✅ APPROUVÉ

**Contexte** :
- Beaucoup de fichiers MD de test/debug dans racine
- Difficile de naviguer

**Décision** :
Réorganiser en structure minimaliste :

```
├── README.md (guide complet autoporteur)
├── scripts/ (tous les scripts)
└── .gitignore.claude (template pour projets)
```

**Conséquences** :
- README complet et autoporteur (toute la doc en un fichier)
- Structure ultra-simple et claire
- Pas de documentation externe nécessaire

### DA-006: Framework Divio + Anti-Prolifération Documentation

**Date**: 2025-11-25 | **Statut**: ✅ APPROUVÉ

**Contexte** :
- Claude Code a tendance à générer trop de documentation (synthèses, plans, analyses)
- OpenSpec actuel fragmenté (proposal.md/tasks.md/specs/) = multiples fichiers
- ProductCoder utilise avec succès le framework Divio (1 document avec 4 blocs)
- Besoin de standardisation de la documentation produit

**Décision** :
1. **Adopter le framework Divio** pour OpenSpec (1 fichier spec.md avec 4 blocs)
2. **Règles strictes anti-prolifération** : Interdire génération de docs hors workflow
3. **Documentation limitée à 3 fichiers** : CLAUDE.md, backlog.md, openspec/spec.md

**Structure OpenSpec v2 (Divio)** :
```
openspec/changes/[feature-name]/
└── spec.md              # 1 seul fichier avec 4 blocs Divio
    ├── 📚 Tutorial      # Learning-oriented
    ├── 🛠️ How-to       # Goal-oriented (inclut tasks)
    ├── 📋 Reference    # Information-oriented (inclut specs)
    └── 💡 Explanation  # Understanding-oriented (inclut proposal)
```

**Règles anti-prolifération** (ajoutées dans CLAUDE.md) :
- ❌ INTERDIT : synthèses (summary.md), plans migration (migration-plan.md), analyses (analysis.md)
- ❌ INTERDIT : docs présentation (presentation.md), fichiers temporaires (.tmp, .draft)
- ✅ AUTORISÉ : CLAUDE.md, backlog.md, openspec/spec.md, README.md (si demandé)

**Raisons** :
1. Réduction fragmentation : 3+ fichiers → 1 fichier (-66%)
2. Collaboration simplifiée : Tous éditent le même document
3. Standard reconnu : Framework Divio/Diátaxis (industrie)
4. Couverture complète : 4 blocs obligent à couvrir tous aspects
5. Contrôle prolifération : Règles strictes INTERDIT

**Conséquences** :
- ✅ Moins de fichiers à maintenir
- ✅ Documentation plus complète (4 dimensions)
- ✅ Meilleure collaboration (1 source de vérité)
- ✅ Limite génération docs inutiles par Claude

**Impact workflow** :
- `/spec` → Crée spec.md avec template Divio (au lieu de proposal/tasks/specs)
- `/work` → Lit spec.md (au lieu de 3 fichiers)
- `/done` → Archive spec.md (simplifié)

### DA-007: Wrapper Skill Specs (Architecture Hybride)

**Date**: 2025-11-25 | **Statut**: ✅ APPROUVÉ

**Contexte** :
- DA-001 établit Backlog.md vanilla (CLI) pour universalité
- ClaudeForge est un skill (intelligence contextuelle)
- OpenSpec est un CLI (logique métier, portabilité)
- Incohérence : skill vs CLI pour fonctions similaires
- Question : Garder OpenSpec CLI ou créer skill complet ?

**Décision** :
Créer **wrapper skill léger** autour d'OpenSpec CLI (architecture hybride).

**Architecture** :
```
Specs Skill (wrapper ~300 LOC)
  ├── Intelligence contextuelle (lit CLAUDE.md)
  ├── Slash commands natifs (/spec, /validate-spec)
  ├── Templates Divio adaptatifs
  ├── Automation cross-outils (Backlog, CLAUDE.md)
  ↓ appelle
OpenSpec CLI (vanilla)
  ├── Logique métier
  ├── Portabilité (CI/CD)
  ├── Maintenance externe (Fission-AI)
```

**Ce que le wrapper ajoute** :
1. **Analyse contextuelle** : Lit CLAUDE.md pour stack/architecture
2. **Génération adaptative** : Template Divio pré-rempli selon projet
3. **Analyse code** : Détecte fichiers impactés, interfaces à étendre
4. **Automation** : Crée tâche Backlog auto, met à jour État Projet
5. **Slash commands** : `/spec` au lieu de `openspec create`

**Raisons** :
1. Meilleur des deux mondes : Intelligence + Portabilité
2. Effort minimal : 1-2 jours (vs 2-4 semaines skill complet)
3. Cohérence architecturale : 2 skills (ClaudeForge + Specs) + 1 CLI (Backlog)
4. Maintenance minimale : Logique métier externalisée
5. ROI maximal : 70% bénéfices pour 10% effort

**Conséquences** :
- ✅ Skills = Intelligence contextuelle + Intégration Claude Code
- ✅ CLI = Logique métier + Portabilité + Maintenance externe
- ✅ Wrapper léger = Génération specs contextualisées
- ⚠️ Dépendance OpenSpec CLI (acceptable, maintenance externe)
- ✅ Slash commands natifs améliorent UX

**Exemple workflow** :
```bash
# 1. Setup projet (une fois)
/enhance-claude-md → ClaudeForge analyse → CLAUDE.md

# 2. Nouvelle feature (à chaque fois)
/spec "OAuth" → Specs Wrapper :
  - Lit CLAUDE.md (stack détectée)
  - Analyse code (trouve src/auth/* existants)
  - Génère spec.md Divio pré-remplie
  - Crée tâche Backlog automatiquement
```

---

### DA-008: Documents Structurants YAML (Anti-Duplication)

**Date**: 2025-11-25 | **Statut**: ✅ APPROUVÉ

**Contexte** :
- Claude crée souvent docs/composants redondants (manque de vision globale)
- ProductCoder a COMPONENT_CATALOG.md + DIVIO_INDEX.md (Markdown verbeux)
- Templates ProductCoder : 210 lignes (DIVIO_INDEX) + 266 lignes (COMPONENT_CATALOG)
- Chargement au startup = 8000 tokens pour projet mature (4% context window) 🔴
- Question : Intégrer ces éléments dans standardisation_claude_code ? Quel format ?

**Décision** :
Créer **templates YAML ultra-légers** pour projets cibles avec **format machine-readable**.

**Raisons** :
1. **96% réduction tokens** : YAML compact vs Markdown verbeux
   - component-catalog.yml : 80 tokens vide, 120 tokens avec 30 composants (vs 2000 Markdown)
   - docs-index.yml : 60 tokens vide, 200 tokens avec 50 docs (vs 3000 Markdown)
   - Projet mature : 320 tokens total (vs 8000 Markdown)
2. **Machine-readable optimal** : Parsable, filtrable, extensible pour LLM
3. **Chargement automatique** : +20% tokens startup (1000 → 1200) vs +350% avec Markdown
4. **Anti-duplication** : Claude consulte existant avant création
5. **0 friction user** : Chargé silencieusement, maintenance via `/done`

**Alternatives considérées** :

**Option A** : Templates Markdown comme ProductCoder
- ❌ 8000 tokens projet mature (inacceptable)
- ❌ Verbosité (tableaux, emojis, descriptions longues)
- ✅ Human-readable

**Option B** : Lazy loading avec docs croisées
- ✅ Optimal tokens (chargement à la demande)
- ❌ Complexité implémentation (~3-4h vs 1h20)
- ❌ Friction user (demandes explicites `/load-component`)
- ❌ Vision partielle pour Claude

**Option C** : YAML Simple Auto-load (CHOISIE)
- ✅ Effort modéré (1h20)
- ✅ 96% réduction tokens vs Markdown
- ✅ Vision globale instantanée pour Claude
- ✅ 0 friction, chargement transparent
- ⚠️ Moins human-readable (acceptable pour machine-first)

**Conséquences** :

**Positives** :
- ✅ Évite 45 min/session de duplication (ROI 180x)
- ✅ Claude connaît l'existant dès le démarrage
- ✅ Principe "Réutiliser > Créer" appliqué systématiquement
- ✅ Scalable jusqu'à 100 composants/docs (320 tokens max)
- ✅ Extensible : Possibilité lazy loading Phase 2 si >100 composants

**Négatives / Compromis** :
- ⚠️ YAML moins lisible pour humains (vs Markdown)
- ⚠️ Maintenance manuelle possible (mitigé par checklist `/done`)
- ⚠️ Pas optimal pour projets géants >100 composants (mais rare, évolution possible)

**Fichiers impactés** :
- `templates/component-catalog.yml` (nouveau)
- `templates/docs-index.yml` (nouveau)
- `templates/ADR_TEMPLATE.md` (nouveau)
- `scripts/merge-claude-md.sh` (enrichi Protocole Session)
- `.claude/commands/done.md` (enrichi checklist)
- `scripts/install-claude-workflow.sh` (Phase 8 copie YAML)
- `README.md` (documentation section v1.2)

**Impact workflow** :
```bash
# Startup : +2 fichiers YAML (~140 tokens vides)
CLAUDE.md + backlog.md + openspec/ + component-catalog.yml + docs-index.yml

# /done : +2 checkboxes
- [ ] Mettre à jour component-catalog.yml (si nouveau composant)
- [ ] Mettre à jour docs-index.yml (si nouvelle doc)
```

**Version** : v1.2.0 → Ajout Documents Structurants YAML

---

### DA-009: Configuration Optionnelle Backlog/OpenSpec

**Date**: 2025-11-28 | **Statut**: ✅ APPROUVÉ

**Contexte** :
- Le workflow standardisé installe Backlog.md + OpenSpec par défaut
- Certains projets préfèrent des approches plus légères (GitHub Issues, discussions directes)
- MagicDispatch et ProductCoder désactivent Backlog/OpenSpec au profit de YAML uniquement
- Confusion : Backlog/OpenSpec sont-ils obligatoires ou optionnels ?

**Décision** :
**Backlog.md et OpenSpec sont OPTIONNELS**. Les projets peuvent les désactiver et utiliser uniquement :
- `component-catalog.yml` (catalogue composants)
- `docs-index.yml` (index documentation Divio)
- CLAUDE.md (état projet + décisions)

**Configuration AVEC Backlog/OpenSpec** (défaut) :
```markdown
## 🤖 INSTRUCTIONS POUR CLAUDE

**Ce projet UTILISE :**
- ✅ **Backlog.md** - Gestion tâches CLI
- ✅ **OpenSpec** - Spécifications formelles Divio
- ✅ **component-catalog.yml** - Catalogue composants
- ✅ **docs-index.yml** - Index documentation

**AU DÉMARRAGE :**
1. Lire CLAUDE.md
2. Lire backlog.md
3. Lire openspec/project.md
4. Lire component-catalog.yml
5. Lire docs-index.yml
```

**Configuration SANS Backlog/OpenSpec** (alternative légère) :
```markdown
## 🤖 INSTRUCTIONS POUR CLAUDE

**Ce projet N'UTILISE PAS :**
- ❌ **Backlog.md** - Gestion tâches via GitHub Issues/Projects
- ❌ **OpenSpec** - Spécifications via discussions directes

**Ce projet UTILISE :**
- ✅ **component-catalog.yml** - Catalogue composants
- ✅ **docs-index.yml** - Index documentation Divio
- ✅ **CLAUDE.md** - État du projet et instructions

**AU DÉMARRAGE :**
1. Lire CLAUDE.md
2. Lire component-catalog.yml
3. Lire docs-index.yml
4. Confirmer compréhension et demander "On continue sur quoi ?"
```

**Raisons** :
1. **Flexibilité** : Chaque projet a ses propres outils de gestion
2. **Légèreté** : Certains projets n'ont pas besoin de Backlog/OpenSpec
3. **Interopérabilité** : GitHub Issues, Jira, Linear, etc. déjà en place
4. **Documentation Divio** : docs-index.yml suffit pour documenter features
5. **Principe YAGNI** : Ne pas imposer outils non nécessaires

**Conséquences** :

**Avec Backlog/OpenSpec** :
- ✅ Gestion tâches Kanban intégrée
- ✅ Specs formelles Divio pour features complexes
- ✅ Workflow complet `/task` → `/plan` → `/spec` → `/work`
- ⚠️ Dépendances npm (backlog.md, openspec)

**Sans Backlog/OpenSpec** :
- ✅ Légèreté maximale (YAML + CLAUDE.md seulement)
- ✅ Intégration outils existants (GitHub Issues, etc.)
- ✅ Moins de dépendances
- ⚠️ Slash commands adaptés : `/plan`, `/doc`, `/done`, `/ship` (pas `/task`, `/spec`, `/work`)
- ⚠️ Documentation via `/doc` (crée docs Divio dans docs-index.yml)

**Workflow adapté (sans Backlog/OpenSpec)** :
```bash
/context     # Charge CLAUDE.md + YAML files
/plan        # Analyse et planification
/doc "Feature X"  # Crée doc Divio pour feature complexe
# Implémentation directe
/done        # Màj CLAUDE.md + YAML
/ship        # Tests + commit
```

**Impact** :
- Documentation README.md clarifiée : "Backlog/OpenSpec sont optionnels"
- Section Quick Start propose les deux modes
- Templates slash commands adaptables (avec/sans backlog)
- CLAUDE.md template contient les deux configurations possibles

**Version** : v1.2.1 → Flexibilité Configuration Backlog/OpenSpec

---

## 🔄 Gestion Git (versionner le contexte)

### À Versionner (pour collaboration)

```bash
git add CLAUDE.md backlog.md backlog/ openspec/ .claude/commands/
git add component-catalog.yml docs-index.yml
git add setup-project.sh setup-commands.sh merge-claude-md.sh .gitignore
git commit -m "feat: Add Claude Code workflow with full project analysis"
```

**Fichiers à versionner** :
- ✅ `CLAUDE.md` - État du projet
- ✅ `backlog.md` + `backlog/` - Tâches (sauf cache)
- ✅ `openspec/` - Specs (sauf `.openspec/`)
- ✅ `component-catalog.yml` - Catalogue composants (v1.2)
- ✅ `docs-index.yml` - Index documentation Divio (v1.2)
- ✅ `.claude/commands/` - Slash commands
- ✅ `*.sh` - Scripts workflow
- ✅ `.gitignore`

### Auto-Exclus par `.gitignore.claude`

**NE PAS versionner** :
- ❌ `*.backup.*` - Backups temporaires
- ❌ `*_backup_*` - Backups scripts
- ❌ `.backlog/` - Cache Backlog.md
- ❌ `openspec/.cache/` - Cache OpenSpec
- ❌ `openspec/.openspec/` - Config locale
- ❌ `.env` - Variables d'environnement
- ❌ `*.key`, `*.pem` - Clés privées
- ❌ `credentials.json` - Credentials

---

## 🆘 Troubleshooting

### Problèmes Courants

| Problème | Solution |
|----------|----------|
| `backlog: command not found` | `npm install -g backlog.md` |
| `openspec: command not found` | `npm install -g openspec` |
| `/enhance-claude-md` not found | Relancer `scripts/install-claude-workflow.sh` (Phase 1) |
| CLAUDE.md sans instructions | `./merge-claude-md.sh CLAUDE.md CLAUDE.md` |
| OpenSpec init failed | `cd votre-projet && openspec init` manuellement |
| ClaudeForge bloque sur prompts | Vérifier variables env : `CI=true SKIP_PROMPTS=yes` |
| Backlog.md board vide | `backlog task create "Première tâche"` |
| Permission denied sur scripts | `chmod +x scripts/*.sh` |

### Logs et Debug

```bash
# Vérifier installations
which backlog
which openspec
ls -la ~/.claudeforge

# Vérifier structure projet
ls -la CLAUDE.md backlog.md
ls -la .claude/commands/
tree backlog/ openspec/

# Debug install script (mode verbose)
bash -x scripts/install-claude-workflow.sh /projet

# Réinstaller proprement
rm -rf ~/.claudeforge
npm uninstall -g backlog.md openspec
bash scripts/install-claude-workflow.sh /projet
```

### Support

- **Issues**: [GitHub Issues](https://github.com/fgitconseil/standardisation_claude_code/issues)
- **Documentation**: Tout dans README.md

---

## 📊 Métriques et Performance

### Métriques d'Installation

- Temps total : ~5-10 minutes
- Taille ClaudeForge : ~50 MB
- Taille Backlog.md : ~2 MB
- Taille OpenSpec : ~1 MB

### Performance Runtime

**ClaudeForge `/enhance-claude-md`** :
- Petit projet (< 100 fichiers) : 1-2 minutes
- Projet moyen (1k-10k fichiers) : 5-10 minutes
- Gros projet (> 50k fichiers) : 15-30 minutes

**Backlog.md CLI** :
- `backlog board view` : < 1 seconde
- `backlog task create` : < 1 seconde
- `backlog browser` : 2-3 secondes (serveur web)

**OpenSpec CLI** :
- `openspec list` : < 1 seconde
- `openspec show <n>` : < 1 seconde

---

## 🚀 Roadmap

### v1.1 (Court terme)
- [ ] Support Windows (adaptation scripts bash → PowerShell)
- [ ] Tests automatisés (CI/CD)
- [ ] Mode verbose/debug pour install script
- [ ] Command `/status` (état global projet)

### v1.2 (Moyen terme)
- [ ] Support Docker (installation dans container)
- [ ] Templates de projets (React, Python, FastAPI, etc.)
- [ ] Dashboard web pour état projet
- [ ] Intégration VS Code (extension)

### v2.0 (Long terme)
- [ ] Plugin VSCode natif
- [ ] Intégration GitHub Actions
- [ ] Metrics et analytics
- [ ] Multi-projets (workspace support)

---

## 🤝 Contribution

Les contributions sont les bienvenues ! Ouvrez une issue ou PR sur GitHub.

### Guidelines

1. **Fork** le repo
2. **Créer** une branche : `git checkout -b feature/ma-feature`
3. **Commiter** : `git commit -m "feat: Add amazing feature"`
4. **Pusher** : `git push origin feature/ma-feature`
5. **Ouvrir** une Pull Request

### Tests Avant PR

Avant de merger, testez sur un projet réel :

```bash
# 1. Tester installation
bash scripts/install-claude-workflow.sh /path/to/test-project

# 2. Tester génération CLAUDE.md
cd /path/to/test-project
claude
/enhance-claude-md

# 3. Tester fusion
./merge-claude-md.sh CLAUDE.md CLAUDE.md

# 4. Tester workflow
/context
/task "Test task"
backlog board view
```

---

## 📚 Ressources Externes

### Outils Principaux

- **[ClaudeForge](https://github.com/alirezarezvani/ClaudeForge)** - Analyse de codebase et génération CLAUDE.md technique
- **[Claude Code](https://www.anthropic.com/claude-code)** - CLI officiel Anthropic
- **[Backlog.md](https://github.com/backlog-md/backlog.md)** - Gestion des tâches avec Kanban CLI (optionnel, mode COMPLET)
- **[OpenSpec](https://openspec.dev)** - Spécifications formelles pour features complexes (optionnel, mode COMPLET)

### 🔌 MCP Server Recommandé

**[context7](https://github.com/upstash/context7)** - Documentation à jour pour les bibliothèques

**Problème résolu** : Les LLM utilisent souvent des infos obsolètes sur les bibliothèques, générant du code avec des APIs qui n'existent pas.

**Solution context7** : Fournit des docs et exemples de code **spécifiques à la version exacte** de chaque bibliothèque utilisée dans votre projet.

```bash
# Installation via Claude Desktop config
# Voir: https://github.com/upstash/context7#installation
```

**Pourquoi utiliser context7 ?**
- ✅ Documentation à jour extraite des sources officielles
- ✅ Exemples de code version-spécifiques (pas de hallucinations d'API)
- ✅ Zéro friction : ajoutez "use context7" à vos prompts
- ✅ Complète CLAUDE.md avec infos bibliothèques actuelles
- ✅ Particulièrement utile pour projets avec nombreuses dépendances

**Utilisation** :
```bash
claude
# Dans vos prompts
"Comment utiliser React Query v5 pour fetcher data? use context7"
# context7 récupère la doc officielle React Query v5 → réponse précise
```

**💡 Recommandation Post-Installation : Ajoutez une règle pour auto-invoquer Context7**

Après avoir installé Context7, améliorez votre workflow en ajoutant une règle dans votre **CLAUDE.md** pour ne pas avoir à taper "use context7" dans chaque prompt.

Ajoutez cette règle dans la section **"# Instructions pour Claude"** de votre CLAUDE.md :

```markdown
## Règles d'Utilisation Context7

Always use context7 when I need code generation, setup or configuration steps, or
library/API documentation. This means you should automatically use the Context7 MCP
tools to resolve library id and get library docs without me having to explicitly ask.
```

Après cela, Context7 sera automatiquement invoqué pour toutes les questions liées aux bibliothèques, sans avoir à le demander explicitement.

**Intégration avec le workflow** :
- CLAUDE.md documente l'**architecture projet** (stack, patterns, décisions)
- context7 fournit la **documentation bibliothèques** (APIs, exemples code)
- Complémentaires : état projet + docs techniques à jour

---

## 📝 Changelog

### v1.2.2 (2025-12-02)
- ✅ Ajout recommandation Context7 : règle auto-invocation dans CLAUDE.md
- ✅ Intégration règle Context7 dans merge-claude-md.sh
- ✅ Documentation complète usage Context7 avec MCP
- ✅ Structure minimale (7 fichiers) - nettoyage docs obsolètes

### v1.2.1 (2025-11-28)
- ✅ DA-009: Configuration optionnelle Backlog/OpenSpec
- ✅ Clarification README : Backlog/OpenSpec sont optionnels
- ✅ Documentation des deux modes (avec/sans Backlog/OpenSpec)
- ✅ Template docs-index.yml enrichi (règles Divio)
- ✅ Workflow adapté pour mode léger (YAML seulement)

### v1.2.0 (2025-11-25)
- ✅ DA-008: Templates YAML ultra-légers (96% réduction tokens)
- ✅ component-catalog.yml (catalogue composants réutilisables)
- ✅ docs-index.yml (index documentation Divio)
- ✅ ADR_TEMPLATE.md (template décisions architecturales)
- ✅ Enrichissement `/done` (checklist YAML)
- ✅ Protocole Session enrichi (chargement YAML)

### v1.1.0 (2025-11-25)
- ✅ DA-006: Framework Divio + Anti-Prolifération
- ✅ DA-007: Wrapper Skill Specs (architecture hybride)
- ✅ OpenSpec v2 avec format Divio (1 fichier 4 blocs)
- ✅ Règles strictes anti-prolifération documentation

### v1.0.0 (2025-11-24)
- ✅ Installation automatique complète (8 phases)
- ✅ Intégration ClaudeForge + Backlog.md + OpenSpec
- ✅ 7 slash commands personnalisés
- ✅ Script `merge-claude-md.sh` pour fusion
- ✅ Documentation complète et autoporteuse (README.md unique)
- ✅ Structure minimaliste (README + scripts/)
- ✅ 5 décisions architecturales documentées (DA-001 à DA-005)

---

**Happy coding with Claude! 🚀**

**Version**: 1.2.1
**Last Updated**: 2025-11-28
**Maintainers**: @fgitconseil
**License**: MIT
