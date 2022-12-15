(require 'cider)
(require 'hydra)

;;;;;;;;;;;;;;;;;;;
;; General tools ;;
;;;;;;;;;;;;;;;;;;;

(defun clj-dev-tool-java-decompile ()
  (interactive)
  (let* ((current-ns (cider-current-ns))
		 (form (cider-last-sexp))
		 (clj-cmd (format "(do (require 'clj-java-decompiler.core) (clj-java-decompiler.core/decompile %s))" form)))
	(cider-interactive-eval clj-cmd nil nil `(("ns" ,current-ns)))))

(defun clj-dev-tool-bytecode-disassemble ()
  (interactive)
  (let* ((current-ns (cider-current-ns))
		 (form (cider-last-sexp))
		 (clj-cmd (format "(do (require 'clj-java-decompiler.core) (clj-java-decompiler.core/disassemble %s))" form)))
	(cider-interactive-eval clj-cmd nil nil `(("ns" ,current-ns)))))

(defun clj-dev-tool-bench ()
  (interactive)
  (let* ((current-ns (cider-current-ns))
		 (form (cider-last-sexp))
		 (clj-cmd (format "(do (require 'criterium.core) (criterium.core/quick-bench %s))" form)))
	(cider-interactive-eval clj-cmd nil nil `(("ns" ,current-ns)))))

(defun clj-dev-tool-profile ()
  (interactive)
  (let* ((current-ns (cider-current-ns))
		 (form (cider-last-sexp))
		 (clj-cmd (format "(do (require 'clj-async-profiler.core) (clj-async-profiler.core/profile %s))" form)))
	(cider-interactive-eval clj-cmd nil nil `(("ns" ,current-ns)))
	(shell-command "firefox \"file:///tmp/clj-async-profiler/results/\"")))

(defhydra my-clojure-dev-tools ()

  "My Clojure dev tools menu"

 ("j" clj-dev-tool-java-decompile "Java decompile form")
 ("d" clj-dev-tool-bytecode-disassemble "Bytecode Disassemble form")
 ("b" clj-dev-tool-bench "Criterium bench form")
 ("p" clj-dev-tool-profile "Async profile form")
 )

;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Cider project hydras ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;

(defmacro cider-project-hydra (hy-cmd-name hy-cmd-title &rest menu-entries)
  (let* ((commands-defs (mapcar (lambda (entry)
								  (destructuring-bind (k ecmd des ccmd) entry
									`(defun ,ecmd () (interactive) (cider-interactive-eval ,ccmd))))
								menu-entries))
		 (hy-triplets (mapcar (lambda (entry)
								(destructuring-bind (k ecmd des ccmd) entry
								  `(,k ,ecmd ,des)))
							  menu-entries)))
	`(progn
	   ,@commands-defs
	   (defhydra ,hy-cmd-name ()
		 ,hy-cmd-title
		 ,@hy-triplets))))

;;;;;;;;;;;;;;;;;;;;;;;;
;; FlowStorm dev menu ;;
;;;;;;;;;;;;;;;;;;;;;;;;

(cider-project-hydra

 flow-storm-dev-menu "FlowStrom dev menu"
 
 ("s" flow-storm-stop         "Stop"       "(dev/stop)")
 ("l" flow-storm-start-local  "Run local"  "(dev/start-local)")
 ("r" flow-storm-start-remote "Run remote" "(dev/start-remote)")
 ("R" flow-storm-refresh      "Refresh"    "(dev/refresh)"))

;;;;;;;;;;;;;;;;;;;;;
;; Hansel dev menu ;;
;;;;;;;;;;;;;;;;;;;;;

(cider-project-hydra

 hansel-dev-menu "Hansel dev menu"
 
 ("R" hansel-refresh "Refresh" "(dev/refresh)"))


;;;;;;;;;;;;;;;;;;;;;;
;; Clindex dev menu ;;
;;;;;;;;;;;;;;;;;;;;;;

(cider-project-hydra

 clindex-dev-menu "Clindex dev menu"
 
 ("R" clindex-refresh "Refresh" "(workbench/refresh)"))

;;;;;;;;;;;;;;;;;;;;
;; Menu utilities ;;
;;;;;;;;;;;;;;;;;;;;

(defvar clojure-dev-menu-name nil)

(defun clojure-dev-menu-show ()
  (interactive)
  (let ((menu-name (format "%s/body" clojure-dev-menu-name)))
	(funcall (intern menu-name))))

(defun cider-tap-last-and-show-debugger ()
  (interactive)

  (cider-interactive-eval "(tap> *1)")
  (shell-command "i3-msg '[title=\"Flowstorm debugger\"] scratchpad show'"))

(define-key clojure-mode-map (kbd "<f5>") 'clojure-dev-menu-show)
(define-key cider-repl-mode-map (kbd "<f5>") 'clojure-dev-menu-show)
(define-key clojure-mode-map (kbd "<f6>") 'my-clojure-dev-tools/body)
(define-key cider-flow-storm-map (kbd "C-c C-f t") 'cider-tap-last-and-show-debugger)
