using Plots
pyplot()  # Backend PyPlot (nécessite Python installé)

# Fonction pour calculer la moyenne
function moyenne_consommation(consommations::Vector{Float64})
    isempty(consommations) ? 0.0 : sum(consommations) / length(consommations)
end

# Demande à l'utilisateur de saisir ses consommations mensuelles
println("Entrez vos consommations mensuelles (en L/100km ou kWh), séparées par des espaces :")
println("Exemple : 5.2 6.1 4.8 5.5 6.0 5.8 6.3 5.9 6.1 5.7 6.0 5.5")
input = readline()

# Conversion et gestion des erreurs
try
    consommations = parse.(Float64, split(input))
    if length(consommations) != 12
        println("\nAttention : Vous devez entrer 12 valeurs (une par mois).")
    else
        moyenne = moyenne_consommation(consommations)
        println("\nLa consommation moyenne annuelle est de : ", round(moyenne, digits=2), " L/100km")

        # Noms des mois
        mois = ["Jan", "Fév", "Mar", "Avr", "Mai", "Juin", "Juil", "Août", "Sep", "Oct", "Nov", "Déc"]

        # --- Génération du graphique en barres (pas un histogramme classique) ---
        # On utilise `bar` pour afficher chaque mois avec sa consommation
        bar(mois, consommations,
            label="Consommation mensuelle",
            color=:skyblue,
            alpha=0.7,
            title="Consommations mensuelles (L/100km)",
            xlabel="Mois",
            ylabel="Consommation (L/100km)",
            legend=:topleft,
            size=(800, 500))  # Taille du graphique

        # Ajout de la ligne de moyenne
        hline!([moyenne],
               label="Moyenne annuelle = $(round(moyenne, digits=2))",
               color=:red,
               linewidth=2,
               linestyle=:dash)

        # Sauvegarde en PNG
        savefig("consommations_mensuelles.png")
        println("\nGraphique sauvegardé sous : consommations_mensuelles.png")

        # Affichage (optionnel)
        display(plot!())
    end
catch e
    println("\nErreur : Veuillez entrer 12 nombres valides, séparés par des espaces.")
end
