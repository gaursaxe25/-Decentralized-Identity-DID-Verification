;; Decentralized Identity (DID) Verification Contract - Corrected

;; Correct map definitions
(define-map did-registry principal (buff 100))  
(define-map verified-dids principal bool)       
;; Set or update a user's DID
(define-public (set-did (did (buff 100)))
  (begin
    (asserts! (> (len did) u0) (err u100))
    (map-set did-registry tx-sender did)
    (ok true)))

;; Mark DID as verified
(define-public (verify-did (user principal))
  (begin
    (asserts! (is-eq tx-sender user) (err u101)) ;; only self-verify for simplicity
    (map-set verified-dids user true)
    (ok true)))

;; Read-only: get DID info
(define-read-only (get-did (user principal))
  (let (
    (did (map-get? did-registry user))
    (verified (default-to false (map-get? verified-dids user)))
  )
    (match did user-did
      (ok (tuple 
        (did user-did)
        (verified verified)
      ))
      (err u102))))