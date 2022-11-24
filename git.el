(require 'magit)

(defun yank-github-link ()
  "Quickly share a github link of what you are seeing in a buffer. Yanks
a link you can paste in the browser."
  (interactive)
  (let* ((remote (or (magit-get-push-remote) "origin"))
		 (url (magit-get "remote" remote "url"))
		 (project (if (string-prefix-p "git" url)
					  (substring  url 15 -4)   ;; git link
					  (substring  url 19 -4))) ;; https link
		 (link (format "https://github.com/%s/blob/%s/%s#L%d"
					   project
					   (magit-get-current-branch)
					   (magit-current-file)
					   (count-lines 1 (point)))))
	(kill-new link)))
