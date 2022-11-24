(require 'hydra)

;; JDK documentation browser
(setq jdk-docs-dir '((8  . "/home/jmonetta/docs/jdk-8")
					 (11 . "/home/jmonetta/docs/jdk-11")
					 (16 . "/home/jmonetta/docs/jdk-16")))
;; this sets jdk-[VER]-docs-index
(load "/home/jmonetta/docs/jdk-8-docs-index.el")
(load "/home/jmonetta/docs/jdk-11-docs-index.el")
(load "/home/jmonetta/docs/jdk-16-docs-index.el")

(defun browse-jdk (jdk-version-num)
  (interactive)
  (let* ((index jdk-11-docs-index)
		 (docs-dir (alist-get jdk-version-num jdk-docs-dir))
		 (class (completing-read (format "JDK-%d classes: " jdk-version-num)
								 (mapcar 'car index)))
		 (doc-path (concat docs-dir "/" (alist-get class index nil nil #'string=)))
		 (browse-command "google-chrome")
		 ;; (args (concat "--app=file://" doc-path ""))
		 (args (concat "file://" doc-path ""))
		 )
    (start-process "" nil browse-command args)))

(defun browse-jdk-docs ()
  (interactive)
  (let* ((jdks '("16" "11" "8")))
	(browse-jdk (string-to-number (completing-read "JDK : " jdks)))))
