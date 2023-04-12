using Plots

# Questo comando setta come default la visualizzazione dei plot.
# Ora preferiamo agire su i plot uno ad uno utilizzando la funzione "display(::plot)" 
# Plots.default(show = true)

x = range(0, 10, length=100)
y = sin.(x)
display(Plots.plot(x, y))

# Necessario affinche il processo non venga chiuso immediatamente, 
# dunque sia impossibile vedere il grafico.
# Una soluzione migliore sarebbe utilizzare i thread
readline()