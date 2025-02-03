#lang racket/gui

(require "Implementacao_logica.rkt")

;; Função para criar botões reutilizáveis
(define (criar-botao parent label callback)
  (new button%
       [parent parent]
       [label label]
       [font (make-font #:family 'modern #:size 25 #:weight 'bold)]
       [callback callback]
       [min-width 250]
       [min-height 60]))

;; ########################################### IMPLEMENTAÇÃO DA TELA INICIAL ############################################

;; Função para criar a tela inicial
(provide abrirTelaInicial)

(define (abrirTelaInicial)
  ;; TELA PRINCIPAL
  (define telaInicial (new frame%
                           [label "O PESADELO NA COZINHA FUTURÍSTICA."]
                           [width 1500]
                           [height 800]
                           [style '(no-resize-border)]))

  
  ;; Painel para organizar os elementos verticalmente
  (define painelPrincipal (new vertical-panel%
                               [parent telaInicial]
                               [stretchable-height #t]
                               [alignment '(center center)]))

  
    ;; Painel do título e subtítulo (margem superior maior)
  (define painelTitulo (new vertical-panel%
                            [parent painelPrincipal]
                            [border 10]))  ;; Adiciona uma margem para empurrar para cima

  
  ;; Adicionar o título e subtítulo
  (define titulo (new message%
                      [parent painelTitulo]
                      [label "ESCAPE ROOM"]
                      [font (make-font #:family 'modern #:size 80 #:weight 'bold)]
                      [min-width 750]))

  
  (define subTitulo (new message%
                         [parent painelTitulo]
                         [label "O PESADELO NA COZINHA FUTURÍSTICA"]
                         [font (make-font #:family 'modern #:size 50 #:weight 'bold)]
                         [min-width 750]))

  
  ;; Painel para o campo de texto do nome
  (define painelNome (new vertical-panel%
                          [parent painelPrincipal]
                          [alignment '(center center)]
                          [border 100]))

  
  ;; Adicionar o nome ou apelido
  (define nome (new message%
                    [parent painelNome]
                    [label "Digite um nome ou apelido:"]
                    [font (make-font #:family 'modern #:size 30 #:weight 'bold)]))

  
  (define nomeField (new text-field%
                         [parent painelNome]
                         [label ""]
                         [init-value ""]
                         [min-height 40]  ;; Aumenta a altura do campo de texto
                         [font (make-font #:family 'modern #:size 20)]))  ;; Aumenta o tamanho da fonte para 20))

  
  ;; Painel horizontal para os botões
  (define painelBotoes (new horizontal-panel%
                            [parent painelPrincipal]
                            [alignment '(center top)]
                            [border 30]))

  
  ;; Botões
  (criar-botao painelBotoes "CRÉDITOS" (lambda (button event)
                                         (message-box "Créditos"
                                                      "Desenvolvido por:\n\n Jean Massumi Tamura Aoyagui \n Matheus Foltran Consonni\n\n Agradecemos a sua participação!")))

  
  (criar-botao painelBotoes "JOGAR" (lambda (button event)
                                      (let* ([nome-jogador (send nomeField get-value)])
                                        (if (and (> (string-length nome-jogador) 0) (<= (string-length nome-jogador) 10))
                                            (begin
                                              (message-box "Bem-vindo" (string-append "Bem-vindo, " nome-jogador "! O jogo começou!"))
                                              ;; Deixa invisível a tela
                                              (send telaInicial show #f)
                                              ;; Altera o nome do jogador
                                              (altera-nome nome-jogador)
                                              ;; Chamada para a próxima função
                                              (exibir-narrativa))
                                            (if (> (string-length nome-jogador) 10)
                                                (message-box "Erro" "Digite um nome/apelido com no máximo 10 caracteres.")
                                                (message-box "Erro" "Por favor, insira um nome válido."))))))

  
  (criar-botao painelBotoes "TUTORIAL" (lambda (button event)
                                         (send telaTutorial show #t)))

  
    ;; Função para abrir o tutorial
  (define telaTutorial (new frame%    ;; A janela do tutorial é criada fora do evento
                              [label "TUTORIAL"]
                              [width 1000]
                              [height 700]
                              [style '(no-resize-border)]))


  ;; Função de Tutorial
  (define tutorial-label (new message%
                              [parent telaTutorial]
                              [label "Bem-vindo ao Escape Room! No jogo, você deve explorar ambientes, coletar objetos
e resolver enigmas para avançar.
Use sua lógica e atenção aos detalhes para escapar da cozinha futurística.
Boa sorte!"]
                              [font (make-font #:family 'modern #:size 15)]))


  
  ;; Centraliza e mostra a janela de tutorial
  (send telaTutorial center)
  
  ;; Centralizar e mostrar a janela
  (send telaInicial center)

  ;; Deixa vísivel a tela
  (send telaInicial show #t))


;; ################################################ FINALIZAÇÃO ################################################




;; ########################################### TELA DA PRIMEIRA NARRATIVA NARRATIVA ############################################

;; Função para exibir a narrativa inicial
(define (exibir-narrativa)

  ;; Variável para controlar o índice do texto atual
  (define texto-atual-index 0)

  
  (define narrativa-frame (new frame%
                              [label "O PESADELO NA COZINHA FUTURÍSTICA"]
                              [width 1500]
                              [height 800]
                              [style '(no-resize-border)]))

  
  ;; Painel principal que contém tudo
  (define main-panel (new vertical-panel% 
                         [parent narrativa-frame]
                         [style '(border)]))

  
  ;; Área para imagem de fundo/personagem (70% da altura)
  (define scene-panel (new canvas%
                          [parent main-panel]
                          [min-height 504]
                          [paint-callback
                           (lambda (canvas dc)
                             (when (< texto-atual-index (+ (length (Narrativa-imagens dados)) 3))
                               (let ([caminho (obter-imagem dados texto-atual-index)])
                                 (when (file-exists? caminho)
                                   (let ([bmp (make-object bitmap% caminho)])
                                     (when (send bmp ok?)
                                       (let* ([canvas-width (send canvas get-width)]
                                             [canvas-height (send canvas get-height)]
                                             [scale-x (/ canvas-width (send bmp get-width))]
                                             [scale-y (/ canvas-height (send bmp get-height))])
                                         (send dc set-scale scale-x scale-y)
                                         (send dc draw-bitmap bmp 0 0)
                                         (send dc set-scale 1 1))))))))]))

  
  ;; Painel para a caixa de diálogo (30% da altura)
  (define dialog-panel (new vertical-panel%
                           [parent main-panel]
                           [min-height 216]
                           [style '(border)]))

  
  ;; Painel para nome do personagem
  (define name-panel (new horizontal-panel%
                         [parent dialog-panel]
                         [min-height 30]
                         [style '(border)]))

  
  ;; Label para o nome do personagem
  (define name-label (new message%
                         [parent name-panel]
                         [label (obter-nome-narrador texto-atual-index)]
                         [font (make-object font% 20 'default 'normal 'bold)]))

  
  ;; Área de texto do diálogo
  (define texto (new text%))
  (define canvas (new editor-canvas%
                     [parent dialog-panel]
                     [style '(no-hscroll auto-vscroll)]
                     [min-width 1200]
                     [min-height 150]))

  
  ;; Configurar quebra automática de linha
  (send texto set-max-width 1150)
  (send texto auto-wrap #t)

  
  
  ;; Painel para botões de controle
  (define button-panel (new horizontal-panel%
                           [parent dialog-panel]
                           [alignment '(right center)]
                           [stretchable-height #f]
                           [min-height 40]))

  
  ;; Botões de controle
  (define botao-anterior (new button%
                             [parent button-panel]
                             [label "◄"]
                             [min-width 60]
                             [min-height 35]
                             [font (make-object font% 18 'default 'normal 'bold)]
                             [callback (lambda (button event)
                                       (texto-anterior))]))

  
  (define botao-skip (new button%
                         [parent button-panel]
                         [label "Skip"]
                         [min-width 80]
                         [min-height 35]
                         [font (make-object font% 18 'default 'normal 'bold)]
                         [callback (lambda (button event)
                                   (send narrativa-frame show #f)
                                     (start-game))]))

  
  (define botao-proximo (new button%
                            [parent button-panel]
                            [label "►"]
                            [min-width 60]
                            [min-height 35]
                            [font (make-object font% 18 'default 'normal 'bold)]
                            [callback (lambda (button event)
                                      (proximo-texto))]))

  

   ;; Função para atualizar o texto e a imagem
  (define (atualizar-texto)
    (send texto lock #f)
    (send texto erase)
    (define fala (obter-texto dados texto-atual-index))

    ;; Habilita/desabilita botões baseado no índice
    (send botao-anterior enable (> texto-atual-index 0))
    
    ;; Atualiza o nome do personagem com base no índice
    (send name-label set-label
          (obter-nome-narrador texto-atual-index))
    
    (send texto change-style
          (make-object style-delta% 'change-family 'modern))
    (send texto change-style
          (make-object style-delta% 'change-size 25))
    (send texto insert fala)
    (send texto lock #t)
    (send scene-panel refresh))  ; Atualiza a imagem de fundo

  
  ;; Função para avançar o texto
  (define (proximo-texto)
    (if (< texto-atual-index (- (length (Narrativa-textos dados)) 1))
        (begin
          (set! texto-atual-index (+ texto-atual-index 1))
          (atualizar-texto))
        (begin
          (send narrativa-frame show #f)
          (start-game))))

  
  ;; Função para voltar o texto
  (define (texto-anterior)
    (when (> texto-atual-index 0)
      (set! texto-atual-index (- texto-atual-index 1))
      (atualizar-texto)))

  
  ;; Configurar o texto inicial
  (atualizar-texto)
  (send canvas set-editor texto)

  
  ;; Mostrar a janela centralizada
  (send narrativa-frame center)
  
  ;; Deixa visível a tela inicial
  (send narrativa-frame show #t))


;; ########################################### FINALIZAÇÃO ############################################



;; ########################################### TELA DA JANELA DO INVENTARIO DO JOGADOR ############################################

; Função que desenha um único item
(define (desenhar-item dc item-pos)
  (let ([item (first item-pos)]
        [pos (second item-pos)])
    (send dc set-brush "white" 'solid)
    (send dc draw-rectangle 490 (- pos 5) 520 35)
    (send dc draw-text (format "~a" item) 720 pos)))


; Função principal que desenha o inventário
(define (visual-inventario dc)
  (define desenhar-item-dc (curry desenhar-item dc))

  ; Função recursiva
  (define (criar-item-visual item y)
    (lambda ()
      (send dc set-brush "white" 'solid)
      (send dc draw-rectangle 490 (- y 5) 520 35)
      (send dc draw-text (format "~a" item) 680 y)))
  
  (if (= (get-tam) 0)
      (send dc draw-text "Nenhum item no inventário" 550 300)
      (let ([visualizacoes
             ; Função de alta ordem Map e Lambda
             (map (lambda (item y) (criar-item-visual item y))
                  (get-inventario)
                  (build-list (length (get-inventario))
                            (lambda (i) (+ 310 (* i 35)))))])
        (map (lambda (f) (f)) visualizacoes))))



;; ########################################### FINALIZAÇÃO ############################################


;; ########################################### TELA DO PRIMEIRO AMBIENTE DO JOGO ############################################
(define porta-aberta-a #f)
(define uma-vez #f)

(define (start-game)
  
  ; Classe canvas personalizada para lidar com eventos de teclado
  (define my-canvas%
    (class canvas%
      (super-new)
      (define/override (on-char event)
        (let* ([key (send event get-key-code)]
               [atual-x (pos-x)]
               [atual-y (pos-y)]
               [velocidade (get-velocidade)])
          (cond
            ; Movimento apenas quando o jogador não está travado
            [(and (not jogador-bloqueado?) (equal? key #\w))
             (let ([new-y (max 50 (- atual-y velocidade))])
               (if (not (verifica-colisao atual-x new-y objetos-cozinha))
                   (altera-posy new-y)
                   (void)))]
            [(and (not jogador-bloqueado?) (equal? key #\s))
             (let ([new-y (min 710 (+ atual-y velocidade))])
               (if (not (verifica-colisao atual-x new-y objetos-cozinha))
                   (altera-posy new-y)
                   (void)))]
            [(and (not jogador-bloqueado?) (equal? key #\a))
             (let ([new-x (max 50 (- atual-x velocidade))])
               (if (not (verifica-colisao new-x atual-y objetos-cozinha))
                   (altera-posx new-x)
                   (void)))]
            [(and (not jogador-bloqueado?) (equal? key #\d))
             (let ([new-x (min 1410 (+ atual-x velocidade))])
               (if (not (verifica-colisao new-x atual-y objetos-cozinha))
                   (altera-posx new-x)
                   (void)))]
            [(and (not jogador-bloqueado?) (equal? key #\e))
             (cond
               ;; Geladeira
               [(objeto-proximo? (pos-x) (pos-y) 50 320 200 110)
                (mostrar-mensagem-dialogo (get-nome-dialogo) (get-objeto-desc obj-geladeira))]

               ;; Fogão
               [(objeto-proximo? (pos-x) (pos-y) 790 290 140 70)
                (mostrar-mensagem-dialogo (get-nome-dialogo) (get-objeto-desc obj-fogao))]

               ;; Pia Superior
               [(objeto-proximo? (pos-x) (pos-y) 110 50 190 150)
                (mostrar-tela-pratos)]

               ;; Pia Inferior
               [(objeto-proximo? (pos-x) (pos-y) 780 570 170 130)
                (mostrar-mensagem-dialogo (get-nome-dialogo) (get-objeto-desc obj-pia-inf))]

               ;; Lava Louças
               [(objeto-proximo? (pos-x) (pos-y) 400 50 80 150)
                (mostrar-mensagem-dialogo (get-nome-dialogo) (get-objeto-desc obj-lava-loucas))]

               ;; Bancada Central
               [(objeto-proximo? (pos-x) (pos-y) 370 290 320 180)
                (mostrar-tela-bancada)]

               ;; Bancada Inferior
               [(objeto-proximo? (pos-x) (pos-y) 570 570 80 130)
                (mostrar-mensagem-dialogo (get-nome-dialogo) (get-objeto-desc obj-bancada-inf))]

               ;; Armário 1 (VERDE)
               [(objeto-proximo? (pos-x) (pos-y) 110 570 140 130)
                (mostrar-armario-verde)] 

               ;; Armário 2 (VERMELHO)
               [(objeto-proximo? (pos-x) (pos-y) 1230 570 140 130)
                (mostrar-armario-vermelho)]

               ;; Armário 3 (AMARELO)
               [(objeto-proximo? (pos-x) (pos-y) 1230 60 140 130)
                (mostrar-armario-amarelo)]
               
               ;; Porta do armazém
               [(objeto-proximo? (pos-x) (pos-y) 720 50 140 40)
                (when (esta-inv? (get-enigma-efei  pedidos) (get-inventario))
                  (set! porta-aberta-a #t))

                (cond
                  [porta-aberta-a
                   (send cozinha show #f)
                   (altera-posx 730)
                   (altera-posy 650)
                   (mostrar-armazem)]

                  [else
                   (mostrar-mensagem-dialogo (get-nome-dialogo) (get-objeto-desc obj-porta-armazem))]
                    )]

               ;; Porta de saída
               [(objeto-proximo? (pos-x) (pos-y) 1370 320 50 80)
                (mostrar-mensagem-dialogo (get-nome-dialogo) (get-objeto-desc obj-porta-saida))]

               ; Byte
               [(objeto-proximo? (pos-x) (pos-y) 1025 90 35 45) 
                (mostrar-mensagem-dialogo (get-nome-robo) (byte-dicas))])]

            ; Tecla TAB para abrir o inventario
            [(and (not mostrar-dialogo) (not mapa-aberto) (equal? key #\tab))
             (alternar-inventario)]

            ; Tecla Q para explorar o mapa
            [(and (not mostrar-dialogo) (not inventario-aberto) (equal? key #\q))
             (alternar-mapa)]
            
            
            ; Tecla ESPAÇO para passar os dialogos
            [(and (not inventario-aberto) (not mapa-aberto) (equal? key #\space))
             (esconder-dialogo)])
          
          (send this refresh)))))

  (define cozinha (new frame%
                      [label "O PESADELO NA COZINHA FUTURÍSTICA"]
                      [width 1500]
                      [height 800]
                      [style '(no-resize-border)]))
  

  (define canvas (new my-canvas% 
                     [parent cozinha]
                     [paint-callback
                      (lambda (canvas dc)

                        ; Primeiro, preencha todo o canvas com a cor de fundo desejada
                        (send dc set-brush "brown" 'solid)  ; Aqui você pode mudar a cor
                        (send dc draw-rectangle 0 0 1500 800)   ; Desenha retângulo cobrindo todo canvas
                        
                        ; Configuração da fonte
                        (send dc set-font (make-object font% 14 'default))
                        (send dc set-text-foreground "black")

                        ; Retângulo branco para destacar o texto
                        (send dc set-brush "white" 'solid)
                        (send dc draw-rectangle 690 5 200 40)
                        
                        ; Área da cozinha
                        (send dc set-brush "beige" 'solid)
                        (send dc set-pen "black" 1 'solid)
                        (send dc draw-rectangle 50 50 1400 700)
                        (send dc draw-text "COZINHA" 740 10)
                        
                        ; Geladeira
                        (send dc set-brush "gray" 'solid)
                        (send dc draw-rectangle 50 320 200 170)
                        (when (objeto-proximo? (pos-x) (pos-y) 50 290 200 180)
                          (send dc draw-text (get-objeto-name obj-geladeira) 110 380))
                        
                        ; Pia na parte Superior
                        (send dc set-brush "lightgray" 'solid)
                        (send dc draw-rectangle 50 50 350 150)
                        (when (objeto-proximo? (pos-x) (pos-y) 50 40 280 150)
                          (send dc draw-text (get-objeto-name obj-pia-sup) 200 110))
                        
                        ; Pia na parte inferior
                        (send dc set-brush "lightgray" 'solid)
                        (send dc draw-rectangle 750 600 300 150)
                        (when (objeto-proximo? (pos-x) (pos-y) 780 570 250 150)
                          (send dc draw-text (get-objeto-name obj-pia-inf) 870 650))
                        
                        ; Lava louças - Quebrada
                        (send dc set-brush "lightgray" 'solid)
                        (send dc draw-rectangle 400 50 150 150)
                        (when (objeto-proximo? (pos-x) (pos-y) 400 40 150 150)
                          (send dc draw-text (get-objeto-name obj-lava-loucas) 420 110))
     
                        ; Bancada central
                        (send dc set-brush "gray" 'solid)
                        (send dc draw-rectangle 400 320 350 170)
                        (when (objeto-proximo? (pos-x) (pos-y) 370 290 320 180)
                          (send dc draw-text (get-objeto-name obj-bancada-cen) 540 380))

                        ; Bancada na parte inferior
                        (send dc set-brush "gray" 'solid)
                        (send dc draw-rectangle 500 600 250 150)
                        (when (objeto-proximo? (pos-x) (pos-y) 480 570 230 150)
                          (send dc draw-text (get-objeto-name obj-bancada-inf) 580 650))

                        ; Armário 1 (VERDE)
                        (send dc set-brush "green" 'solid)
                        (send dc draw-rectangle 50 600 260 150)
                        (when (objeto-proximo? (pos-x) (pos-y) 30 570 250 150)
                          (send dc draw-text (get-objeto-name obj-armario-verd) 130 650))

                        ; Armário 2 (VERMELHO)
                        (send dc set-brush "red" 'solid)
                        (send dc draw-rectangle 1190 600 260 150)
                        (when (objeto-proximo? (pos-x) (pos-y) 1160 570 250 150)
                          (send dc draw-text (get-objeto-name obj-armario-verm) 1250 650))

                        ; Armário 3 (AMARELO)
                        (send dc set-brush "yellow" 'solid)
                        (send dc draw-rectangle 1190 50 260 150)
                        (when (objeto-proximo? (pos-x) (pos-y) 1160 40 250 150)
                          (send dc draw-text (get-objeto-name obj-armario-amar) 1250 110))

                        ; Byte
                        (send dc set-brush "cyan" 'solid)
                        (send dc draw-ellipse 1050 130 35 35)
                        (send dc draw-text (get-nome-robo) 1025 105)  

                        ; Jogador com nome
                        (send dc set-brush "red" 'solid)
                        (send dc draw-ellipse (pos-x) (pos-y) 40 40)
                        (send dc draw-text "VOCÊ" (- (pos-x) 5) (- (pos-y) 22))
                             
                        ; Fogão
                        (send dc set-brush "black" 'solid)
                        (send dc draw-rectangle 750 320 270 170)
                        (send dc set-text-foreground "white")
                        (when (objeto-proximo? (pos-x) (pos-y) 740 290 250 180)
                          (send dc draw-text (get-objeto-name obj-fogao) 850 380))
     
                        ; Porta do armazem
                        (send dc set-brush "black" 'solid)
                        (send dc draw-rectangle 670 50 260 40)
                        (when (objeto-proximo? (pos-x) (pos-y) 660 50 250 40)
                          (send dc draw-text (get-objeto-name obj-porta-armazem) 760 60))

                        ; Porta de saída
                        (send dc set-brush "darkgray" 'solid)
                        (send dc draw-rectangle 1395 320 55 150)
                        (send dc set-text-foreground "black")
                        (when (objeto-proximo? (pos-x) (pos-y) 1370 310 50 140)
                          (send dc draw-text (get-objeto-name obj-porta-saida) 1400 380))
                      
                        ; Mensagens de interação
                        (cond
                          ;; Geladeira
                          [(objeto-proximo? (pos-x) (pos-y) 50 320 200 110)
                           (send dc draw-text (press-e) (- (pos-x) 55) (- (pos-y) 55))]

                          ;; Fogão
                          [(objeto-proximo? (pos-x) (pos-y) 790 290 140 70)
                           (send dc draw-text (press-e) (- (pos-x) 55) (- (pos-y) 55))]

                          ;; Pia Superior
                          [(objeto-proximo? (pos-x) (pos-y) 110 60 190 130)
                           (send dc draw-text (press-e) (- (pos-x) 55) (- (pos-y) -50))]

                          ;; Pia Inferior
                          [(objeto-proximo? (pos-x) (pos-y) 780 570 170 130)
                           (send dc draw-text (press-e) (- (pos-x) 55) (- (pos-y) 55))]

                          ;; Lava Louças
                          [(objeto-proximo? (pos-x) (pos-y) 400 60 80 130)
                           (send dc draw-text (press-e) (- (pos-x) 55) (- (pos-y) -50))]

                          ;; Bancada Central
                          [(objeto-proximo? (pos-x) (pos-y) 370 290 320 180)
                           (send dc draw-text (press-e) (- (pos-x) 55) (- (pos-y) 55))]

                          ;; Bancada Inferior
                          [(objeto-proximo? (pos-x) (pos-y) 570 570 80 130)
                           (send dc draw-text (press-e) (- (pos-x) 55) (- (pos-y) 55))]

                          ;; Armário 1 (VERDE)
                          [(objeto-proximo? (pos-x) (pos-y) 110 570 140 130)
                           (send dc draw-text (press-e) (- (pos-x) 55) (- (pos-y) 55))]

                          ;; Armário 2 (VERMELHO)
                          [(objeto-proximo? (pos-x) (pos-y) 1230 570 140 130)
                           (send dc draw-text (press-e) (- (pos-x) 55) (- (pos-y) 55))]

                          ;; Armário 3 (LARANJA ESCURO)
                          [(objeto-proximo? (pos-x) (pos-y) 1230 60 140 130)
                           (send dc draw-text (press-e) (- (pos-x) 55) (- (pos-y) -50))]

                          ;; Porta do armazém
                          [(objeto-proximo? (pos-x) (pos-y) 710 50 140 40)
                           (send dc draw-text (press-e) (- (pos-x) 65) (- (pos-y) -50))]

                          ;; Porta de saída
                          [(objeto-proximo? (pos-x) (pos-y) 1370 320 50 80)
                           (send dc draw-text (press-e) (- (pos-x) 105) (- (pos-y) 55))]

                          ;; Byte
                          [(objeto-proximo? (pos-x) (pos-y) 1025 90 35 45)
                           (send dc draw-text (press-e) (- (pos-x) 55) (- (pos-y) -50))]) 
                        
                        (when  mostrar-dialogo
                          ; Primeiro desenha um retângulo semi-transparente para escurecer o fundo
                          (send dc set-brush (make-object color% 0 0 0 0.5) 'solid)
                          (send dc draw-rectangle 0 650 1500 150)
          
                          ; Desenha a caixa de diálogo principal (branca)
                          (send dc set-brush "white" 'solid)
                          (send dc set-pen "black" 2 'solid)
                          (send dc draw-rectangle 0 630 1500 250)
          
                          ; Área colorida para o nome do falante (um retângulo mais escuro no topo)
                          (send dc set-brush "lightsteelblue" 'solid)  ; Cor suave para o fundo do nome
                          (send dc draw-rectangle 0 590 1500 50)  ; Retângulo colorido apenas para a área do nome
          
                          ; Configurar fonte para o nome do falante
                          (send dc set-font (make-object font% 23 'default 'normal 'bold))
                          (send dc set-text-foreground "darkblue")
                          (send dc draw-text falante-atual 20 595) 
          
                          ; Configurar fonte para o texto do diálogo
                          (send dc set-font (make-object font% 20 'default))
                          (send dc set-text-foreground "black")
                          
                          ; Quebrar e desenhar o texto em múltiplas linhas
                          (let ([linhas (quebrar-texto dc texto-dialogo-atual (- largura-maxima-texto 40))])
                            (for/list ([linha linhas]
                                       [i (in-range (length linhas))])
                              (send dc draw-text linha 20 (+ 640 (* i altura-linha)))))
          
                          ; Indicador "Espaço para passar"
                          (send dc set-font (make-object font% 14 'default 'normal 'bold))
                          (send dc set-text-foreground "gray")
                          (send dc draw-text "Pressione espaço para continuar." 1180 770))

                        
                        ; Desenhar o inventário quando estiver aberto
                        (when inventario-aberto
                          ; Fundo semi-transparente
                          (send dc set-brush (make-object color% 0 0 0 0.5) 'solid)
                          (send dc draw-rectangle 0 0 1500 800)
                          
                          ; Janela do inventário
                          (send dc set-brush "lightgray" 'solid)
                          (send dc set-pen "black" 2 'solid)
                          (send dc draw-rectangle 450 150 600 500)
                          
                          ; Título do inventário
                          (send dc set-font (make-object font% 24 'default 'normal 'bold))
                          (send dc set-text-foreground "black")
                          (send dc draw-text "INVENTÁRIO" 650 170)
                          
                          ; Informações do jogador
                          (send dc set-font (make-object font% 18 'default))
                          (send dc draw-text (string-append "Nome: " (Jogador-nome jogador)) 480 220)
                          
                          ; Área dos itens
                          (send dc draw-rectangle 480 260 540 350)
                          (send dc set-font (make-object font% 16 'default))
                          (send dc draw-text "Itens:" 490 270)
                          
                          ; Lista de itens (vazia por enquanto)
                          (send dc set-font (make-object font% 16 'default))
                          (visual-inventario dc)
                          
                          ; Instruções
                          (send dc set-text-foreground "black")
                          (send dc draw-text "Pressione TAB para fechar" 630 615))

                        ; Desenhar o mapa quando estiver aberto
                        (when mapa-aberto
                          ; Fundo semi-transparente
                          (send dc set-brush (make-object color% 0 0 0 0.5) 'solid)
                          (send dc draw-rectangle 0 0 1500 800)
    
                          ; Janela do mapa
                          (send dc set-brush "lightgray" 'solid)
                          (send dc set-pen "black" 2 'solid)
                          (send dc draw-rectangle 350 100 800 630)
    
                          ; Título
                          (send dc set-font (make-object font% 24 'default 'normal 'bold))
                          (send dc set-text-foreground "black")
                          (send dc draw-text "MAPA DE EXPLORAÇÃO" 570 120)

                          ; Linha separadora após o título
                          (send dc set-pen "black" 3 'solid)
                          (send dc draw-line 380 160 1120 160)
                          
                          
                          ; Informações do ambiente
                          (send dc set-font (make-object font% 18 'default))
                          (send dc draw-text "Local: Cozinha" 380 170)
    
                          ; Descrição
                          (send dc set-font (make-object font% 16 'default))
                          (send dc draw-text "Descrição:" 380 220)
                          (desenhar-texto-quebrado dc 
                                             (get-desc-ambiente jogador)
                                             380 250 
                                             700)

                          ; Linha separadora após descrição
                          (send dc draw-line 380 345 1120 345)
    
                          ; Objetos presentes
                          (send dc draw-text "Objetos presentes:" 380 350)
                          ; Exploração de objetos
                          (desenhar-objetos-rec dc (Ambiente-objetos (Jogador-localizacao jogador)) 380)
                          
                          ; Linha separadora antes das saídas
                          (send dc draw-line 380 560 1120 560)

                          ; Saídas
                          (send dc draw-text "Saídas disponíveis:" 380 570)
                          ; Exploração de saídas
                          (desenhar-saidas-rec dc (Ambiente-saidas (Jogador-localizacao jogador)) 600)

                          ; Linha separadora antes da tecla Q
                          (send dc draw-line 380 680 1120 680)
                          
                          ; Instruções
                          (send dc draw-text "Pressione Q para fechar" 620 690)))]
                     
                     [style '(border)]
                     [min-width 1500]
                     [min-height 800]))


  
  ; Mostra a janela centralizada
  (send cozinha center)
  (send cozinha show #t)

  (send canvas focus)

  (when (not uma-vez)
    (set! uma-vez #t)
    ; Inicia o diálogo inicial
    (iniciar-sequencia-dialogos (get-nome-robo) (Dialogo-inicio dialogo))))


;; ########################################### FINALIZAÇÃO ############################################



;; ################################################ TELA ENIGMA PILHA DE PRATOS #####################################################################

; Variáveis globais para controlar o estado dos pratos durante a execução
(define pratos-sujos-global 10)
(define pratos-limpos-global 0)
(define prato-na-pia-global #f)
(define morse-codes #("." "..." "-.-." ".-" ".--." "."))

; Função para mostrar a tela de lavar pratos
(define (mostrar-tela-pratos)
  
  (define pratos-frame (new dialog%
                           [label "ENIGMA - PILHA DE PRATOS"]
                           [width 1200]
                           [height 700]
                           [stretchable-width #f]    
                           [stretchable-height #f]))
  
  ; Função recursiva para desenhar pratos sujos
  (define (desenhar-pratos-sujos dc quantidade y)
    (when (> quantidade 0)
      ; Primeiro desenha os pratos de trás
      (desenhar-pratos-sujos dc (- quantidade 1) y)
      ; Depois desenha o prato atual (para ficar por cima)
      (send dc draw-ellipse 
            140  
            (- y (* 25 quantidade))  
            150   
            45))) 

  
  ; Função recursiva para desenhar pratos limpos
  (define (desenhar-pratos-limpos dc quantidade y)
    (when (> quantidade 0)
      (let ([i (- quantidade 1)])
        ; Primeiro desenha os pratos de trás
        (desenhar-pratos-limpos dc i y)
        ; Depois desenha o prato atual (para ficar por cima)
        (let ([prato-y (- y (* 25 quantidade))])
          ; Desenha o prato
          (send dc draw-ellipse 
                940  
                prato-y
                150   
                45)  
          ; Adicionar o código Morse dentro do prato
          (when (< i (vector-length morse-codes))
            (let* ([code (vector-ref morse-codes i)]
                   [width (let-values ([(w h d a) (send dc get-text-extent code)])
                           w)])
              (send dc set-text-foreground "black")
              ; Define uma fonte menor para o código morse
              (send dc set-font (make-object font% 16 'default))
              ; Desenha o código morse centralizado na parte inferior do prato
              (send dc draw-text 
                    code
                    (- (+ 940 75) (/ width 2))  ; Centralizado horizontalmente no prato
                    (+ prato-y 15))             ; Posicionado na parte inferior do prato
              ; Restaura a fonte original
              (send dc set-font (make-object font% 18 'default))))))))
  
  ; Canvas personalizado com eventos de mouse
  (define pratos-canvas% 
    (class canvas%
      (super-new)
      (inherit get-dc)
      
      ; Estado dos pratos - inicializado com valores globais
      (define pratos-sujos pratos-sujos-global)
      (define pratos-limpos pratos-limpos-global)
      (define prato-na-pia prato-na-pia-global)
      
      ; Adicionar handling de teclado para o diálogo
      (define/override (on-char event)
        (when (and mostrar-dialogo
                   (equal? (send event get-key-code) #\space))
          (esconder-dialogo)
          (send this refresh)))
      
      (define/override (on-event event)
        (when (send event button-down? 'left)
          (let ([x (send event get-x)]
                [y (send event get-y)])
            ; Área dos botões
            (cond
              ; Botão Desempilhar
              [(and (>= x 400) (<= x 550)
                    (>= y 500) (<= y 550))
               (when (and (> pratos-sujos 0) (not prato-na-pia) (not mostrar-dialogo))
                 (set! pratos-sujos (- pratos-sujos 1))
                 (set! prato-na-pia #t)
                 ; Atualizar variáveis globais
                 (set! pratos-sujos-global pratos-sujos)
                 (set! prato-na-pia-global prato-na-pia)
                 (send this refresh)

                 (when (< pratos-sujos 6)
                   ; Parte Lógica
                   (desempilha)))]
              
              ; Botão Lavar
              [(and (>= x 650) (<= x 800)
                    (>= y 500) (<= y 550))
               (when (and prato-na-pia (not mostrar-dialogo))
                 (set! prato-na-pia #f)
                 (set! pratos-limpos (+ pratos-limpos 1))
                 ; Atualizar variáveis globais
                 (set! prato-na-pia-global prato-na-pia)
                 (set! pratos-limpos-global pratos-limpos)
                 (send this refresh)

                 ; Parte lógica
                 (empilha lavar)

                 (when (and (empty? pilha-suja) (equal? lavar void))
                   ;; Resolvido?
                   (concluido-pilha?)))]
              
              ; Botão Voltar
              [(and (>= x 1080) (<= x 1180)
                    (>= y 630) (<= y 680)
                    (not mostrar-dialogo))
               (send pratos-frame show #f)]))))
      
      (define/override (on-paint)
        (let ([dc (get-dc)])
          ; Fundo cinza da área
          (send dc set-brush "gray" 'solid)
          (send dc draw-rectangle 0 0 1200 700)
          
          ; Pia (retângulo mais claro)
          (send dc set-brush "lightblue" 'solid)
          (send dc draw-rectangle 480 200 250 250)
          
          ; Pilha de pratos sujos (lado esquerdo)
          (send dc set-brush "brown" 'solid)
          (desenhar-pratos-sujos dc pratos-sujos 430)
          
          ; Prato na pia (se houver)
          (when prato-na-pia
            (send dc set-brush "brown" 'solid)
            (send dc draw-ellipse 530 310 140 35))
          
          ; Pilha de pratos limpos (lado direito) com códigos Morse
          (send dc set-brush "white" 'solid)
          (desenhar-pratos-limpos dc pratos-limpos 430)
          
          ; Botões
          (send dc set-brush "lightgreen" 'solid)
          ; Botão Desempilhar
          (send dc draw-rectangle 400 500 150 50)
          ; Botão Lavar
          (send dc draw-rectangle 650 500 150 50)
          ; Botão Voltar
          (send dc draw-rectangle 1080 630 100 50)
          
          ; Textos dos botões
          (send dc set-font (make-object font% 16 'default))
          (send dc set-text-foreground "black")
          (send dc draw-text (get-objeto-inte obj-pia-sup 0) 415 515)
          (send dc draw-text (get-objeto-inte obj-pia-sup 1) 695 515)
          (send dc draw-text "Voltar" 1100 645)
          
          ; Textos indicativos das áreas
          (send dc draw-text "Pratos Sujos" 150 130)
          (send dc draw-text (get-objeto-name obj-pia-sup) 585 160)
          (send dc draw-text "Pratos Limpos" 950 130)

           ; Desenhar caixa de diálogo se necessário
          (when mostrar-dialogo
            ; Primeiro desenha um retângulo semi-transparente para escurecer o fundo
            (send dc set-brush (make-object color% 0 0 0 0.5) 'solid)
            (send dc draw-rectangle 0 650 1200 150)
            
            ; Desenha a caixa de diálogo principal (branca)
            (send dc set-brush "white" 'solid)
            (send dc set-pen "black" 2 'solid)
            (send dc draw-rectangle 0 510 1200 200)
            
            ; Área colorida para o nome do falante
            (send dc set-brush "lightsteelblue" 'solid)
            (send dc draw-rectangle 0 470 1200 50)
            
            ; Configurar fonte para o nome do falante
            (send dc set-font (make-object font% 23 'default 'normal 'bold))
            (send dc set-text-foreground "darkblue")
            (send dc draw-text falante-atual 20 475)
            
            ; Configurar fonte para o texto do diálogo
            (send dc set-font (make-object font% 20 'default))
            (send dc set-text-foreground "black")
            
            ; Quebrar e desenhar o texto em múltiplas linhas
            (let ([linhas (quebrar-texto dc texto-dialogo-atual (- 1150 40))])
              (for/list ([linha linhas]
                        [i (in-range (length linhas))])
                (send dc draw-text linha 20 (+ 525 (* i altura-linha)))))
            
            ; Indicador "Espaço para passar"
            (send dc set-font (make-object font% 14 'default 'normal 'bold))
            (send dc set-text-foreground "gray")
            (send dc draw-text "Pressione espaço para continuar." 880 670))))))

  
  ; Instanciar o canvas personalizado
  (define pratos-canvas (new pratos-canvas%
                            [parent pratos-frame]
                            [style '(border)]
                            [min-width 1200]
                            [min-height 700]))

  (if estado-prato
      ; Dialogo de enigma finalizado
      (mostrar-mensagem-dialogo (get-narrador) (get-objeto-desc obj-pia-sup))
     
      ; Inicia o diálogo da descrição do Enigma da Pilha de Pratos
      (iniciar-sequencia-dialogos (get-nome-robo) (Dialogo-pilha dialogo))
      ) 
  (send pratos-canvas focus)
  
  ; Mostrar a janela centralizada
  (send pratos-frame center)
  (send pratos-frame show #t)
  )

;; ########################################### FINALIZAÇÃO ############################################






;; ########################################### TELA DO ARMÁRIO VERMELHO ############################################

; Verifição final da senha

(define (criar-autenticacao)
  ; Cria o frame de diálogo
  (define senha-frame (new dialog%
                           [label "Autenticação"]
                           [width 300]
                           [height 100]))
  
  ; Campo de texto para senha
  (define senha-campo (new text-field%
                           [parent senha-frame]
                           [label "Digite a senha:"]
                           [init-value ""]
                           [style '(single)]))
  
  ; Botão de confirmação
  (new button%
       [parent senha-frame]
       [label "Confirmar"]
       [callback (lambda (button event)
                   (let ([senha-digitada (send senha-campo get-value)])
                     (if (equal? senha-digitada "Takao Kato")
                         (begin
                           (send senha-frame show #f)
                           (iniciar-sequencia-dialogos (get-nome-robo) (Dialogo-finais-armario-v enigma-feito)))
                           (message-box "Erro" "Senha incorreta!" 
                                      #f '(ok stop)))))])
  
  ; Centraliza e exibe o diálogo
  (send senha-frame center)
  (send senha-frame show #t)
  (send senha-campo focus))




; Variáveis globais
(define porta-esquerda-verificada2 #f)
(define porta-direita-verificada2 #f)
(define gaveta1-verificada2 #f)
(define gaveta2-verificada2 #f)


; Função para mostrar o armário verde
(define (mostrar-armario-vermelho)
  
  (define armario-frame (new dialog%
                            [label "Armário Vermelho"]
                            [width 1200]
                            [height 700]
                            [stretchable-width #f]    
                            [stretchable-height #f]))
  
  ; Canvas personalizado com eventos de mouse
  (define armario-canvas% 
    (class canvas%
      (super-new)
   
      ; Gerenciar eventos de mouse
      (define/override (on-event event)
        (when (send event button-down? 'left)
          (let ([x (send event get-x)]
                [y (send event get-y)])
            (cond
              ; Click na porta esquerda
              [(and (>= x 360) (<= x 600)
                    (>= y 70) (<= y 330))
               (set! porta-esquerda-verificada2 #t)
               (mostrar-mensagem-dialogo (get-nome-robo) "Não adianta forçar a entrada. O que está atrás dessa porta é privado, e não é para olhos curiosos.")
               (send this refresh)]
              
              ; Click na porta direita  
              [(and (>= x 600) (<= x 840)
                    (>= y 70) (<= y 330))
               (set! porta-direita-verificada2 #t)
               (mostrar-mensagem-dialogo (get-nome-robo) "A gaveta está trancada e ninguém mais pode abri-la. O que está dentro é exclusivamente do CHEFE!.")
               (send this refresh)]
              
              ; Click na primeira gaveta
              [(and (>= x (- (/ 1200 2) 200))
                    (<= x (+ (/ 1200 2) 200))
                    (>= y 350)
                    (<= y 420))
               (set! gaveta1-verificada2 #t)
               (mostrar-mensagem-dialogo (get-nome-robo) "Esta gaveta está trancada para todos, exceto para quem tem o direito de conhecer seus segredos. Não há chaves aqui que você possa usar.")
               (send this refresh)]

              ; Click na segunda gaveta
              [(and (>= x (- (/ 1200 2) 200))
                    (<= x (+ (/ 1200 2) 200))
                    (>= y 430)
                    (<= y 500))
               (set! gaveta2-verificada2 #t)
               (aberto?)

               (cond
                 [(and estado-prato estado-livro estado-quiz estado-pedidos)
                  (criar-autenticacao)] ;chama o terminal
                 
                 [else
                  ; Verifica se o jogador tem a chave
                  (mostrar-mensagem-dialogo (get-nome-robo) "O que está dentro dessa gaveta é privado, e só será acessível quando todos os enigmas forem solucionados. Então, o terminal permitirá que você insira o código.")]
                 )

               (send this refresh)]

              ; Botao de voltar
              ; No on-event, adicione mais uma condição no cond:
              [(and (>= x 1050) (<= x 1150)  ; área x do botão
                    (>= y 600) (<= y 650))   ; área y do botão
               (send armario-frame show #f)
               ]))))
      
      ; Permitir fechar o diálogo com espaço
      (define/override (on-char event)
        (when (equal? (send event get-key-code) #\space)
          (esconder-dialogo)
          (send this refresh)))

      ; Função de pintura do canvas
      (define/override (on-paint)
        (let ([dc (send this get-dc)])
          ; Fundo branco
          (send dc set-brush "lightgray" 'solid)
          (send dc set-pen "black" 1 'solid)
          (send dc draw-rectangle 0 0 1200 700)
          
          ; Borda principal do armário
          (send dc draw-rectangle 360 40 480 480)
          
          ; Desenhar as portas
          (let ([door-width 240]
                [door-height 260]
                [top-margin 70])
            (send dc set-text-foreground "black")
            (send dc set-font (make-object font% 12 'default 'normal 'bold))
            ; Porta esquerda
            (send dc set-brush 
                  (if porta-esquerda-verificada "darkred" "red") 
                  'solid)
            (send dc draw-rectangle 360 top-margin door-width door-height)
            (send dc draw-text (get-objeto-inte obj-armario-verm 0) 450 (+ top-margin 120))
            
            ; Porta direita
            (send dc set-brush 
                  (if porta-direita-verificada "darkred" "red") 
                  'solid)
            (send dc draw-rectangle 600 top-margin door-width door-height)
            (send dc draw-text (get-objeto-inte obj-armario-verm 0) 690 (+ top-margin 120)))
          
          ; Desenhar as gavetas
          (let ([drawer-width 400]
                [drawer-height 70]
                [first-drawer-y 350])
            (send dc set-text-foreground "black")
            (send dc set-font (make-object font% 12 'default 'normal 'bold))
            ; Primeira gaveta
            (send dc set-brush 
                  (if gaveta1-verificada "darkred" "red") 
                  'solid)
            (send dc draw-rectangle 
                  (- (/ 1200 2) (/ drawer-width 2))
                  first-drawer-y
                  drawer-width
                  drawer-height)
            (send dc draw-text (get-objeto-inte obj-armario-verm 1)
                  (- (/ 1200 2) 24)
                  (+ first-drawer-y (/ drawer-height 2)))
            
            ; Segunda gaveta
            (send dc set-brush "red" 'solid)
            (send dc draw-rectangle 
                  (- (/ 1200 2) (/ drawer-width 2))
                  (+ first-drawer-y (+ drawer-height 10))
                  drawer-width
                  drawer-height)
            (send dc draw-text (get-objeto-inte obj-armario-verm 1)
                  (- (/ 1200 2) 24)
                  (+ (+ first-drawer-y (+ drawer-height 10)) 
                     (/ drawer-height 2))))

           ; Desenhar botão voltar
              (send dc set-brush "darkgray" 'solid)
              (send dc set-pen "black" 2 'solid)
              (send dc draw-rectangle 1050 600 100 50)  ; x y width height
              (send dc set-font (make-object font% 16 'default 'normal 'bold))
              (send dc set-text-foreground "white")
              (send dc draw-text "Voltar" 1070 615)
          
          ; Desenhar a caixa de diálogo
          (when mostrar-dialogo
            ; Primeiro desenha um retângulo semi-transparente para escurecer o fundo
            (send dc set-brush (make-object color% 0 0 0 0.5) 'solid)
            (send dc draw-rectangle 0 650 1200 150)
            
            ; Desenha a caixa de diálogo principal (branca)
            (send dc set-brush "white" 'solid)
            (send dc set-pen "black" 2 'solid)
            (send dc draw-rectangle 0 510 1200 200)
            
            ; Área colorida para o nome do falante
            (send dc set-brush "lightsteelblue" 'solid)
            (send dc draw-rectangle 0 470 1200 50)
            
            ; Configurar fonte para o nome do falante
            (send dc set-font (make-object font% 23 'default 'normal 'bold))
            (send dc set-text-foreground "darkblue")
            (send dc draw-text falante-atual 20 475)
            
            ; Configurar fonte para o texto do diálogo
            (send dc set-font (make-object font% 20 'default))
            (send dc set-text-foreground "black")
            
            (let ([linhas (quebrar-texto dc texto-dialogo-atual (- 1150 40))])
              (for/list ([linha linhas]
                        [i (in-range (length linhas))])
                (send dc draw-text linha 20 (+ 525 (* i altura-linha)))))
            
            ; Indicador "Espaço para passar"
            (send dc set-font (make-object font% 14 'default 'normal 'bold))
            (send dc set-text-foreground "gray")
            (send dc draw-text "Pressione espaço para continuar." 875 640))))))
  
  ; Criar e mostrar o canvas
  (define canvas (new armario-canvas%
                      [parent armario-frame]
                      [style '(border)]
                      [min-width 1190]
                      [min-height 680]))
  
  (if (not estado-armario-vermelho)
      ; Descrição do objeto
      (mostrar-mensagem-dialogo (get-nome-dialogo) "Um armário vermelho está próximo à saída, como se escondesse algo vital.")
      (mostrar-mensagem-dialogo (get-nome-dialogo) (get-objeto-desc obj-armario-verm)))

  (send canvas focus)
  (send armario-frame center)
  (send armario-frame show #t)
  
  )



;; ########################################### TELA DO ARMÁRIO AMARELO ############################################

; Variáveis globais
(define porta-esquerda-verificada1 #f)
(define porta-direita-verificada1 #f)
(define gaveta1-verificada1 #f)
(define gaveta2-verificada1 #f)

(define ja-pegou #f)

; Função para mostrar o armário verde
(define (mostrar-armario-amarelo)
  
  (define armario-frame (new dialog%
                            [label "Armário Amarelo"]
                            [width 1200]
                            [height 700]
                            [stretchable-width #f]    
                            [stretchable-height #f]))
  
  ; Canvas personalizado com eventos de mouse
  (define armario-canvas% 
    (class canvas%
      (super-new)
   
      ; Gerenciar eventos de mouse
      (define/override (on-event event)
        (when (send event button-down? 'left)
          (let ([x (send event get-x)]
                [y (send event get-y)])
            (cond
              ; Click na porta esquerda
              [(and (>= x 360) (<= x 600)
                    (>= y 70) (<= y 330))
               (set! porta-esquerda-verificada1 #t)
               (mostrar-mensagem-dialogo (get-nome-robo) "Essa porta não é para qualquer um. Apenas meus aliados mais próximos e meus herdeiros têm a chave para passar.")
               (send this refresh)]
              
              ; Click na porta direita  
              [(and (>= x 600) (<= x 840)
                    (>= y 70) (<= y 330))
               (set! porta-direita-verificada1 #t)

               (cond
                 [(not estado-pedidos)
                   (mostrar-mensagem-dialogo (get-nome-robo) "Você está diante de uma proteção especial. Somente quem provar que entende os pedidos e está 'dentro do círculo' terá permissão para entrar.")]

                 [else
                  (cond
                    [(not ja-pegou)
                     (add-item (get-enigma-efei pedidos))
                     (mostrar-mensagem-dialogo (get-nome-robo) "Você encontrou uma chave... pelas marcas, parece ser do armazém. O que estará protegido lá dentro?")
                     (set! ja-pegou #t)]

                    [else
                     (mostrar-mensagem-dialogo (get-nome-robo) "Já foi vasculhado!")]
                    )]
                 )

               (send this refresh)]
              
              ; Click na primeira gaveta
              [(and (>= x (- (/ 1200 2) 200))
                    (<= x (+ (/ 1200 2) 200))
                    (>= y 350)
                    (<= y 420))
               (set! gaveta1-verificada1 #t)
               
               (cond
                 [(not (esta-inv? (get-enigma-efei pedidos) (get-inventario)))
                  (mostrar-mensagem-dialogo (get-nome-robo) "Esta gaveta está protegida por uma chave especial de minha linhagem. Apenas aqueles que possuem a chave certa podem destrancá-la.")]

                 [else
                  (rem-item (get-enigma-efei armazem))
                  (iniciar-sequencia-dialogos (get-narrador) (Dialogo-finais-armario-a enigma-feito))])
               
               (send this refresh)]

              ; Click na segunda gaveta
              [(and (>= x (- (/ 1200 2) 200))
                    (<= x (+ (/ 1200 2) 200))
                    (>= y 430)
                    (<= y 500))
               (set! gaveta2-verificada1 #t)
               (mostrar-mensagem-dialogo (get-nome-robo) "Há uma proteção aqui, uma barreira invisível. Apenas quem compartilha meu propósito ou herdou minhas características pode ultrapassá-la.")
               (send this refresh)]

              ; Botao de voltar
              ; No on-event, adicione mais uma condição no cond:
              [(and (>= x 1050) (<= x 1150)  ; área x do botão
                    (>= y 600) (<= y 650))   ; área y do botão
               (send armario-frame show #f)
               ]))))
      
      ; Permitir fechar o diálogo com espaço
      (define/override (on-char event)
        (when (equal? (send event get-key-code) #\space)
          (esconder-dialogo)
          (send this refresh)))

      ; Função de pintura do canvas
      (define/override (on-paint)
        (let ([dc (send this get-dc)])
          ; Fundo branco
          (send dc set-brush "lightgray" 'solid)
          (send dc set-pen "black" 1 'solid)
          (send dc draw-rectangle 0 0 1200 700)
          
          ; Borda principal do armário
          (send dc draw-rectangle 360 40 480 480)
          
          ; Desenhar as portas
          (let ([door-width 240]
                [door-height 260]
                [top-margin 70])
            (send dc set-text-foreground "black")
            (send dc set-font (make-object font% 12 'default 'normal 'bold))
            ; Porta esquerda
            (send dc set-brush 
                  (if porta-esquerda-verificada "darkgray" "yellow") 
                  'solid)
            (send dc draw-rectangle 360 top-margin door-width door-height)
            (send dc draw-text (get-objeto-inte obj-armario-amar 0) 450 (+ top-margin 120))
            
            ; Porta direita
            (send dc set-brush 
                  (if porta-direita-verificada "darkgray" "yellow") 
                  'solid)
            (send dc draw-rectangle 600 top-margin door-width door-height)
            (send dc draw-text (get-objeto-inte obj-armario-amar 0) 690 (+ top-margin 120)))
          
          ; Desenhar as gavetas
          (let ([drawer-width 400]
                [drawer-height 70]
                [first-drawer-y 350])
            (send dc set-text-foreground "black")
            (send dc set-font (make-object font% 12 'default 'normal 'bold))
            ; Primeira gaveta
            (send dc set-brush 
                  (if gaveta1-verificada "darkgray" "yellow") 
                  'solid)
            (send dc draw-rectangle 
                  (- (/ 1200 2) (/ drawer-width 2))
                  first-drawer-y
                  drawer-width
                  drawer-height)
            (send dc draw-text (get-objeto-inte obj-armario-amar 1)
                  (- (/ 1200 2) 24)
                  (+ first-drawer-y (/ drawer-height 2)))
            
            ; Segunda gaveta
            (send dc set-brush "yellow" 'solid)
            (send dc draw-rectangle 
                  (- (/ 1200 2) (/ drawer-width 2))
                  (+ first-drawer-y (+ drawer-height 10))
                  drawer-width
                  drawer-height)
            (send dc draw-text (get-objeto-inte obj-armario-amar 1)
                  (- (/ 1200 2) 24)
                  (+ (+ first-drawer-y (+ drawer-height 10)) 
                     (/ drawer-height 2))))

           ; Desenhar botão voltar
              (send dc set-brush "darkgray" 'solid)
              (send dc set-pen "black" 2 'solid)
              (send dc draw-rectangle 1050 600 100 50)  ; x y width height
              (send dc set-font (make-object font% 16 'default 'normal 'bold))
              (send dc set-text-foreground "white")
              (send dc draw-text "Voltar" 1070 615)
          
          ; Desenhar a caixa de diálogo
          (when mostrar-dialogo
            ; Primeiro desenha um retângulo semi-transparente para escurecer o fundo
            (send dc set-brush (make-object color% 0 0 0 0.5) 'solid)
            (send dc draw-rectangle 0 650 1200 150)
            
            ; Desenha a caixa de diálogo principal (branca)
            (send dc set-brush "white" 'solid)
            (send dc set-pen "black" 2 'solid)
            (send dc draw-rectangle 0 510 1200 200)
            
            ; Área colorida para o nome do falante
            (send dc set-brush "lightsteelblue" 'solid)
            (send dc draw-rectangle 0 470 1200 50)
            
            ; Configurar fonte para o nome do falante
            (send dc set-font (make-object font% 23 'default 'normal 'bold))
            (send dc set-text-foreground "darkblue")
            (send dc draw-text falante-atual 20 475)
            
            ; Configurar fonte para o texto do diálogo
            (send dc set-font (make-object font% 20 'default))
            (send dc set-text-foreground "black")
            
            (let ([linhas (quebrar-texto dc texto-dialogo-atual (- 1150 40))])
              (for/list ([linha linhas]
                        [i (in-range (length linhas))])
                (send dc draw-text linha 20 (+ 525 (* i altura-linha)))))
            
            ; Indicador "Espaço para passar"
            (send dc set-font (make-object font% 14 'default 'normal 'bold))
            (send dc set-text-foreground "gray")
            (send dc draw-text "Pressione espaço para continuar." 875 640))))))
  
  ; Criar e mostrar o canvas
  (define canvas (new armario-canvas%
                      [parent armario-frame]
                      [style '(border)]
                      [min-width 1190]
                      [min-height 680]))
  (if (not estado-livro)
      ; Descrição do objeto
      (mostrar-mensagem-dialogo (get-nome-dialogo) "No canto, um armário amarelo se destaca entre o restante da cozinha.")
      (mostrar-mensagem-dialogo (get-nome-dialogo) (get-objeto-desc obj-armario-amar)))
  
  (send canvas focus)
  (send armario-frame center)
  (send armario-frame show #t)
  
  )


;; ########################################### FINALIZAÇÃO ############################################



;; ########################################### TELA DO ARMÁRIO VERDE ############################################

; Variáveis globais
(define porta-esquerda-verificada #f)
(define porta-direita-verificada #f)
(define gaveta1-verificada #f)
(define gaveta2-verificada #f)


; Função para mostrar o armário verde
(define (mostrar-armario-verde)
  
  (define armario-frame (new dialog%
                            [label "Armário Verde"]
                            [width 1200]
                            [height 700]
                            [stretchable-width #f]    
                            [stretchable-height #f]))
  
  ; Canvas personalizado com eventos de mouse
  (define armario-canvas% 
    (class canvas%
      (super-new)
   
      ; Gerenciar eventos de mouse
      (define/override (on-event event)
        (when (send event button-down? 'left)
          (let ([x (send event get-x)]
                [y (send event get-y)])
            (cond
              ; Click na porta esquerda
              [(and (>= x 360) (<= x 600)
                    (>= y 70) (<= y 330))
               (set! porta-esquerda-verificada #t)
               (mostrar-mensagem-dialogo (get-nome-robo) "Ué, uma gaveta pública e... nada aqui dentro? Bem, ser acessível não garante que tenha algo útil, né?")
               (send this refresh)]
              
              ; Click na porta direita  
              [(and (>= x 600) (<= x 840)
                    (>= y 70) (<= y 330))
               (set! porta-direita-verificada #t)
               (mostrar-mensagem-dialogo (get-nome-robo) "Ótimo! Deixaram isso público só pra eu perder tempo abrindo. Quem programou esse lugar tava brincando com a minha paciência!")
               (send this refresh)]
              
              ; Click na primeira gaveta
              [(and (>= x (- (/ 1200 2) 200))
                    (<= x (+ (/ 1200 2) 200))
                    (>= y 350)
                    (<= y 420))
               (set! gaveta1-verificada #t)
               (mostrar-mensagem-dialogo (get-nome-robo) "Público demais, hein? Nada como um método sem barreiras... Mas é melhor tomar cuidado, deixar tudo assim pode causar problemas!")
               (send this refresh)]

              ; Click na segunda gaveta
              [(and (>= x (- (/ 1200 2) 200))
                    (<= x (+ (/ 1200 2) 200))
                    (>= y 430)
                    (<= y 500))
               (set! gaveta2-verificada #t)
               (aberto?)

               (cond
                 [estado-armario-verde
                  (mostrar-sala-receitas)] ; Chama o enigma
                 
                 [else
                  ; Verifica se o jogador tem a chave
                  (mostrar-mensagem-dialogo (get-nome-robo) "Se está fechada, deve ter algo valioso aí dentro... Quem sabe um método público pra destrancar?")]
                 )

               (send this refresh)]

              ; Botao de voltar
              ; No on-event, adicione mais uma condição no cond:
              [(and (>= x 1050) (<= x 1150)  ; área x do botão
                    (>= y 600) (<= y 650))   ; área y do botão
               (send armario-frame show #f)
               ]))))
      
      ; Permitir fechar o diálogo com espaço
      (define/override (on-char event)
        (when (equal? (send event get-key-code) #\space)
          (esconder-dialogo)
          (send this refresh)))

      ; Função de pintura do canvas
      (define/override (on-paint)
        (let ([dc (send this get-dc)])
          ; Fundo branco
          (send dc set-brush "lightgray" 'solid)
          (send dc set-pen "black" 1 'solid)
          (send dc draw-rectangle 0 0 1200 700)
          
          ; Borda principal do armário
          (send dc draw-rectangle 360 40 480 480)
          
          ; Desenhar as portas
          (let ([door-width 240]
                [door-height 260]
                [top-margin 70])
            (send dc set-text-foreground "black")
            (send dc set-font (make-object font% 12 'default 'normal 'bold))
            ; Porta esquerda
            (send dc set-brush 
                  (if porta-esquerda-verificada "darkgreen" "green") 
                  'solid)
            (send dc draw-rectangle 360 top-margin door-width door-height)
            (send dc draw-text (get-objeto-inte obj-armario-verd 0) 450 (+ top-margin 120))
            
            ; Porta direita
            (send dc set-brush 
                  (if porta-direita-verificada "darkgreen" "green") 
                  'solid)
            (send dc draw-rectangle 600 top-margin door-width door-height)
            (send dc draw-text (get-objeto-inte obj-armario-verd 0) 690 (+ top-margin 120)))
          
          ; Desenhar as gavetas
          (let ([drawer-width 400]
                [drawer-height 70]
                [first-drawer-y 350])
            (send dc set-text-foreground "black")
            (send dc set-font (make-object font% 12 'default 'normal 'bold))
            ; Primeira gaveta
            (send dc set-brush 
                  (if gaveta1-verificada "darkgreen" "green") 
                  'solid)
            (send dc draw-rectangle 
                  (- (/ 1200 2) (/ drawer-width 2))
                  first-drawer-y
                  drawer-width
                  drawer-height)
            (send dc draw-text (get-objeto-inte obj-armario-verd 1)
                  (- (/ 1200 2) 24)
                  (+ first-drawer-y (/ drawer-height 2)))
            
            ; Segunda gaveta
            (send dc set-brush "green" 'solid)
            (send dc draw-rectangle 
                  (- (/ 1200 2) (/ drawer-width 2))
                  (+ first-drawer-y (+ drawer-height 10))
                  drawer-width
                  drawer-height)
            (send dc draw-text (get-objeto-inte obj-armario-verd 1)
                  (- (/ 1200 2) 24)
                  (+ (+ first-drawer-y (+ drawer-height 10)) 
                     (/ drawer-height 2))))

           ; Desenhar botão voltar
              (send dc set-brush "darkgray" 'solid)
              (send dc set-pen "black" 2 'solid)
              (send dc draw-rectangle 1050 600 100 50)  ; x y width height
              (send dc set-font (make-object font% 16 'default 'normal 'bold))
              (send dc set-text-foreground "white")
              (send dc draw-text "Voltar" 1070 615)
          
          ; Desenhar a caixa de diálogo
          (when mostrar-dialogo
            ; Primeiro desenha um retângulo semi-transparente para escurecer o fundo
            (send dc set-brush (make-object color% 0 0 0 0.5) 'solid)
            (send dc draw-rectangle 0 650 1200 150)
            
            ; Desenha a caixa de diálogo principal (branca)
            (send dc set-brush "white" 'solid)
            (send dc set-pen "black" 2 'solid)
            (send dc draw-rectangle 0 510 1200 200)
            
            ; Área colorida para o nome do falante
            (send dc set-brush "lightsteelblue" 'solid)
            (send dc draw-rectangle 0 470 1200 50)
            
            ; Configurar fonte para o nome do falante
            (send dc set-font (make-object font% 23 'default 'normal 'bold))
            (send dc set-text-foreground "darkblue")
            (send dc draw-text falante-atual 20 475)
            
            ; Configurar fonte para o texto do diálogo
            (send dc set-font (make-object font% 20 'default))
            (send dc set-text-foreground "black")
            
            (let ([linhas (quebrar-texto dc texto-dialogo-atual (- 1150 40))])
              (for/list ([linha linhas]
                        [i (in-range (length linhas))])
                (send dc draw-text linha 20 (+ 525 (* i altura-linha)))))
            
            ; Indicador "Espaço para passar"
            (send dc set-font (make-object font% 14 'default 'normal 'bold))
            (send dc set-text-foreground "gray")
            (send dc draw-text "Pressione espaço para continuar." 875 640))))))
  
  ; Criar e mostrar o canvas
  (define canvas (new armario-canvas%
                      [parent armario-frame]
                      [style '(border)]
                      [min-width 1190]
                      [min-height 680]))
  (if (not estado-livro)
      ; Descrição do objeto
      (mostrar-mensagem-dialogo (get-nome-dialogo) "Um armário verde com linhas modernas e um brilho sutil. Parece esconder algo avançado.")
      (mostrar-mensagem-dialogo (get-nome-dialogo) (get-objeto-desc obj-armario-verd)))

  (send canvas focus)
  (send armario-frame center)
  (send armario-frame show #t)
  
  )


;; ########################################### FINALIZAÇÃO ############################################



;; ########################################### TELA DO LIVRO ############################################

(define receitas-frame-atual #f)

; Função para mostrar a sala das receitas
(define (mostrar-sala-receitas)
  (define receitas-frame (new dialog%
                             [label "ENIGMA - LIVRO DE RECEITAS"]
                             [width 1200]
                             [height 700]
                             [stretchable-width #f]    
                             [stretchable-height #f]))
  
  (set! receitas-frame-atual receitas-frame)
  
  ; Canvas personalizado com eventos de mouse
  (define receitas-canvas%
    (class canvas%
      (super-new)
      (define/override (on-event event)
        (when (send event button-down? 'left)
          (let ([x (send event get-x)]
                [y (send event get-y)])
            ; Verificar clique no botão voltar
            (when (and (>= x 1080) (<= x 1180)  ; área x do botão
                      (>= y 630) (<= y 680))     ; área y do botão
              (send receitas-frame show #f)
              )
            
            ; Verificar clique nas páginas usando filter e andmap
            (let* ([idx-receita (filter
                                (lambda (idx)
                                  (let* ([rx (+ 160 (* 120 (modulo idx 3)))]
                                         [ry (+ 100 (* 105 (quotient idx 3)))])
                                    (and (>= x (- rx 48)) (<= x (+ rx 48))
                                         (>= y (- ry 9)) (<= y (+ ry 61)))))
                                (range (length receitas-disponiveis)))])
              (when (not (null? idx-receita))
                (let ([receita (list-ref receitas-disponiveis (car idx-receita))])
                  (unless (member receita receitas-encontradas)
                    (add-receita receita)
                    (mostrar-mensagem-dialogo "✨ Descoberta ✨" (format "Você encontrou a receita: ~a - ~a" 
                                                                          (Receita-nome receita)
                                                                          (Receita-descricao receita)))

                    (send this refresh)))))
            
            ; Verificar clique no livro
            (when (and (>= x 720) (<= x 1040)
                      (>= y 105) (<= y 502))
              (mostrar-livro-receitas))

            ; Verificar clique no botao verificar
            (when (and (= (length receitas-encontradas) (length receitas-disponiveis)) (not estado-livro))
              ; Muda a cor do botao para verde.
              (alter-botao-ver)

              (when (and (>= x 350) (<= x 550)
                         (>= y 580) (<= y 650))
                (concluido-livro?) 
                (send this refresh)))

            ; Verificar clique no botao resetar
            (when (and (>= x 600) (<= x 800)
                       (>= y 580) (<= y 650)
                       (not estado-livro))
              (define resultado (resetar-acao))

              (when (equal? resultado 'yes)
                ; Lógica de reset aqui
                (reset-recipe-book)
                (send receitas-frame-atual show #f)
                (mostrar-sala-receitas)
              )))))
      
      (define/override (on-char event)
        (when (equal? (send event get-key-code) #\space)
          (esconder-dialogo)
          (send this refresh)))
      
      (define/override (on-paint)
        (let ([dc (send this get-dc)])
          (send dc set-text-foreground "black")
          (send dc set-font (make-object font% 12 'default 'normal 'bold))
          ; Fundo
          (send dc set-brush "beige" 'solid)
          (send dc set-pen "black" 1 'solid)
          (send dc draw-rectangle 0 0 1200 700)
          
          ; Páginas espalhadas usando map
          (map (lambda (receita idx)
                (unless (member receita receitas-encontradas)
                  (let ([x (+ 160 (* 120 (modulo idx 3)))]
                        [y (+ 100 (* 105 (quotient idx 3)))])
                    (send dc set-brush "white" 'solid)
                    (send dc draw-rectangle (- x 48) (- y 9) 96 70)
                    (send dc draw-text 
                          (Receita-nome receita)
                          (- x 44)
                          (- y 4)))))
              receitas-disponiveis
              (range (length receitas-disponiveis)))
          
          ; Livro de receitas
          (send dc set-brush "brown" 'solid)
          (send dc draw-rectangle 720 80 320 437)
          (send dc set-font (make-font #:size 16))
          (send dc draw-text "Livro de Receitas" 816 232)

          ; Botões Verificar e Resetar
          (send dc set-brush "green" 'solid)
          (send dc draw-rectangle 600 580 200 70)  ; Resetar (largura aumentada de 100 para 200, y subiu para 580)
          (send dc set-brush 
                (if verificar-ativo "green" "gray") 
                'solid)
          (send dc draw-rectangle 350 580 200 70)  ; Verificar (largura aumentada de 100 para 200, y subiu para 580)
          (send dc set-font (make-object font% 20 'default 'normal 'bold))
          (send dc draw-text "Verificar" 390 595)
          (send dc draw-text "Resetar" 650 595)
          
          ; Botão voltar
          (send dc set-brush "darkgray" 'solid)
          (send dc set-pen "black" 2 'solid)
          (send dc draw-rectangle 1080 630 100 50)
          (send dc set-font (make-object font% 16 'default 'normal 'bold))
          (send dc set-text-foreground "white")
          (send dc draw-text "Voltar" 1100 645)
          
          ; Desenhar a caixa de diálogo
          (when mostrar-dialogo
            ; Primeiro desenha um retângulo semi-transparente para escurecer o fundo
            (send dc set-brush (make-object color% 0 0 0 0.5) 'solid)
            (send dc draw-rectangle 0 650 1200 150)
            
            ; Desenha a caixa de diálogo principal (branca)
            (send dc set-brush "white" 'solid)
            (send dc set-pen "black" 2 'solid)
            (send dc draw-rectangle 0 540 1200 200)
            
            ; Área colorida para o nome do falante
            (send dc set-brush "lightsteelblue" 'solid)
            (send dc draw-rectangle 0 500 1200 50)
            
            ; Configurar fonte para o nome do falante
            (send dc set-font (make-object font% 23 'default 'normal 'bold))
            (send dc set-text-foreground "darkblue")
            (send dc draw-text falante-atual 20 505)
            
            ; Configurar fonte para o texto do diálogo
            (send dc set-font (make-object font% 20 'default))
            (send dc set-text-foreground "black")
            
            ; Quebrar e desenhar o texto em múltiplas linhas
            (let ([linhas (quebrar-texto dc texto-dialogo-atual (- 1150 40))])
              (for/list ([linha linhas]
                        [i (in-range (length linhas))])
                (send dc draw-text linha 20 (+ 555 (* i altura-linha)))))
            
            ; Indicador "Espaço para passar"
            (send dc set-font (make-object font% 14 'default 'normal 'bold))
            (send dc set-text-foreground "gray")
            (send dc draw-text "Pressione espaço para continuar." 880 670))))))
  
  ; Instanciar o canvas
  (define receitas-canvas (new receitas-canvas%
                              [parent receitas-frame]
                              [style '(border)]
                              [min-width 1200]
                              [min-height 700]))

  (when (not estado-livro)
    (iniciar-sequencia-dialogos (get-nome-robo) (Dialogo-livro dialogo)))

  (send receitas-canvas focus)
  
  ; Mostrar a janela centralizada
  (send receitas-frame center)
  (send receitas-frame show #t)
  )

;; ########################################### FINALIZAÇÃO ############################################




;; ########################################### TELA DAS RECEITAS SENDO ORGANIZADAS ############################################

; Função para mostrar o livro de receitas
(define (mostrar-livro-receitas)
  (define dialogo1 (new dialog%
                      [label "Livro de Receitas"]
                      [width 900]
                      [height 700]
                      [stretchable-width #f]    
                      [stretchable-height #f]))
  
  ; Painel principal
  (define painel (new vertical-panel% 
                     [parent dialogo1]
                     [alignment '(center top)]
                     [spacing 8]
                     [min-width 890]
                     [min-height 600]))
  
  ; Painel para o título (novo)
  (define titulo-painel (new horizontal-panel%
                            [parent painel]
                            [alignment '(center center)]
                            [stretchable-height #f]))
  
  ; Título centralizado
  (new message%
       [parent titulo-painel]
       [label "Receitas Encontradas"]
       [font (make-font #:size 24 #:weight 'bold)])
  
  ; Canvas com scrolling para as receitas
  (define canvas (new editor-canvas%
                     [parent painel]
                     [style '(no-hscroll auto-vscroll)]
                     [min-width 700]
                     [min-height 450]))
  
  ; Text editor para conter as receitas
  (define text (new text%))
  (send canvas set-editor text)
  
   ; Função auxiliar para formatar uma única receita
  (define (formatar-receita receita é-última?)
    (define (aplicar-estilo inicio fim tamanho peso)
      (let ([style (make-object style-delta%)])
        (send style set-size-mult 0)
        (send style set-size-add tamanho)
        (when peso
          (send style set-weight-on peso))
        (send text change-style style inicio fim)))
    
    ; Inserir e formatar nome
    (send text insert "     ")
    (let ([inicio-nome (send text last-position)])
      (send text insert (format "~a" (Receita-nome receita)))
      (aplicar-estilo inicio-nome (send text last-position) 16 'bold))
    
    ; Inserir e formatar descrição
    (send text insert "\n     ")
    (let ([inicio-desc (send text last-position)])
      (send text insert (format "~a" (Receita-descricao receita)))
      (aplicar-estilo inicio-desc (send text last-position) 14 'normal))
    
    ; Adicionar separador se não for a última receita
    (send text insert "\n")
    (unless é-última?
      (send text insert "     ")
      (let ([inicio-linha (send text last-position)])
        (send text insert "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n")
        (aplicar-estilo inicio-linha (send text last-position) 14 #f))))
  
 ; Inserir conteúdo no texto
  (if (null? receitas-encontradas)
      (begin
        (send text insert "Nenhuma receita encontrada ainda.")
        (let ([style (make-object style-delta%)])
          (send style set-size-mult 0)
          (send style set-size-add 16)
          (send text change-style style 0 (send text last-position))))
      (begin
        ; Criar lista de pares (receita, é-última?)
        (let* ([total (length receitas-encontradas)]
               [receitas-com-flag 
                (map (lambda (idx receita)
                      (cons receita (= idx (sub1 total))))
                     (range total)
                     receitas-encontradas)])
          ; Usar foldr para processar as receitas
          (foldl (lambda (par acc)
                  (formatar-receita (car par) (cdr par)))
                 void
                 receitas-com-flag))))

  
  ; Tornar o texto não editável
  (send text lock #t)
  
  ; Painel para botões
  (define botoes-painel (new horizontal-panel% 
                            [parent painel]
                            [alignment '(center bottom)]
                            [stretchable-height #f]
                            [spacing 30]
                            [min-height 40]))

 
  ; Botão fechar
  (new button%
       [parent botoes-painel]
       [label "Fechar"]
       [min-width 180]
       [min-height 40]
       [font (make-font #:size 14 #:weight 'bold)]  
       [callback (lambda (button event)
                  (send dialogo1 show #f))])
  
  ; Centralizar e mostrar o diálogo
  (send dialogo1 center)
  (send dialogo1 show #t))

;; ########################################### FINALIZAÇÃO ############################################



;; ########################################### TELA DA BANCADA ############################################
(define (mostrar-tela-bancada)
  (define bancada-frame (new dialog%
                            [label "Bancada"]
                            [width 1200]
                            [height 700]
                            [stretchable-width #f]    
                            [stretchable-height #f]))
  
  ; Canvas personalizado com eventos de mouse
  (define bancada-canvas% 
    (class canvas%
      (super-new)
      (define/override (on-event event)
        (when (send event button-down? 'left)
          (let ([x (send event get-x)]
                [y (send event get-y)])
            ; Verificar se o clique foi no tablet (área ajustada)
            (when (and (>= x 500) (<= x 750)
                      (>= y 300) (<= y 480))
              (mostrar-tela-tablet)
              )
              
            ; Verificar se o clique foi no botão "Voltar"
            (when (and (>= x 1050) (<= x (+ 1050 130))
                       (>= y 650) (<= y (+ 650 40)))
              (send bancada-frame show #f)))))


      (define/override (on-char event)
        (when (equal? (send event get-key-code) #\space)
          (esconder-dialogo)
          (send this refresh)))))
  
  
  ; Instanciar o canvas personalizado
  (define bancada-canvas (new bancada-canvas%
                             [parent bancada-frame]
                             [paint-callback
                              (lambda (canvas dc)
                                ; Fundo cinza da bancada
                                (send dc set-brush "gray" 'solid)
                                (send dc draw-rectangle 0 0 1200 700)
                                
                                ; Tablet (retângulo preto maior)
                                (send dc set-brush "black" 'solid)
                                (send dc draw-rectangle 500 300 250 180)
                                
                                ; Pratos (aumentados proporcionalmente)
                                (send dc set-brush "white" 'solid)
                                (send dc draw-ellipse 120 180 100 100)  ; Prato 1
                                (send dc draw-ellipse 240 180 100 100)  ; Prato 2
                                (send dc draw-ellipse 120 360 100 100)  ; Prato 3
                                
                                ; Copos (aumentados proporcionalmente)
                                (send dc set-brush "lightblue" 'solid)
                                (send dc draw-rectangle 900 180 50 70)  ; Copo 1
                                (send dc draw-rectangle 960 180 50 70)  ; Copo 2
                                (send dc draw-rectangle 900 300 50 70)  ; Copo 3
                                
                                ; Texto indicativo para o tablet (fonte maior)
                                (send dc set-font (make-object font% 18 'default))
                                (send dc set-text-foreground "white")
                                (send dc draw-text "Tablet" 595 380)

                                ; Desenhar fundo do botão
                                (send dc set-brush "green" 'solid)
                                (send dc set-pen "black" 2 'solid)
                                (send dc draw-rectangle 1050 650 130 40)
          
                                ; Desenhar texto do botão
                                (send dc set-font (make-object font% 16 'default 'normal 'bold))
                                (send dc set-text-foreground "black")
                                (send dc draw-text "Voltar" (+ 1050 30) (+ 650 10))

                                
                                ; Desenhar a caixa de diálogo
                                (when mostrar-dialogo
                                  ; Primeiro desenha um retângulo semi-transparente para escurecer o fundo
                                  (send dc set-brush (make-object color% 0 0 0 0.5) 'solid)
                                  (send dc draw-rectangle 0 650 1200 150)
            
                                  ; Desenha a caixa de diálogo principal (branca)
                                  (send dc set-brush "white" 'solid)
                                  (send dc set-pen "black" 2 'solid)
                                  (send dc draw-rectangle 0 540 1200 200)
            
                                  ; Área colorida para o nome do falante
                                  (send dc set-brush "lightsteelblue" 'solid)
                                  (send dc draw-rectangle 0 500 1200 50)
            
                                  ; Configurar fonte para o nome do falante
                                  (send dc set-font (make-object font% 23 'default 'normal 'bold))
                                  (send dc set-text-foreground "darkblue")
                                  (send dc draw-text falante-atual 20 505)
            
                                  ; Configurar fonte para o texto do diálogo
                                  (send dc set-font (make-object font% 20 'default))
                                  (send dc set-text-foreground "black")
            
                                  ; Quebrar e desenhar o texto em múltiplas linhas
                                  (let ([linhas (quebrar-texto dc texto-dialogo-atual (- 1150 40))])
                                    (for/list ([linha linhas]
                                               [i (in-range (length linhas))])
                                      (send dc draw-text linha 20 (+ 555 (* i altura-linha)))))
            
                                  ; Indicador "Espaço para passar"
                                  (send dc set-font (make-object font% 14 'default 'normal 'bold))
                                  (send dc set-text-foreground "gray")
                                  (send dc draw-text "Pressione espaço para continuar." 880 670)))]
                             
                             [style '(border)]
                             [min-width 1200]
                             [min-height 700]))


  (if (not estado-bancada-central)
      (mostrar-mensagem-dialogo (get-nome-dialogo) "Entre essas coisas espalhadas pela bancada, será que algo importa?")
      (mostrar-mensagem-dialogo (get-nome-dialogo) (get-objeto-desc obj-bancada-cen))
      )

  (send bancada-canvas focus)
                           
  ; Mostrar a janela centralizada
  (send bancada-frame center)
  (send bancada-frame show #t))


;; ########################################### FINALIZAÇÃO ############################################



;; ########################################### TELA DO TABLET ############################################
(define tablet-canvas% 
  (class canvas%
    (super-new)
    (define/override (on-event event)
      (when (send event button-down? 'left)
        (let ([x (send event get-x)]
              [y (send event get-y)])
          ; Verificar se o clique foi no Quiz
          (when (and (>= x 400) (<= x 600)
                    (>= y 350) (<= y 425))
            (mostrar-dialogo-senha 'quiz))
          ; Verificar se o clique foi nos Pedidos
          (when (and (>= x 650) (<= x 850)
                    (>= y 350) (<= y 425))
            (mostrar-dialogo-senha 'pedidos)))))))

(define (mostrar-tela-tablet)
  (define tablet-frame (new dialog%
                           [label "Tablet"]
                           [width 1200]
                           [height 700]
                           [stretchable-width #f]    
                           [stretchable-height #f]))
  
  ; Canvas para o tablet
  (define tablet-canvas (new tablet-canvas% 
    [parent tablet-frame]
    [paint-callback
     (lambda (canvas dc)
       ; Fundo preto do tablet
       (send dc set-brush "black" 'solid)
       (send dc draw-rectangle 0 0 1200 700)
       
       ; Retângulo cinza central
       (send dc set-brush "gray" 'solid)
       (send dc draw-rectangle 30 30 1140 620)
       
       ; Texto "Bem Vindo!"
       (send dc set-font (make-object font% 40 'default))
       (send dc set-text-foreground "black")
       (send dc draw-text "Bem Vindo!" 500 200)
       
       ; Botões
       (send dc set-brush "white" 'solid)
       ; Botão Quiz
       (send dc draw-rectangle 400 350 200 75)
       (send dc set-font (make-object font% 30 'default))
       (send dc set-text-foreground "black")
       (send dc draw-text "Quiz" 460 370)
       
       ; Botão Pedidos
       (send dc draw-rectangle 650 350 200 75)
       (send dc draw-text "Pedidos" 685 370))]
    
    ; Adicionar evento de mouse para os botões
    [style '(border)]
    [min-width 1200]
    [min-height 700]))
  
  ; Botão de voltar
  (new button%
       [parent tablet-frame]
       [label "Voltar"]
       [min-width 120] 
       [min-height 40]  
       [font (make-object font% 12 'default)] 
       [callback (lambda (button event)
                  (send tablet-frame show #f))])
  
  ; Mostrar a janela centralizada
  (send tablet-frame center)
  (send tablet-frame show #t))

;Senhas
(define SENHA-QUIZ "1315")
(define SENHA-PEDIDOS "18195")


;; ########################################### FINALIZAÇÃO ############################################



;; ########################################### TELA DE ACESSO ############################################
(define (mostrar-dialogo-senha tipo-acesso)
  (define senha-frame (new dialog%
                           [label "Autenticação"]
                           [width 300]
                           [height 100]))
  
  (define senha-campo (new text-field%
                           [parent senha-frame]
                           [label "Digite a senha:"]
                           [init-value ""]
                           [style '(single)]))
  
  (new button%
       [parent senha-frame]
       [label "Confirmar"]
       [callback (lambda (button event)
                   (let ([senha-digitada (send senha-campo get-value)])
                     (cond
                       [(and (equal? tipo-acesso 'quiz) 
                             (equal? senha-digitada (get-enigma-efei livro)))
                        (send senha-frame show #f)
                        (mostrar-dinamica-quiz)]
                       [(and (equal? tipo-acesso 'pedidos)
                             (equal? senha-digitada (get-enigma-efei quiz)))
                        (send senha-frame show #f)
                        (mostrar-dinamica-pedidos)]
                       [else
                        (message-box "Erro" "Senha incorreta!" 
                                     #f '(ok stop))])))])
  
  (send senha-frame center)
  (send senha-frame show #t)
  (send senha-campo focus))


;; ########################################### FINALIZAÇÃO ############################################




; ############################################### TELA DA DINÂMICA DO QUIZ ###############################################

;; Organiza a escrita das perguntas do quiz
(define (draw-multiline-text dc lines start-x start-y line-height)
  (match lines
    ['() (void)]
    [(cons question-line option-lines)
     (send dc set-font (make-font #:size 20 #:weight 'bold))
     (send dc draw-text question-line start-x start-y)
     (draw-options dc option-lines start-x (+ start-y line-height) line-height)]))

(define (draw-options dc lines start-x start-y line-height)
  (match lines
    ['() (void)]
    [(cons option-line rest)
     (send dc set-font (make-font #:size 18))
     (send dc draw-text option-line start-x start-y)
     (draw-options dc rest start-x (+ start-y line-height) line-height)]))


(define current-question "")
(define current-answer-options '())
(define selected-answer #f)

(define (mostrar-dinamica-quiz)
  (define quiz-frame (new dialog% 
                     [label "ENIGMA - Quiz de POO"]
                     [width 1200]
                     [height 700]
                     [stretchable-width #f]    
                     [stretchable-height #f]))

  
 (define bancada-canvas% 
    (class canvas%
      (super-new)
      (define/override (on-event event)
        (when (send event button-down? 'left)
          (let ([x (send event get-x)]
                [y (send event get-y)])

            (when (and (string-contains? current-question "Pergunta 6:") (not estado-quiz))
              (cond
                ; Opção a
                [(and (>= x 100) (<= x 800) (>= y 260) (<= y 310))
                 (mostrar-mensagem-dialogo (get-nome-robo) "Resposta A: b, c, a, d, c - Resposta Incorreta! Tente novamente.")]
                
                ; Opção b
                [(and (>= x 100) (<= x 800) (>= y 310) (<= y 360))
                 (concluido-quiz?)]
                
                ; Opção c
                [(and (>= x 100) (<= x 800) (>= y 360) (<= y 410))
                 (mostrar-mensagem-dialogo (get-nome-robo) "Resposta C: b, b, c, a, b - Resposta Incorreta! Tente novamente.")]
                
                ; Opção d
                [(and (>= x 100) (<= x 800) (>= y 410) (<= y 460))
                 (mostrar-mensagem-dialogo (get-nome-robo) "Resposta D: a, b, d, c, b - Resposta Incorreta! Tente novamente.")]
                
                ; Opção e
                [(and (>= x 100) (<= x 800) (>= y 460) (<= y 510))
                 (mostrar-mensagem-dialogo (get-nome-robo) "Resposta E: c, d, a, b, a - Resposta Incorreta! Tente novamente.")])
              (send canvas refresh))
      
            ; Verificar cliques nos botões de quiz
            (cond
              [(and (>= x 1050) (<= x 1170) (>= y 20) (<= y 60))
               (message-box "Ajuda" 
                            "Leia atentamente todas as perguntas dos quizzes (Quiz 1, Quiz 2, Quiz 3, etc.) antes de responder.

Após analisar as perguntas e as possíveis respostas, clique no botão 'Resposta'. Nesse botão, você encontrará as alternativas combinadas (ex.: a, b, c, d, e) e poderá selecionar a que corresponde à sequência correta!")]
              
              ; Botões de Quiz
              [(and (>= x 1050) (<= x 1170) (>= y 120) (<= y 170))
               (set! current-question 
                     "Pergunta 1: \nA classe Chef tem como método, prepararPrato(). \nSe diferentes chefs (subclasses) como ChefConfeiteiro e ChefGourmet implementam \no mesmo método com suas especialidades, qual conceito de POO está sendo usado?\n\na) Herança \nb) Polimorfismo \nc) Encapsulamento \nd) Composição")
               (send canvas refresh)]
              
              [(and (>= x 1050) (<= x 1170) (>= y 180) (<= y 230))
               (set! current-question 
                     "Pergunta 2: \nVocê deseja garantir que o nome de um ingrediente seja acessado apenas através de \nmétodos específicos e que não possa ser alterado diretamente, qual princípio da POO \nvocê está aplicando?\n\na) Herança \nb) Encapsulamento \nc) Polimorfismo \nd) Abstração")
               (send canvas refresh)]
              
              [(and (>= x 1050) (<= x 1170) (>= y 240) (<= y 290))
               (set! current-question 
                     "Pergunta 3: \nNo contexto da Programação Orientada a Objetos (POO), qual é o conceito de \n'herança' aplicado no contexto em que você está?\n\na) Usar um utensílio que foi passado de geração em geração na família. \nb) A capacidade de uma receita ter ingredientes de outra receita. \nc) A capacidade de uma receita herdar ingredientes e técnicas de preparação de \n    outra receita. \nd) Um chef utiliza uma ferramenta de cozinha para passar o conhecimento para \n    outra pessoa.")
               (send canvas refresh)]
              
              [(and (>= x 1050) (<= x 1170) (>= y 300) (<= y 350))
               (set! current-question 
                     "Pergunta 4: \nDurante a preparação de um prato, qual desses casos representa o conceito de \n'Abstração', em POO?\n\na) Mostrar apenas os ingredientes essenciais de um prato, sem mostrar o passo a \n    passo do preparo. \nb) Explicar a receita de forma detalhada, sem ocultar nenhuma informação. \nc) Mostrar o prato finalizado sem revelar como ele foi preparado. \nd) Modificar os ingredientes para esconder os sabores.")
               (send canvas refresh)]
              
              [(and (>= x 1050) (<= x 1170) (>= y 360) (<= y 410))
               (set! current-question 
                     "Pergunta 5: \nPor que o polimorfismo é importante em um sistema baseado em POO?\n\na) Ele reduz a quantidade de código duplicado e aumenta a flexibilidade. \nb) Ele permite que apenas uma instância de uma classe exista no sistema. \nc) Ele protege os atributos das classes contra modificações diretas. \nd) Ele organiza os dados de forma hierárquica.")
               (send canvas refresh)]

              ; Botão de Resposta
              [(and (>= x 1050) (<= x 1170) (>= y 420) (<= y 570))
               (set! current-question 
                     "Pergunta 6: CLIQUE NA ALTERNATIVA! \nQual sequência de respostas das perguntas anteriores corresponde corretamente \naos conceitos de POO?")
               (send canvas refresh)]
              
              ; Botão de Voltar
              [(and (>= x 1050) (<= x 1170) (>= y 610) (<= y 660))
               (send quiz-frame show #f)]))))

      (define/override (on-char event)
        (when (equal? (send event get-key-code) #\space)
          (esconder-dialogo)
          (send this refresh)))))
  
  
  (define canvas (new bancada-canvas% 
                      [parent quiz-frame]
                      [style '(border)]
                      [min-width 1200]
                      [min-height 700]
                      [paint-callback
                       (lambda (canvas dc)
                         ; Fundo cinza
                         (send dc set-text-foreground "black")
                         (send dc set-brush (make-color 128 128 128) 'solid)
                         (send dc draw-rectangle 0 0 1200 700)
                         
                         ; Título centralizado
                         (send dc set-font (make-font #:size 36 #:weight 'bold))
                         (let ([title "Quiz de POO"])
                           (define-values (w h d a) (send dc get-text-extent title))
                           (send dc draw-text title 
                                 (/ (- 1200 w) 2) 
                                 10))
                         
                         ; Botão de Ajuda
                         (send dc set-brush "white" 'solid)
                         (send dc set-pen "black" 2 'solid)
                         (send dc draw-rectangle 1050 20 120 40)
                         (send dc set-font (make-font #:size 16 #:weight 'bold))
                         (send dc draw-text "Ajuda" 1075 25)
                         
                        ; Adicionando 5 retângulos para quizzes
                         (send dc set-brush "light blue" 'solid)
                         (send dc set-pen "black" 2 'solid)
                         (send dc draw-rectangle 1050 120 120 50)
                         (send dc set-font (make-font #:size 16 #:weight 'bold))
                         (send dc draw-text "Quiz 1" 1080 130)
                         
                         (send dc set-brush "light green" 'solid)
                         (send dc draw-rectangle 1050 180 120 50)
                         (send dc draw-text "Quiz 2" 1080 190)
                         
                         (send dc set-brush "light yellow" 'solid)
                         (send dc draw-rectangle 1050 240 120 50)
                         (send dc draw-text "Quiz 3" 1080 250)
                         
                         (send dc set-brush "light pink" 'solid)
                         (send dc draw-rectangle 1050 300 120 50)
                         (send dc draw-text "Quiz 4" 1080 310)
                         
                         (send dc set-brush "light coral" 'solid)
                         (send dc draw-rectangle 1050 360 120 50)
                         (send dc draw-text "Quiz 5" 1080 370)

                         ; Área para mostrar pergunta
                         (send dc set-brush "white" 'solid)
                         (send dc draw-rectangle 70 120 950 420)
                         
                         (when (not (string=? current-question ""))
                           (let* ([margin 30]
                                  [start-x (+ 60 margin)]
                                  [start-y (+ 110 margin)]
                                  [max-width 900]
                                  [line-height 35]
                                  [lines (string-split current-question "\n")])
                             (draw-multiline-text dc lines start-x start-y line-height)))
                         
                         ; Se a Pergunta 6 estiver exibida, desenhar retângulos de opções de resposta
                         (when (string-contains? current-question "Pergunta 6:")
                           (send dc set-brush "white" 'solid)
                           (send dc set-pen "black" 2 'solid)
            
                           ; Opção a
                           (send dc draw-rectangle 100 260 700 50)
                           (send dc draw-text "a) b, c, a, d, c" 110 270)
            
                           ; Opção b
                           (send dc draw-rectangle 100 310 700 50)
                           (send dc draw-text "b) b, b, c, a, a" 110 320)
            
                           ; Opção c
                           (send dc draw-rectangle 100 360 700 50)
                           (send dc draw-text "c) b, b, c, a, b" 110 370)
            
                           ; Opção d
                           (send dc draw-rectangle 100 410 700 50)
                           (send dc draw-text "d) a, b, d, c, b" 110 420)
            
                           ; Opção e
                           (send dc draw-rectangle 100 460 700 50)
                           (send dc draw-text "e) c, d, a, b, a" 110 470))

                         
                         ; Botão de Resposta
                         (send dc set-brush "light salmon" 'solid)
                         (send dc set-pen "black" 2 'solid)
                         (send dc draw-rectangle 1050 420 120 50)
                         (send dc set-font (make-font #:size 16 #:weight 'bold))
                         (send dc draw-text "Resposta" 1065 430)

                         ; Botão de Voltar
                         (send dc set-brush "light gray" 'solid)
                         (send dc set-pen "black" 2 'solid)
                         (send dc draw-rectangle 1050 610 120 50)
                         (send dc set-font (make-font #:size 16 #:weight 'bold))
                         (send dc draw-text "Voltar" 1080 620)


                         ; Desenhar a caixa de diálogo
                         (when mostrar-dialogo
                           ; Primeiro desenha um retângulo semi-transparente para escurecer o fundo
                           (send dc set-brush (make-object color% 0 0 0 0.5) 'solid)
                           (send dc draw-rectangle 0 650 1200 150)
            
                           ; Desenha a caixa de diálogo principal (branca)
                           (send dc set-brush "white" 'solid)
                           (send dc set-pen "black" 2 'solid)
                           (send dc draw-rectangle 0 540 1200 200)
            
                           ; Área colorida para o nome do falante
                           (send dc set-brush "lightsteelblue" 'solid)
                           (send dc draw-rectangle 0 500 1200 50)
            
                           ; Configurar fonte para o nome do falante
                           (send dc set-font (make-object font% 23 'default 'normal 'bold))
                           (send dc set-text-foreground "darkblue")
                           (send dc draw-text falante-atual 20 505)
            
                           ; Configurar fonte para o texto do diálogo
                           (send dc set-font (make-object font% 20 'default))
                           (send dc set-text-foreground "black")
            
                           ; Quebrar e desenhar o texto em múltiplas linhas
                           (let ([linhas (quebrar-texto dc texto-dialogo-atual (- 1150 40))])
                             (for/list ([linha linhas]
                                        [i (in-range (length linhas))])
                               (send dc draw-text linha 20 (+ 555 (* i altura-linha)))))
            
                           ; Indicador "Espaço para passar"
                           (send dc set-font (make-object font% 14 'default 'normal 'bold))
                           (send dc set-text-foreground "gray")
                           (send dc draw-text "Pressione espaço para continuar." 880 670)))]))
  
 (when (not estado-quiz)
    (iniciar-sequencia-dialogos (get-nome-robo) (Dialogo-quiz dialogo)))

  (send canvas focus)
  
  (send quiz-frame center)
  (send quiz-frame show #t)
)

;; ########################################### FINALIZAÇÃO ############################################



;; ########################################### TELA DO PEDIDO ############################################

;; Listas para armazenar pedidos
(define pedidos-normais (list "pn1 - 12:15" "pn2 - 12:20" "pn3 - 12:22" "pn4 - 12:23"))
(define pedidos-prioritarios (list "pp1 - 12:00" "pp2 - 12:18" "pp3 - 12:21" "pp4 - 12:25"))
(define pedidos-organizados '())


;############### TELA DA DINÂMICA DOS PEDIDOS ###############
(define (mostrar-dinamica-pedidos)

  (define pedido (new dialog% 
                      [label "Sistema de Pedidos"]
                      [width 1200]
                      [height 700]
                      [stretchable-width #f]    
                      [stretchable-height #f]))

  (define canvas 
    (new (class canvas%
           [init-rest init-args]
           [define min-width 1200]
           [define min-height 700]
           
           ;; Função atualizada para desemfileirar corretamente
           (define (atualizar-pedidos lista-origem lista-destino)
             (when (not (null? lista-origem))
               (let ([pedido-atual (car lista-origem)])
                 ;; Adiciona o pedido atual à lista de pedidos organizados
                 (set! pedidos-organizados 
                       (append pedidos-organizados (list pedido-atual)))
                 ;; Remove o primeiro pedido da lista de origem
                 (cond
                   [(eq? lista-origem pedidos-normais)
                    (set! pedidos-normais (cdr pedidos-normais))]
                   [(eq? lista-origem pedidos-prioritarios)
                    (set! pedidos-prioritarios (cdr pedidos-prioritarios))])
                 (send this refresh))))
         
           (define/override (on-event event)
             (when (send event button-down? 'left)
               (let ([x (send event get-x)]
                     [y (send event get-y)])
                 (cond
                   ;; Botão Desemfileira Normal
                   [(and (>= x 50) (<= x 320)
                         (>= y 580) (<= y 630)
                         (not (empty? pn)))
                    (atualizar-pedidos pedidos-normais pedidos-organizados)
                    (empilha-pedido (ultimo pn))
                    (att-pn (desempilha-pedido pn))]

                   ;; Botão Desemfileira Prioritária
                   [(and (>= x 330) (<= x 630)
                         (>= y 580) (<= y 630)
                         (not (empty? pp)))
                    (atualizar-pedidos pedidos-prioritarios pedidos-organizados)
                    (empilha-pedido (ultimo pp))
                    (att-pp (desempilha-pedido pp))]

                   ;; Botão Verificar (só funciona quando as listas estão vazias)
                   [(and (>= x 640) (<= x 820)
                         (>= y 580) (<= y 630))
                    (when (and  (empty? pp) (empty? pn) (not estado-pedidos))
                      (concluido-pedido?)
                      (send canvas refresh))]

                   ;; Botão Reiniciar
                   [(and (>= x 830) (<= x 1010)
                         (>= y 580) (<= y 630)
                         (not estado-pedidos))
                    (set! pedidos-normais (list "pn1 - 12:15" "pn2 - 12:20" "pn3 - 12:22" "pn4 - 12:23"))
                    (set! pedidos-prioritarios (list "pp1 - 12:00" "pp2 - 12:18" "pp3 - 12:21" "pp4 - 12:25"))
                    (set! pedidos-organizados '())
                    (reset-pedido)
                    (send this refresh)]

                   ;; Botão Voltar
                   [(and (>= x 1080) (<= x 1180)
                         (>= y 610) (<= y 660))
                    (send pedido show #f)]))))

           
           (define/override (on-char event)
             (when (equal? (send event get-key-code) #\space)
               (esconder-dialogo)
               (send this refresh)))
           
         
           (define/override (on-paint)
             (let ([dc (send this get-dc)])
               ;; Desenhar fundo cinza
               (send dc set-brush "gray" 'solid)
               (send dc draw-rectangle 0 0 1200 700)
             
               ;; Configurar fonte para título principal
               (send dc set-font (make-font #:size 24 #:weight 'bold))
               (send dc set-text-foreground "black")
             
               ;; Centralizar título principal
               (define main-title "Sistema de Pedidos")
               (define-values (main-width main-height _1 _2) 
                 (send dc get-text-extent main-title))
               (send dc draw-text 
                     main-title 
                     (/ (- 1200 main-width) 2)  ; centralizar horizontalmente 
                     30)  ; posição vertical do título
             
               ;; Configurar fonte para títulos dos retângulos
               (send dc set-font (make-font #:size 20  #:weight 'bold))
             
               ;; Desenhar retângulos
               (send dc set-pen "black" 2 'solid)
               (send dc set-brush "white" 'solid)
             
               ;; Retângulo 1 - Pedidos Normais
               (send dc draw-rectangle  50 160 1100 80)
               (send dc draw-text "Pedidos Normais" 50 120)
             
               ;; Retângulo 2 - Pedidos Prioritários
               (send dc draw-rectangle 50 310 1100 80)
               (send dc draw-text "Pedidos Prioritários" 50 270)
                                    
               ;; Retângulo 3 - Pedidos Organizados
               (send dc draw-rectangle  50 460 1100 80)
               (send dc draw-text "Pedidos Organizados" 50 420)

               ;; Desenhar botões na parte inferior
               (send dc set-pen "black" 2 'solid)
             
               ;; Botão 1 - Desenfileira Normal
               (send dc set-brush "lightblue" 'solid)
               (send dc draw-rectangle 50 580 270 50)
               (send dc set-font (make-font #:size 18 #:weight 'bold))
               (send dc set-text-foreground "black")
               (send dc draw-text "Desenfileira Normal" 60 590)
             
               ;; Botão 2 - Desenfileira Prioritária
               (send dc set-brush "lightgreen" 'solid)
               (send dc draw-rectangle 330 580 300 50)
               (send dc draw-text "Desenfileira Prioritária" 340 590)
             
               ;; Botão 3 - Verificar
               (send dc set-brush "lightyellow" 'solid)
               (send dc draw-rectangle 640 580 180 50)
               (send dc draw-text "Verificar" 680 590)
             
               ;; Botão 4 - Reiniciar
               (send dc set-brush "lightcoral" 'solid)
               (send dc draw-rectangle 830 580 180 50)
               (send dc draw-text "Reiniciar" 870 590)

               ;; Botão Voltar
               (send dc set-brush "lightgray" 'solid)
               (send dc draw-rectangle 1080 610 100 50)
               (send dc draw-text "Voltar" 1095 620)

               ;; Desenhar círculos Pedidos Normais
               (send dc set-pen "black" 2 'solid)
               (send dc set-font (make-font #:size 14))

               ;; Desenhar marcadores Morse fixos para pedidos normais
               (send dc set-font (make-font #:size 16 #:weight 'bold))
               (send dc set-text-foreground "black")
               (for ([x (in-list '(50 190 330 470))]
                     [morse (in-list '("." "-" "---" ".-."))])
                 (send dc draw-text morse (+ x 50) 195))

               ;; Desenhar marcadores Morse fixos para pedidos prioritários
               (for ([x (in-list '(50 190 330 470))]
                     [morse (in-list '(".." "-." "...-" "-."))])
                 (send dc draw-text morse (+ x 50) 355))

               
               ;; Desenhar círculos dos Pedidos Normais
               (send dc set-font (make-font #:size 12 #:weight 'bold))
               (when (not (null? pedidos-normais))
                 (for ([pedido (in-list (take pedidos-normais (min (length pedidos-normais) 4)))]
                       [x (in-list '(50 190 330 470))])
                   (send dc set-brush "lightblue" 'solid)
                   (send dc draw-ellipse x 170 125 55)
                   (send dc draw-text pedido (+ x 20) 190)))

               ;; Desenhar círculos dos Pedidos Prioritários
               (when (not (null? pedidos-prioritarios))
                 (for ([pedido (in-list (take pedidos-prioritarios (min (length pedidos-prioritarios) 4)))]
                       [x (in-list '(50 190 330 470))])
                   (send dc set-brush "lightgreen" 'solid)
                   (send dc draw-ellipse x 330 125 55)
                   (send dc draw-text pedido (+ x 20) 350)))

               ;; Desenhar círculos dos Pedidos Organizados
               (for ([pedido (in-list pedidos-organizados)]
                     [x (in-list (build-list (length pedidos-organizados) (lambda (n) (+ 50 (* n 135)))))])
                 (send dc set-brush "lightcoral" 'solid)
                 (send dc draw-ellipse x 470 125 55)
                 (send dc draw-text pedido (+ x 20) 490))

               ; Desenhar a caixa de diálogo
               (when mostrar-dialogo
                 ; Primeiro desenha um retângulo semi-transparente para escurecer o fundo
                 (send dc set-brush (make-object color% 0 0 0 0.5) 'solid)
                 (send dc draw-rectangle 0 650 1200 150)
            
                 ; Desenha a caixa de diálogo principal (branca)
                 (send dc set-brush "white" 'solid)
                 (send dc set-pen "black" 2 'solid)
                 (send dc draw-rectangle 0 540 1200 200)
            
                 ; Área colorida para o nome do falante
                 (send dc set-brush "lightsteelblue" 'solid)
                 (send dc draw-rectangle 0 500 1200 50)
            
                 ; Configurar fonte para o nome do falante
                 (send dc set-font (make-object font% 23 'default 'normal 'bold))
                 (send dc set-text-foreground "darkblue")
                 (send dc draw-text falante-atual 20 505)
            
                 ; Configurar fonte para o texto do diálogo
                 (send dc set-font (make-object font% 20 'default))
                 (send dc set-text-foreground "black")
            
                 ; Quebrar e desenhar o texto em múltiplas linhas
                 (let ([linhas (quebrar-texto dc texto-dialogo-atual (- 1150 40))])
                   (for/list ([linha linhas]
                              [i (in-range (length linhas))])
                     (send dc draw-text linha 20 (+ 555 (* i altura-linha)))))
            
                 ; Indicador "Espaço para passar"
                 (send dc set-font (make-object font% 14 'default 'normal 'bold))
                 (send dc set-text-foreground "gray")
                 (send dc draw-text "Pressione espaço para continuar." 880 670))))
           
           (super-new  [parent pedido] 
                       [min-width min-width]
                       [min-height min-height]))
         ))
  
 (when (not estado-pedidos)
    (iniciar-sequencia-dialogos (get-nome-robo) (Dialogo-pedido dialogo)))


  
  (send canvas focus)
  (send pedido center)
  (send pedido show #t)
)



;; ########################################### FINALIZAÇÃO ############################################

;; ########################################### TELA DO ARMAZEM DO JOGO ############################################
(define (mostrar-armazem)
  
  ; Classe canvas personalizada para lidar com eventos de teclado
  (define my-canvas%
    (class canvas%
      (super-new)
      (define/override (on-char event)
        (let* ([key (send event get-key-code)]
               [atual-x (pos-x)]
               [atual-y (pos-y)]
               [velocidade (get-velocidade)])
          (cond
            ; Movimento apenas quando o jogador não está travado
            [(and (not jogador-bloqueado?) (equal? key #\w))
             (let ([new-y (max 50 (- atual-y velocidade))])
               (if (not (verifica-colisao atual-x new-y objetos-armarios))
                   (altera-posy new-y)
                   (void)))]
            [(and (not jogador-bloqueado?) (equal? key #\s))
             (let ([new-y (min 710 (+ atual-y velocidade))])
               (if (not (verifica-colisao atual-x new-y objetos-armarios))
                   (altera-posy new-y)
                   (void)))]
            [(and (not jogador-bloqueado?) (equal? key #\a))
             (let ([new-x (max 50 (- atual-x velocidade))])
               (if (not (verifica-colisao new-x atual-y objetos-armarios))
                   (altera-posx new-x)
                   (void)))]
            [(and (not jogador-bloqueado?) (equal? key #\d))
             (let ([new-x (min 1410 (+ atual-x velocidade))])
               (if (not (verifica-colisao new-x atual-y objetos-armarios))
                   (altera-posx new-x)
                   (void)))]
            [(and (not jogador-bloqueado?) (equal? key #\e))
             (cond
               ;; A3 - Left Upper Cabinet
               [(objeto-proximo? (pos-x) (pos-y) 50 70 70 250)
                (mostrar-mensagem-dialogo (get-nome-dialogo) "")]
  
               ;; A4 - Upper Center-Left Cabinet
               [(objeto-proximo? (pos-x) (pos-y) 250 50 420 100)
                (mostrar-mensagem-dialogo (get-nome-dialogo) "")]
  
               ;; A5 - Upper Center-Right Cabinet
               [(objeto-proximo? (pos-x) (pos-y) 850 50 420 100)
                (mostrar-mensagem-dialogo (get-nome-dialogo) "")]
  
               ;; A6 - Right Upper Cabinet
               [(objeto-proximo? (pos-x) (pos-y) 1380 70 70 250)
                (mostrar-mensagem-dialogo (get-nome-dialogo) "")]
  
               ;; Kitchen Door
               [(objeto-proximo? (pos-x) (pos-y) 670 665 160 55)
                (send armazem show #f)
                (altera-posx 770)
                (altera-posy 100)
                (start-game)]
  
               ;; A1 - Bottom Left Cabinet
               [(objeto-proximo? (pos-x) (pos-y) 150 650 420 100)
                (mostrar-mensagem-dialogo (get-nome-dialogo) "")]
  
               ;; A2 - Left Lower Cabinet
               [(objeto-proximo? (pos-x) (pos-y) 50 370 70 250)
                (mostrar-mensagem-dialogo (get-nome-dialogo) "")]
  
               ;; A8 - Bottom Right Cabinet
               [(objeto-proximo? (pos-x) (pos-y) 920 650 420 100)
                (mostrar-mensagem-dialogo (get-nome-dialogo) "")]
  
               ;; A7 - Right Lower Cabinet
               [(objeto-proximo? (pos-x) (pos-y) 1380 370 70 250)
                (mostrar-mensagem-dialogo (get-nome-dialogo) "")]
  
               ;; Byte Position
               [(objeto-proximo? (pos-x) (pos-y) 1050 230 35 35)
                (mostrar-mensagem-dialogo (get-nome-dialogo) "")])]

            ; Tecla TAB para abrir o inventario
            [(and (not mostrar-dialogo) (not mapa-aberto) (equal? key #\tab))
             (alternar-inventario)]

            ; Tecla Q para explorar o mapa
            [(and (not mostrar-dialogo) (not inventario-aberto) (equal? key #\q))
             (alternar-mapa)]
            
            
            ; Tecla ESPAÇO para passar os dialogos
            [(and (not inventario-aberto) (not mapa-aberto) (equal? key #\space))
             (esconder-dialogo)])
          
          (send this refresh)))))

  (define armazem (new frame%
                      [label "O PESADELO NA COZINHA FUTURÍSTICA"]
                      [width 1500]
                      [height 800]
                      [style '(no-resize-border)]))
  

  (define canvas (new my-canvas% 
                     [parent armazem]
                     [paint-callback
                      (lambda (canvas dc)

                        ; Primeiro, preencha todo o canvas com a cor de fundo desejada
                        (send dc set-brush "brown" 'solid)  ; Aqui você pode mudar a cor
                        (send dc draw-rectangle 0 0 1500 800)   ; Desenha retângulo cobrindo todo canvas
                        
                        ; Configuração da fonte
                        (send dc set-font (make-object font% 14 'default))
                        (send dc set-text-foreground "black")

                        ; Retângulo branco para destacar o texto
                        (send dc set-brush "white" 'solid)
                        (send dc draw-rectangle 690 5 200 40)
                        
                        ; Área da cozinha
                        (send dc set-brush "beige" 'solid)
                        (send dc set-pen "black" 1 'solid)
                        (send dc draw-rectangle 50 50 1400 700)
                        (send dc draw-text "ARMAZEM" 740 10)
                        
                        ; A3
                        (send dc set-brush "gray" 'solid)
                        (send dc draw-rectangle 50 70 70 250)
                        (send dc draw-text "A3" 70 180)

                        ; A4
                        (send dc draw-rectangle 250 50 420 100)
                        (send dc draw-text "A4" 450 80)
                        
                        ; A5
                        (send dc draw-rectangle 850 50 420 100)
                        (send dc draw-text "A5" 1050 80)

                        ; A6
                        (send dc draw-rectangle 1380 70 70 250)
                        (send dc draw-text "A6" 1400 180)
                        
                        ; Bottom center door
                        (send dc set-brush "black" 'solid)
                        (send dc set-text-foreground "white")
                        (send dc draw-rectangle 670 695 160 55)
                        (send dc draw-text "Cozinha" 720 715)
                        
                        ; A1
                        (send dc set-brush "gray" 'solid)
                        (send dc set-text-foreground "black")
                        (send dc draw-rectangle 150 650 420 100)
                        (send dc draw-text "A1" 350 690)
                        
                        ; A2
                        (send dc draw-rectangle 50 370 70 250)
                        (send dc draw-text "A2" 70 480)
                        
                        ; A8
                        (send dc draw-rectangle 920 650 420 100)
                        (send dc draw-text "A8" 1150 690)
                        
                        ; A7
                        (send dc draw-rectangle 1380 370 70 250)
                        (send dc draw-text "A7" 1400 480)

                         ; Byte
                        (send dc set-brush "cyan" 'solid)
                        (send dc draw-ellipse 1050 230 35 35)
                        (send dc draw-text (get-nome-robo) 1025 205)  

                        ; Player with name
                        (send dc set-brush "red" 'solid)
                        (send dc draw-ellipse (pos-x) (pos-y) 40 40)
                        (send dc draw-text "VOCÊ" (- (pos-x) 5) (- (pos-y) 22))
                      
                        ; Mensagens de interação
                        (cond
                          ; A1
                          [(objeto-proximo? (pos-x) (pos-y) 190 630 320 100)
                           (send dc draw-text (press-e) (- (pos-x) 55) (- (pos-y) 55))]
                          
                          ; A2
                          [(objeto-proximo? (pos-x) (pos-y) 50 400 50 170)
                           (send dc draw-text (press-e) (- (pos-x) 55) (- (pos-y) 55))]
                          
                          ; A3
                          [(objeto-proximo? (pos-x) (pos-y) 50 70 50 180)
                           (send dc draw-text (press-e) (- (pos-x) 55) (- (pos-y) 55))]
                          
                          ; A4
                          [(objeto-proximo? (pos-x) (pos-y) 260 50 350 100)
                           (send dc draw-text (press-e) (- (pos-x) 55) (- (pos-y) 55))]
                          
                          ; A5
                          [(objeto-proximo? (pos-x) (pos-y) 850 50 370 100)
                           (send dc draw-text (press-e) (- (pos-x) 55) (- (pos-y) 55))]
                          
                          ; A6
                          [(objeto-proximo? (pos-x) (pos-y) 1340 70 70 200)
                           (send dc draw-text (press-e) (- (pos-x) 55) (- (pos-y) 55))]
                          
                          ; A7
                          [(objeto-proximo? (pos-x) (pos-y) 1340 380 70 180)
                           (send dc draw-text (press-e) (- (pos-x) 55) (- (pos-y) 55))]
                          
                          ; A8
                          [(objeto-proximo? (pos-x) (pos-y) 920 630 320 100)
                           (send dc draw-text (press-e) (- (pos-x) 55) (- (pos-y) 55))]
                          
                          ; Door
                          [(objeto-proximo? (pos-x) (pos-y) 670 655 130 55)
                           (send dc draw-text (press-e) (- (pos-x) 55) (- (pos-y) 55))]

                          ;; Byte
                          [(objeto-proximo? (pos-x) (pos-y) 1025 230 35 45)
                           (send dc draw-text (press-e) (- (pos-x) 55) (- (pos-y) -50))])
                        
                        
                        (when  mostrar-dialogo
                          ; Primeiro desenha um retângulo semi-transparente para escurecer o fundo
                          (send dc set-brush (make-object color% 0 0 0 0.5) 'solid)
                          (send dc draw-rectangle 0 650 1500 150)
          
                          ; Desenha a caixa de diálogo principal (branca)
                          (send dc set-brush "white" 'solid)
                          (send dc set-pen "black" 2 'solid)
                          (send dc draw-rectangle 0 630 1500 250)
          
                          ; Área colorida para o nome do falante (um retângulo mais escuro no topo)
                          (send dc set-brush "lightsteelblue" 'solid)  ; Cor suave para o fundo do nome
                          (send dc draw-rectangle 0 590 1500 50)  ; Retângulo colorido apenas para a área do nome
          
                          ; Configurar fonte para o nome do falante
                          (send dc set-font (make-object font% 23 'default 'normal 'bold))
                          (send dc set-text-foreground "darkblue")
                          (send dc draw-text falante-atual 20 595) 
          
                          ; Configurar fonte para o texto do diálogo
                          (send dc set-font (make-object font% 20 'default))
                          (send dc set-text-foreground "black")
                          
                          ; Quebrar e desenhar o texto em múltiplas linhas
                          (let ([linhas (quebrar-texto dc texto-dialogo-atual (- largura-maxima-texto 40))])
                            (for/list ([linha linhas]
                                       [i (in-range (length linhas))])
                              (send dc draw-text linha 20 (+ 640 (* i altura-linha)))))
          
                          ; Indicador "Espaço para passar"
                          (send dc set-font (make-object font% 14 'default 'normal 'bold))
                          (send dc set-text-foreground "gray")
                          (send dc draw-text "Pressione espaço para continuar." 1180 770))

                        
                        ; Desenhar o inventário quando estiver aberto
                        (when inventario-aberto
                          ; Fundo semi-transparente
                          (send dc set-brush (make-object color% 0 0 0 0.5) 'solid)
                          (send dc draw-rectangle 0 0 1500 800)
                          
                          ; Janela do inventário
                          (send dc set-brush "lightgray" 'solid)
                          (send dc set-pen "black" 2 'solid)
                          (send dc draw-rectangle 450 150 600 500)
                          
                          ; Título do inventário
                          (send dc set-font (make-object font% 24 'default 'normal 'bold))
                          (send dc set-text-foreground "black")
                          (send dc draw-text "INVENTÁRIO" 650 170)
                          
                          ; Informações do jogador
                          (send dc set-font (make-object font% 18 'default))
                          (send dc draw-text (string-append "Nome: " (Jogador-nome jogador)) 480 220)
                          
                          ; Área dos itens
                          (send dc draw-rectangle 480 260 540 350)
                          (send dc set-font (make-object font% 16 'default))
                          (send dc draw-text "Itens:" 490 270)
                          
                          ; Lista de itens (vazia por enquanto)
                          (send dc set-font (make-object font% 16 'default))
                          (visual-inventario dc)
                          
                          ; Instruções
                          (send dc set-text-foreground "black")
                          (send dc draw-text "Pressione TAB para fechar" 630 615))

                        ; Desenhar o mapa quando estiver aberto
                        (when mapa-aberto
                          ; Fundo semi-transparente
                          (send dc set-brush (make-object color% 0 0 0 0.5) 'solid)
                          (send dc draw-rectangle 0 0 1500 800)
    
                          ; Janela do mapa
                          (send dc set-brush "lightgray" 'solid)
                          (send dc set-pen "black" 2 'solid)
                          (send dc draw-rectangle 350 100 800 630)
    
                          ; Título
                          (send dc set-font (make-object font% 24 'default 'normal 'bold))
                          (send dc set-text-foreground "black")
                          (send dc draw-text "MAPA DE EXPLORAÇÃO" 570 120)

                          ; Linha separadora após o título
                          (send dc set-pen "black" 3 'solid)
                          (send dc draw-line 380 160 1120 160)
                          
                          
                          ; Informações do ambiente
                          (send dc set-font (make-object font% 18 'default))
                          (send dc draw-text "Local: Cozinha" 380 170)
    
                          ; Descrição
                          (send dc set-font (make-object font% 16 'default))
                          (send dc draw-text "Descrição:" 380 220)
                          (desenhar-texto-quebrado dc 
                                             (get-desc-ambiente jogador)
                                             380 250 
                                             700)

                          ; Linha separadora após descrição
                          (send dc draw-line 380 345 1120 345)
    
                          ; Objetos presentes
                          (send dc draw-text "Objetos presentes:" 380 350)
                          ; Exploração de objetos
                          (desenhar-objetos-rec dc (Ambiente-objetos (Jogador-localizacao jogador)) 380)
                          
                          ; Linha separadora antes das saídas
                          (send dc draw-line 380 560 1120 560)

                          ; Saídas
                          (send dc draw-text "Saídas disponíveis:" 380 570)
                          ; Exploração de saídas
                          (desenhar-saidas-rec dc (Ambiente-saidas (Jogador-localizacao jogador)) 600)

                          ; Linha separadora antes da tecla Q
                          (send dc draw-line 380 680 1120 680)
                          
                          ; Instruções
                          (send dc draw-text "Pressione Q para fechar" 620 690)))]
                     
                     [style '(border)]
                     [min-width 1500]
                     [min-height 800]))


  
  ; Mostra a janela centralizada
  (send armazem center)
  (send armazem show #t)

  (send canvas focus)
)





;; ########################################### FINALIZAÇÃO ############################################



;; ########################################### FINALIZAÇÃO ############################################




;; ########################################### FINALIZAÇÃO ############################################




;; ########################################### FINALIZAÇÃO ############################################




;(abrirTelaInicial)

(start-game)

;(mostrar-armario-verde)

;(mostrar-sala-receitas)

;(mostrar-tela-tablet)

;(mostrar-dinamica-quiz)

;(mostrar-dinamica-pedidos)

;(mostrar-armazem)