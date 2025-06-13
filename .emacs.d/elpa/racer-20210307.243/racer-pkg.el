;; -*- no-byte-compile: t; lexical-binding: nil -*-
(define-package "racer" "20210307.243"
  "Code completion, goto-definition and docs browsing for Rust via racer."
  '((emacs     "25.1")
    (rust-mode "0.2.0")
    (dash      "2.13.0")
    (s         "1.10.0")
    (f         "0.18.2")
    (pos-tip   "0.4.6"))
  :url "https://github.com/racer-rust/emacs-racer"
  :commit "1e63e98626737ea9b662d4a9b1ffd6842b1c648c"
  :revdesc "1e63e9862673"
  :keywords '("abbrev" "convenience" "matching" "rust" "tools"))
