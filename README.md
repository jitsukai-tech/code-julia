# 📊 **Projet Julia - Gestion de données mensuelles avec PostgreSQL**

**Auteur** : [Jitsukai](https://github.com/jitsukai-tech)
**Langage** : Julia ≥ 1.6
**Base de données** : PostgreSQL ≥ 12
**Licence** : [GPLv3](https://www.gnu.org/licenses/gpl-3.0.fr.html)

---

## 📌 **Description**
Ce projet permet de **stocker et analyser des données mensuelles** (valeurs numériques par année/mois) dans **PostgreSQL** via **Julia** et le package `LibPQ.jl`.
Il inclut :
- Création automatique d'un **schéma dédié** (`mon_app`).
- Création d'une **table `donnees_mensuelles`** avec contraintes (unicité année/mois).
- Insertion de **données d'exemple** (2020–2024).
- Vérification des **permissions** et gestion des erreurs.

---

---

## 🛠 **Prérequis**
   Logiciel       | Version       | Installation                                                                 |
 |----------------|---------------|------------------------------------------------------------------------------|
 | **Julia**      | ≥ 1.6         | [Téléchargement](https://julialang.org/downloads/)                         |
 | **PostgreSQL** | ≥ 12          | [Linux](https://www.postgresql.org/download/linux/) / [macOS](https://www.postgresql.org/download/macosx/) / [Windows](https://www.postgresql.org/download/windows/) |
 | **LibPQ.jl**   | Dernière      | `using Pkg; Pkg.add("LibPQ")`                                                |

---

---

## 🚀 **Installation et Configuration**

---

### **1️⃣ Installer PostgreSQL**
#### **Sur Debian/Ubuntu** :
```bash
sudo apt update && sudo apt install postgresql postgresql-contrib
sudo systemctl start postgresql
sudo systemctl enable postgresql
