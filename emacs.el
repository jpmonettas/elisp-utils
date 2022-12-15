(defvar my-emacs-theme :light)

(defun toggle-theme ()
  (interactive)
  
  (mapc #'disable-theme custom-enabled-themes)
  
  (if (equal my-emacs-theme :dark)
	  (progn
		(load-theme 'modus-operandi t)
		(setq my-emacs-theme :light))
	(progn
	  (load-theme 'doom-nord t)
	  (setq my-emacs-theme :dark))))

(defun visit-messages ()
  (interactive)
  (switch-to-buffer-other-window "*Messages*"))

(defun visit-init ()
  (interactive)
  (find-file "/home/jmonetta/.emacs.d/init.el"))

(require 'hydra)

(defhydra my-emacs-menu ()

  "My Emacs most used functions menu"

  ("t" toggle-theme "Toggle emacs theme between dark/light")
  ("m" visit-messages "Visit the messages buffer")
  ("i" visit-init "Visit the .emacs.d/init.el"))

(global-set-key (kbd "<f7>") 'my-emacs-menu/body)
