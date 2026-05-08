using LibPQ

# =============================================
# 1. Fonction pour vérifier/créer le schéma
# =============================================
function ensure_schema(conn, schema::String)
    # Vérifier si le schéma existe
    result = LibPQ.execute(conn, "SELECT 1 FROM pg_catalog.pg_namespace WHERE nspname = '$schema';")
    schema_exists = !isempty(result)

    if !schema_exists
        println("⚠️ Le schéma $schema n'existe pas. Tentative de création...")
        try
            LibPQ.execute(conn, "CREATE SCHEMA $schema;")
            println("✅ Schéma $schema créé.")
        catch e
            println("❌ Impossible de créer le schéma $schema : ", e)
            println("⚠️ Utilisation du schéma public à la place.")
            return "public"
        end
    else
        println("✅ Le schéma $schema existe déjà.")
    end
    return schema
end

# =============================================
# 2. Fonction pour vérifier les permissions (CORRIGÉE)
# =============================================
function check_permissions(conn, schema::String, user::String)
    query = """
    SELECT has_schema_privilege('$user', '$schema', 'USAGE') AS has_usage,
           has_schema_privilege('$user', '$schema', 'CREATE') AS has_create;
    """
    result = LibPQ.execute(conn, query)
    if isempty(result)
        println("\n🔐 Impossible de vérifier les permissions pour '$user' sur '$schema'.")
        return
    end
    row = first(result)
    has_usage = row[1]  # Accès par index (1 = première colonne)
    has_create = row[2] # Accès par index (2 = deuxième colonne)
    println("\n🔐 Permissions de '$user' sur le schéma '$schema':")
    println("- USAGE: ", has_usage ? "✅" : "❌")
    println("- CREATE: ", has_create ? "✅" : "❌")
end

# =============================================
# 3. Fonction pour créer la table
# =============================================
function create_table(conn, schema::String, table_name::String)
    query = """
    CREATE TABLE IF NOT EXISTS $schema.$table_name (
        id SERIAL PRIMARY KEY,
        annee INTEGER NOT NULL,
        mois INTEGER NOT NULL CHECK (mois BETWEEN 1 AND 12),
        valeur FLOAT,
        date_ajout TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        UNIQUE (annee, mois)
    );
    """
    try
        LibPQ.execute(conn, query)
        println("✅ Table $schema.$table_name créée avec succès !")
    catch e
        println("❌ Erreur lors de la création de la table : ", e)
        rethrow(e)
    end
end

# =============================================
# 4. Fonction pour insérer des données
# =============================================
function insert_data(conn, schema::String, table_name::String, annee_debut::Int, annee_fin::Int)
    for annee in annee_debut:annee_fin
        for mois in 1:12
            valeur = rand() * 1000
            query = """
            INSERT INTO $schema.$table_name (annee, mois, valeur)
            VALUES ($annee, $mois, $valeur)
            ON CONFLICT (annee, mois) DO NOTHING;
            """
            try
                LibPQ.execute(conn, query)
            catch e
                println("❌ Erreur lors de l'insertion pour $annee-$mois: ", e)
            end
        end
    end
    println("✅ Données insérées pour les années $annee_debut à $annee_fin !")
end

# =============================================
# 5. Fonction pour lister les tables (CORRIGÉE)
# =============================================
function list_tables(conn, schema::String)
    query = """
    SELECT table_name
    FROM information_schema.tables
    WHERE table_schema = '$schema'
    AND table_type = 'BASE TABLE';
    """
    result = LibPQ.execute(conn, query)
    println("\n📋 Tables dans le schéma '$schema':")
    if isempty(result)
        println("- Aucune table trouvée.")
    else
        for row in result
            # Accès par index (1 = première colonne)
            println("- ", row[1])
        end
    end
end

# =============================================
# 6. Fonction principale
# =============================================
function main()
    # --- Paramètres de connexion ---
    host = "localhost"
    dbname = "ma_base"
    user = "jitsukai"
    password = "monpassword
    schema = "mon_app"
    table_name = "donnees_mensuelles"

    conn = nothing

    try
        # --- Connexion à PostgreSQL ---
        conn_string = "host=$host dbname=$dbname user=$user password=$password"
        conn = LibPQ.Connection(conn_string)
        println("🔌 Connexion à PostgreSQL réussie !")

        # --- Vérifier/créer le schéma ---
        schema = ensure_schema(conn, schema)

        # --- Vérifier les permissions ---
        check_permissions(conn, schema, user)

        # --- Création de la table ---
        create_table(conn, schema, table_name)

        # --- Insertion des données (2020-2024) ---
        insert_data(conn, schema, table_name, 2020, 2024)

        # --- Lister les tables ---
        list_tables(conn, schema)

    catch e
        println("❌ Erreur fatale : ", e)
    finally
        if conn !== nothing
            try
                LibPQ.close(conn)
                println("🔌 Connexion fermée.")
            catch e
                println("⚠️ Erreur lors de la fermeture : ", e)
            end
        end
    end
end

# =============================================
# 7. Exécution
# =============================================
main()
