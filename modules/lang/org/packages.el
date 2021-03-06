;; -*- no-byte-compile: t; -*-
;;; lang/org/packages.el

;; Prevent built-in Org from playing into the byte-compilation of
;; `org-plus-contrib'.
(when-let (orglib (locate-library "org" nil doom--initial-load-path))
  (setq load-path (delete (substring (file-name-directory orglib) 0 -1)
                          load-path)))

;; HACK A necessary hack because org requires a compilation step after being
;;      cloned, and during that compilation a org-version.el is generated with
;;      these two functions, which return the output of a 'git describe ...'
;;      call in the repo's root. Of course, this command won't work in a sparse
;;      clone, and more than that, initiating these compilation step is a
;;      hassle, so...
(add-hook! 'straight-use-package-pre-build-functions
  (defun +org-fix-package-h (package &rest _)
    (when (equal package "org-mode")
      (with-temp-file (expand-file-name "org-version.el" (straight--repos-dir "org-mode"))
        (insert "(fset 'org-release (lambda () \"9.4\"))\n"
                "(fset 'org-git-version #'ignore)\n"
                "(provide 'org-version)\n")))))

;; Install cutting-edge version of org-mode, and from a mirror, because
;; code.orgmode.org runs on a potato.
(package! org-mode
  :recipe (:host github
           :repo "emacs-straight/org-mode"
           :files ("*.el" "lisp/*.el" "contrib/lisp/*.el"))
  :pin "31068373dc")
;; ...And prevent other packages from pulling org; org-plus-contrib satisfies
;; the dependency already: https://github.com/raxod502/straight.el/issues/352
(package! org :recipe (:local-repo nil))

(package! avy)
(package! htmlize :pin "86f22f211e")
(package! org-superstar :pin "09ddc28383")
(package! org-yt
  :recipe (:host github :repo "TobiasZawada/org-yt")
  :pin "40cc1ac76d")
(package! ox-clip :pin "bd36f9fb4e")
(package! toc-org :pin "5deaec41ed")
(package! org-cliplink :pin "82402cae7e")

(when (featurep! :editor evil +everywhere)
  (package! evil-org
    :recipe (:host github :repo "hlissner/evil-org-mode")
    :pin "9cf661af8f"))
(when (featurep! :tools pdf)
  (package! org-pdftools :pin "8cc15bb801"))
(when (featurep! :tools magit)
  (package! orgit :pin "e147f05577"))
(when (featurep! +brain)
  (package! org-brain :pin "7ffbf6816a"))
(when (featurep! +dragndrop)
  (package! org-download :pin "46417e2bd3"))
(when (featurep! +gnuplot)
  (package! gnuplot :pin "f0001c3001")
  (package! gnuplot-mode :pin "601f639298"))
(when (featurep! +ipython) ; DEPRECATED
  (package! ob-ipython :pin "7147455230"))
(when (featurep! +jupyter)
  (package! jupyter :pin "785edbbff6"))
(when (featurep! +journal)
  (package! org-journal :pin "8bf06b28d6"))
(when (featurep! +noter)
  (package! org-noter :pin "9ead81d42d"))
(when (featurep! +pomodoro)
  (package! org-pomodoro :pin "aa07c11318"))
(when (featurep! +present)
  (package! centered-window
    :recipe (:host github :repo "anler/centered-window-mode")
    :pin "24f7c5be9d")
  (package! org-tree-slide :pin "7bf09a02bd")
  (package! org-re-reveal :pin "61549f4c00"))
(when (featurep! +roam)
  (package! org-roam :pin "963692f353")
  (when (featurep! :completion company)
    (package! company-org-roam :pin "0913d86f16")))

;;; Babel
(package! ob-async :pin "80a30b96a0")
(when (featurep! :lang crystal)
  (package! ob-crystal :pin "d84c1adee4"))
(when (featurep! :lang go)
  (package! ob-go :pin "2067ed55f4"))
(when (featurep! :lang hy)
  (package! ob-hy :pin "a42ecaf440"))
(when (featurep! :lang nim)
  (package! ob-nim :pin "bf1642cb93"))
(when (featurep! :lang racket)
  (package! ob-racket
    :recipe (:host github :repo "DEADB17/ob-racket")
    :pin "d8fd51bddb"))
(when (featurep! :lang rest)
  (package! ob-restclient :pin "f7449b2068"))
(when (featurep! :lang rust)
  (package! ob-rust :pin "6a82587598"))
(when (featurep! :lang scala)
  (package! ob-ammonite :pin "39937dff39"))

;;; Export
(when (featurep! +pandoc)
  (package! ox-pandoc :pin "aa37dc7e94"))
(when (featurep! +hugo)
  (package! ox-hugo
    :recipe (:host github :repo "kaushalmodi/ox-hugo" :nonrecursive t)
    :pin "5106b430a1"))
(when (featurep! :lang rst)
  (package! ox-rst :pin "9158bfd180"))
