;; my-web.el --- Generate static website from GNU Emacs org files

;; Written in 2018 by Mohammed Sadiq <sadiq@sadiqpk.org>

;; To the extent possible under law, the author(s) have dedicated all
;; copyright and related and neighboring rights to this software to the
;; public domain worldwide.  This software is distributed without any
;; warranty.

;; You should have received a copy of the CC0 Public Domain Dedication
;; along with this software.  If not, see
;; <https://creativecommons.org/publicdomain/zero/1.0/>.


;;; Commentary:
;; This script will help generate static html files from org-mode
;; files.  Please see the associated README.org for details.


;;; Code:

(require 'subr-x)
(require 'org)
(require 'ox-publish)
(require 'htmlize)

(setq org-html-htmlize-output-type 'css)

(defun my-web-get-keys (list)
  (let ((value "@@html:<span class=\"key\">"))
    (setq value (concat value "<span>" (car list) "</span>"))
    (setq list (cdr list))
    (dolist (element list value)
      (unless (string-empty-p element)
        (setq value (concat value " + <span>" element "</span>"))))
    (setq value (concat value "</span>@@"))))

(defun my-web-get-file-content (file)
  "Return the content of the FILE as string."
  (with-temp-buffer
    (insert-file-contents file)
    (buffer-string)))

(defun my-web-get-content (site place)
  "Return the header or footer for specific page

PLACE is a string with values either 'preamble' or 'postamble'.
SITE is user defined string Like 'blog', 'home' etc."
  (my-web-get-file-content
   (concat "src/include/" site "-" place ".html")))

(setq
 org-publish-project-alist
 `(("home"
     :base-directory "src"
     :base-extension "org"
     :publishing-directory "public"
     :recursive nil
     :html-preamble ,(my-web-get-content "home" "preamble")
     :html-postamble ,(my-web-get-content "home" "postamble")
     :publishing-function org-html-publish-to-html)

    ("resume"
     :base-directory "src/resume"
     :base-extension "org"
     :publishing-directory "public"
     :recursive nil
     :html-preamble  ,(my-web-get-content "resume" "preamble")
     :html-postamble ,(my-web-get-content "resume" "postamble")
     :publishing-function org-html-publish-to-html)

   ("blog"
    :base-directory "src/blog"
    :base-extension "org"
    :publishing-directory "public/blog"
    :recursive nil
    :html-preamble ,(my-web-get-content "blog" "preamble")
    :html-postamble ,(my-web-get-content "home" "postamble")
    :publishing-function org-html-publish-to-html)

   ("blog-images"
    :base-directory "src/blog/img"
    :base-extension ".*"
    :publishing-directory "public/blog/img"
    :recursive t
    :publishing-function org-publish-attachment)

   ("blog-posts"
    :base-directory "src/blog"
    :base-extension "org"
    :exclude "blog.org"
    :publishing-directory "public/blog"
    :recursive t
    :html-preamble ,(my-web-get-content "post" "preamble")
    :html-postamble ,(my-web-get-content "home" "postamble")
    :publishing-function org-html-publish-to-html)

   ("project-images"
    :base-directory "src/projects/img"
    :base-extension ".*"
    :publishing-directory "public/projects/img"
    :recursive t
    :publishing-function org-publish-attachment)

   ("projects"
    :base-directory "src/projects"
    :base-extension "org"
    :publishing-directory "public/projects"
    :recursive t
    :html-preamble ,(my-web-get-content "projects" "preamble")
    :html-postamble ,(my-web-get-content "projects" "postamble")
    :publishing-function org-html-publish-to-html)

    ("website"
     :components ("home" "resume" "blog" "blog-images" "blog-posts"
                  "projects" "project-images"))))

;;; my-web.el ends here
