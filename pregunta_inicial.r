  install.packages("sqldf")
  install.packages("gsubfn")
  install.packages("proto")
  install.packages("RSQLite")
  library(sqldf)
  library(gsubfn)
  library(proto)
  library(RSQLite)
  
  
events <- subset(events,select = -text)
pregunta_inicial <- subset(events,select = c(side, id_odsp, event_type, is_goal))
pregunta_inicial <- sqldf('SELECT * FROM pregunta_inicial WHERE event_type = 1')
pregunta_inicial <- subset(pregunta_inicial,select=-event_type)
prueba <- sqldf('SELECT id_odsp,count(is_goal) as tiros_totales FROM pregunta_inicial GROUP BY id_odsp')
conjuntacion <- sqldf('SELECT * FROM pregunta_inicial NATURAL JOIN prueba')
prueba <- sqldf('SELECT id_odsp,count(is_goal) as goles FROM pregunta_inicial WHERE is_goal=1 GROUP BY id_odsp')
conjuntacion <- sqldf('SELECT * FROM conjuntacion NATURAL JOIN prueba')
prueba <- sqldf('SELECT id_odsp,count(is_goal) as golLocal FROM pregunta_inicial WHERE is_goal=1 AND side = 1 GROUP BY id_odsp')
conjuntacion <- sqldf('SELECT * FROM conjuntacion NATURAL JOIN prueba')
prueba <- sqldf('SELECT id_odsp,count(is_goal) as golVisitante FROM pregunta_inicial WHERE is_goal=1 AND side = 2 GROUP BY id_odsp')
conjuntacion <- sqldf('SELECT * FROM conjuntacion NATURAL JOIN prueba')
prueba <- sqldf('SELECT id_odsp,count(is_goal) as tirosLocal FROM pregunta_inicial WHERE side = 1 GROUP BY id_odsp')
conjuntacion <- sqldf('SELECT * FROM conjuntacion NATURAL JOIN prueba')
prueba <- sqldf('SELECT id_odsp,count(is_goal) as tirosVisitante FROM pregunta_inicial WHERE side = 2 GROUP BY id_odsp')
conjuntacion <- sqldf('SELECT * FROM conjuntacion NATURAL JOIN prueba')
conjuntacion <- subset(conjuntacion, select = -side)
conjuntacion <- subset(conjuntacion, select = -is_goal)
View(conjuntacion)
conjuntacion <- sqldf('SELECT distinct * from conjuntacion')
View(conjuntacion)


// ---------------------------------------------------------------------------
install.packages("sqldf")
install.packages("gsubfn")
install.packages("proto")
install.packages("RSQLite")
install.packages("ggplot2")

library(sqldf)
library(gsubfn)
library(proto)
library(RSQLite)
library(ggplot2)


# Eliminamos columnas innecesarias y cambiamos identificadores a numéricosevents <- subset(events,select = -text)
events <- subset(events,select = -id_event)
events$eventID <- 1:nrow(events)
events$matchID <- as.numeric(factor(events$id_odsp, levels=unique(events$id_odsp)))
events <- subset(events, select = -id_odsp)

ginf$matchID <- as.numeric(factor(ginf$id_odsp, levels=unique(ginf$id_odsp)))
ginf <- subset(ginf, select = -id_odsp)
ginf <- subset(ginf, select = -link_odsp)

# Combinamos las tablas events y ginf
mergeCols <- c("matchID", "matchID")
inner <- merge(ginf, events, by = mergeCols)

# Eliminamos filas que no tengan información detallada
inner <- subset(inner, adv_stats == TRUE)
inner <- subset(inner, select = -adv_stats)
inner <- subset(inner, select = -c(odd_over, odd_under, odd_bts, odd_bts_n))

# Creamos una nueva columna con el equipo ganador
inner$winner <- ifelse(inner$fthg > inner$ftag, inner$ht, ifelse(inner$fthg < inner$ftag, inner$at, "tie"))

# Añadimos el tipo de evento como una string

inner$events_name <- factor(inner$event_type, levels = c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11), 
       labels = c("Attempt(shot)", "Corner", "Foul", "YellowCard", 
                  "SecondYellowCard", "(straight)RedCard", "Substitution", 
                  "FreeKickWon", "Offside", "HandBall", "Penalty"))

# Gráficas
# Distribución de eventos
ggplot(inner, aes(y=events_name)) +
  geom_bar(color="black", size=1, fill="#0072B2") +
  ggtitle("Events distribution") +
  theme_ipsum() +
  theme(
    plot.title = element_text(size=15)
  )

# Distribución de datos por ligas
ggplot(inner, aes(y=league)) +
  geom_bar(color="black", size=1, fill="orange") +
  ggtitle("Leagues distribution") +
  theme_ipsum() +
  theme(
    plot.title = element_text(size=15)
  )



