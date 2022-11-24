(require 'cider)
(require 'hydra)

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


(cider-project-hydra

 flow-storm-dev-menu "FlowStrom dev menu"
 
 ("s" flow-storm-stop          "Stop"       "(dev/stop)")
 ("l" flow-storm-start-local  "Run local"  "(dev/start-local)")
 ("r" flow-storm-start-remote "Run remote" "(dev/start-remote)")
 ("R" flow-storm-refresh      "Refresh"    "(dev/refresh)"))

(cider-project-hydra

 hansel-dev-menu "FlowStrom dev menu"
 
 ("R" hansel-refresh "Refresh" "(dev/refresh)"))

(defvar clojure-dev-menu-name nil)

(defun clojure-dev-menu-show ()
  (interactive)
  (let ((menu-name (format "%s/body" clojure-dev-menu-name)))
	(funcall (intern menu-name))))

(define-key clojure-mode-map (kbd "<f5>") 'clojure-dev-menu-show)
(define-key cider-repl-mode-map (kbd "<f5>") 'clojure-dev-menu-show)