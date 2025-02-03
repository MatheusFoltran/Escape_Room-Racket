#lang racket/gui

;; Importa o módulo de implementação gráfica
(require "Implementacao_grafica.rkt")

;; Função principal que inicia o jogo
(define (main)
  (with-handlers ([exn:fail? (lambda (e)
                              (display-error-message e)
                              (exit 1))])
    (abrirTelaInicial)))

;; Função para exibir mensagens de erro de forma amigável
(define (display-error-message e)
  (message-box "Erro"
               (format "Ocorreu um erro ao iniciar o jogo:~n~a" 
                      (exn-message e))
               #f
               '(ok stop)))

;; Inicia o programa
(main)