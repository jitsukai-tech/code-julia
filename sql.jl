# Charger les packages nécessaires
using LibPQ, Dates

# Fonction pour se connecter à la base de données PostgreSQL
function connect_to_db(host, dbname, user, password)
    conn = LibPQ.Connection("host=$host dbname=$dbname user=$user password=$password")
    return conn
end

# Fonction pour créer une table (si elle n'existe pas)
function create_table(conn, table_name)
    query = """
    CREATE TABLE IF NOT EXISTS $table_name (
        id SERIAL PRIMARY KEY,
        annee INTEGER NOT NULL,
        mois INTEGER NOT NULL,
        valeur DOUBLE PRECISION NOT NULL,
        date_creation TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    );
    """
    LibPQ.execute(conn, query)
    println("Table '$table_name' créée ou déjà existante.")
end

# Fonction pour insérer des données sur plusieurs années (12 mois par année)
function insert_data(conn, table_name, start_year, end_year)
    for year in start_year:end_year
        for month in 1:12
            # Générer une valeur aléatoire pour l'exemple
            valeur = rand() * 100  # Valeur aléatoire entre 0 et 100

            # Requête SQL pour insérer les données
            query = """
            INSERT INTO $table_name (annee, mois, valeur)
            VALUES ($year, $month, $valeur);
            """
            LibPQ.execute(conn, query)
        end
    end
    println("Données insérées pour les années $start_year à $end_year.")
end

# Fonction pour fermer la connexion
function close_connection(conn)
    LibPQ.close(conn)
    println("Connexion fermée.")
end

# --- Exécution du code ---
begin
    # Paramètres de connexion (à adapter)
    host = "localhost"
    dbname = "ma_base_de_donnees"
    user = "mon_utilisateur"
    password = "mon_mot_de_passe"
    table_name = "donnees_mensuelles"

    # Connexion à la base de données
    conn = connect_to_db(host, dbname, user, password)

    # Créer la table
    create_table(conn, table_name)

    # Insérer des données pour 5 années (2020 à 2024)
    insert_data(conn, table_name, 2020, 2024)

    # Fermer la connexion
    close_connection(conn)
end
