
;;---------------[ 🚀 COTAS AUTOMÁTICAS 🚀 ]--------------;;
;;                                                         ;;
;;  🌟------------------🌟                                ;;
;;  📜 Visão geral do programa 📜                         ;;
;;  🌟------------------🌟                                ;;
;;  Este programa insere cotas em polilinhas               ;;
;;  de forma automática!                                   ;;
;;  Polilinhas maiores que 0,5m são selecionadas e         ;;
;;  cotas são adicionadas no poste ou na cordoalha!        ;;
;;                                                         ;;
;;---------------------------------------------------------;;

```
(defun c:cotas_automaticas 
  ( / 
    cmd enx idx lbd lst off sel var vvr 
  )

  (defun *error* ( msg )
    (if (not (member msg '("Function cancelled" "quit / exit abort")))
      (princ (strcat "\nError: " msg))
    )
    (setvar 'cmdecho cmd)
    (command-s "_.Undo" "_End")
    (princ)
  )
  
  (if (= 4 (logand 4 (getvar "undoctl")))
    (command-s "_.Undo" "_Begin")
  )
  
  (setq off 2.0 ;; Deslocamento de dimensão
        lbd 0.5 ;; Dimensionar segmentos maiores que esse comprimento (definir como 0 para dimensionar todos os segmentos)
  )
  (if (setq sel (ssget (list (cons 0 "LWPOLYLINE"))))
    (progn
      (setq cmd (getvar 'cmdecho)
            off (* off (getvar 'dimtxt))
      )
      (setvar 'cmdecho 0)
      (repeat (setq idx (sslength sel))
        (setq enx (entget (ssname sel (setq idx (1- idx))))
              lst (mapcar 'cdr (vl-remove-if-not '(lambda ( x ) (= 10 (car x))) enx))
        )
        (mapcar
          '(lambda ( a b / d )
             (if (< lbd (setq d (distance a b)))
               (vl-cmdf "_.dimaligned" "_non" a "_non" b "_non"
                  (polar (polar a (angle a b) (/ d 2)) (+ (angle a b) (/ pi (if (< (car a) (car b)) 2.0 -2.0))) off)
               )
             )
           )
          lst
          (if (= 1 (logand 1 (cdr (assoc 70 enx))))
            (reverse (cons (car lst) (reverse (cdr lst))))
            (cdr lst)
          )
        )
      )
      (setvar 'cmdecho cmd)
    )
  )
  (command-s "_.Undo" "_End")
  (princ)
)
(vl-load-com)
; (c:cotas_automaticas)
;;----------------------------------------------------------------------;;
;;                  🚀      FINAL COTAS AUTOMÁTICAS   🚀               ;;
;;----------------------------------------------------------------------;;