#lang racket/gui

(require "Implementacao_logica.rkt")
(require examples)

; resolver-enigma
(examples
  ; Caso quando as listas são idênticas
  (check-equal? (resolver-enigma '(1 2 3) '(1 2 3)) #true)
  
  ; Caso quando as listas são diferentes
  (check-equal? (resolver-enigma '(1 2 3) '(1 2 4)) #false)
  
  ; Caso com listas vazias
  (check-equal? (resolver-enigma '() '()) #true)
  
  ; Caso com strings
  (check-equal? (resolver-enigma '("a" "b" "c") '("a" "b" "c")) #true)

    ; criar-enigma
  ; Enigma simples com uma palavra
  (check-equal? 
    (criar-enigma "Adivinhe a palavra" "casa" '("tem teto" "tem porta") "Parabéns!")
    (Enigma "Adivinhe a palavra" "casa" '("tem teto" "tem porta") "Parabéns!"))
  
  ; Enigma com solução numérica
  (check-equal?
    (criar-enigma "Qual é o número?" "42" '("é par" "maior que 40") "Você acertou!")
    (Enigma "Qual é o número?" "42" '("é par" "maior que 40") "Você acertou!"))
  
  ; Enigma sem pistas
  (check-equal?
    (criar-enigma "Enigma sem dicas" "segredo" '() "Muito bem!")
    (Enigma "Enigma sem dicas" "segredo" '() "Muito bem!"))
  
  ; Enigma com múltiplas pistas
  (check-equal?
    (criar-enigma 
      "Que animal é?" 
      "elefante" 
      '("tem tromba" "é grande" "vive na África" "tem presas") 
      "Excelente!")
    (Enigma 
      "Que animal é?" 
      "elefante" 
      '("tem tromba" "é grande" "vive na África" "tem presas") 
      "Excelente!"))

; Teste com enigma simples
  (check-equal? 
    (get-enigma-desc (Enigma "Qual é a cor do céu?" "azul" '("olhe para cima") "Acertou!"))
    "Qual é a cor do céu?")
  
  ; Teste com descrição longa
  (check-equal? 
    (get-enigma-desc 
      (Enigma "Em uma sala escura, há três interruptores. Um deles acende uma lâmpada em outra sala. Como descobrir qual é?"
              "teste cada um" 
              '("use a lógica") 
              "Muito bem!"))
    "Em uma sala escura, há três interruptores. Um deles acende uma lâmpada em outra sala. Como descobrir qual é?")
  
  ; Teste com descrição vazia
  (check-equal? 
    (get-enigma-desc (Enigma "" "nada" '() "Ok!"))
    "")
  
  ; Teste com descrição contendo números
  (check-equal? 
    (get-enigma-desc (Enigma "Quanto é 2 + 2?" "4" '("é básico") "Correto!"))
    "Quanto é 2 + 2?")

  ; Teste com solução simples
  (check-equal? 
    (get-enigma-solu (Enigma "Qual é a cor do céu?" "azul" '("olhe para cima") "Acertou!"))
    "azul")
  
  ; Teste com solução numérica
  (check-equal? 
    (get-enigma-solu (Enigma "Quanto é 2 + 2?" "4" '("é básico") "Correto!"))
    "4")
  
  ; Teste com solução sendo uma frase
  (check-equal? 
    (get-enigma-solu 
      (Enigma "Complete o ditado: Quem ri por último..." 
              "ri melhor"
              '("é um ditado popular") 
              "Muito bem!"))
    "ri melhor")
  
  ; Teste com solução vazia
  (check-equal? 
    (get-enigma-solu (Enigma "Enigma sem solução" "" '() "Ok!"))
    "")

; Teste com uma única pista
  (check-equal? 
    (get-enigma-pis (Enigma "Qual é a cor do céu?" "azul" '("olhe para cima") "Acertou!"))
    '("olhe para cima"))
  
  ; Teste com múltiplas pistas
  (check-equal? 
    (get-enigma-pis 
      (Enigma "Que animal é?" 
              "elefante" 
              '("tem tromba" "é grande" "vive na África") 
              "Muito bem!"))
    '("tem tromba" "é grande" "vive na África"))
  
  ; Teste com lista vazia de pistas
  (check-equal? 
    (get-enigma-pis (Enigma "Enigma sem pistas" "fácil" '() "Ok!"))
    '())
  
  ; Teste com pistas numéricas
  (check-equal? 
    (get-enigma-pis 
      (Enigma "Adivinhe o número" 
              "42" 
              '("é par" "maior que 40" "menor que 50") 
              "Correto!"))
    '("é par" "maior que 40" "menor que 50"))

; Teste com efeito simples
  (check-equal? 
    (get-enigma-efei (Enigma "Qual é a cor do céu?" "azul" '("olhe para cima") "Parabéns!"))
    "Parabéns!")
  
  ; Teste com efeito mais longo
  (check-equal? 
    (get-enigma-efei 
      (Enigma "Que animal é?" 
              "elefante" 
              '("tem tromba") 
              "Excelente! Você é muito bom em adivinhar animais!"))
    "Excelente! Você é muito bom em adivinhar animais!")
  
  ; Teste com efeito vazio
  (check-equal? 
    (get-enigma-efei (Enigma "Enigma sem efeito" "teste" '() ""))
    "")
  
  ; Teste com efeito contendo caracteres especiais
  (check-equal? 
    (get-enigma-efei 
      (Enigma "Adivinhe" 
              "teste" 
              '("dica") 
              "🎉 Uau!!! Você conseguiu! 🎊"))
    "🎉 Uau!!! Você conseguiu! 🎊")

; ultimo
; Teste com pilha de um elemento
(check-equal?
  (ultimo '(1))
  1)

; Teste com pilha de vários elementos
(check-equal?
  (ultimo '(1 2 3 4))
  4)

; Teste com pilha contendo diferentes tipos de dados
(check-equal?
  (ultimo '("a" "b" "c"))
  "c")

; Teste verificando recursão com pilha maior
(check-equal?
  (ultimo '(5 4 3 2 1))
  1)

; desempilha-rec

; Teste com pilha de um elemento
(check-equal?
 (desempilha-rec '(1))
 '())

; Teste com pilha de vários elementos
(check-equal?
 (desempilha-rec '(1 2 3 4))
 '(1 2 3))

; Teste verificando se mantém a ordem original
(check-equal?
 (desempilha-rec '(5 4 3 2 1))
 '(5 4 3 2))

; objeto-proximo

; Teste objeto próximo à esquerda 
(check-equal?
(objeto-proximo? 200 50 150 0 50 100)
#t)

; Teste objeto não próximo
(check-equal?
(objeto-proximo? 0 0 150 150 50 50)
#f)

; criar-objeto

; get-objeto-nome
(check-equal?
(get-objeto-name (Objeto "tv" "desc" "int"))
"tv")

; get-objeto-desc
; Teste get-objeto-desc
(check-equal?
(get-objeto-desc (Objeto "tv" '("desc1" "desc2") '("int1" "int2")))
"desc1")

; get-objeto-inte
; Teste get-objeto-inte posição 0
(check-equal?
 (get-objeto-inte (Objeto "tv" '("desc") '("int1" "int2" "int3")) 0)
 "int1")

; Teste get-objeto-inte posição 1 
(check-equal?
 (get-objeto-inte (Objeto "tv" '("desc") '("int1" "int2" "int3")) 1)
 "int2")

; Teste get-objeto-inte posição 2
(check-equal?
 (get-objeto-inte (Objeto "tv" '("desc") '("int1" "int2" "int3")) 2)
 "int3")

; get-velocidade
(check-equal? (get-velocidade) 30)

; get-nome
(begin
  (altera-nome "Player1")
  (check-equal? (get-nome) "Player1"))

; get-nome-dialogo
(begin
  (altera-nome "Player1")
  (check-equal? (get-nome-dialogo) "Player1 - (VOCÊ)"))

; pos-x
(begin
  (altera-posx 100)
  (check-equal? (pos-x) 100))

; pos-y
(begin
  (altera-posy 200)
  (check-equal? (pos-y) 200))

; get-ambiente
(begin
  (set-ambiente (Ambiente "Sala" "" empty empty empty))
  (check-equal? (get-ambiente) "Sala"))

; get-inventario
(begin
  (add-item "chave")
  (check-equal? (get-inventario) (list "chave")))

; Inventário

; esta-inv?
(check-equal? (esta-inv? "chave" (list "chave" "livro")) #true) ; Item presente
(check-equal? (esta-inv? "moeda" (list "chave" "livro")) #false) ; Item ausente
(check-equal? (esta-inv? "chave" empty) #false) ; Inventário vazio

; Verifica se a string não está vazia
(check-equal? (non-empty-string? "Olá") #t) ; String não vazia retorna verdadeiro
(check-equal? (non-empty-string? "") #f)    ; String vazia retorna falso
)

