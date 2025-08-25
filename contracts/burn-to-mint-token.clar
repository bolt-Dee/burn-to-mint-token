;; ------------------------------------------------------------
;; Burn-to-Mint Governance Token (SIP-010 compatible minimal)
;; ------------------------------------------------------------
;; - Users burn STX to mint GOV tokens
;; - 1 STX burned = 1 GOV token minted
;; - Fixed supply cap
;; ------------------------------------------------------------

(define-constant ERR-CAP (err u100))
(define-constant ERR-AMOUNT (err u101))

;; Token metadata
(define-constant TOKEN-NAME "BurnMint Governance Token")
(define-constant TOKEN-SYMBOL "GOV")
(define-constant TOKEN-DECIMALS u6) ;; 1 GOV = 10^6 units
(define-constant MAX-SUPPLY u1000000) ;; 1M tokens max

;; State
(define-data-var total-supply uint u0)

(define-map balances
  { owner: principal }
  { amount: uint })

;; ---------- SIP-010 Read-only Functions ----------
(define-read-only (get-name) (ok TOKEN-NAME))
(define-read-only (get-symbol) (ok TOKEN-SYMBOL))
(define-read-only (get-decimals) (ok TOKEN-DECIMALS))
(define-read-only (get-total-supply) (ok (var-get total-supply)))
(define-read-only (get-balance (who principal))
  (ok (default-to u0 (get amount (map-get? balances { owner: who })))))


;; ---------- Transfer ----------
(define-public (transfer (amount uint) (sender principal) (recipient principal))
  (let ((sender-bal (default-to u0 (get amount (map-get? balances { owner: sender })))))
    (begin
      (asserts! (>= sender-bal amount) (err u102))
      (map-set balances { owner: sender } { amount: (- sender-bal amount) })
      (let ((rec-bal (default-to u0 (get amount (map-get? balances { owner: recipient })))))
        (map-set balances { owner: recipient } { amount: (+ rec-bal amount) })
        (ok true)))))


;; ---------- Burn STX to Mint GOV ----------
(define-public (burn-to-mint (amount uint))
  (begin
    (asserts! (> amount u0) ERR-AMOUNT)
    (let ((new-supply (+ (var-get total-supply) amount)))
      (asserts! (<= new-supply MAX-SUPPLY) ERR-CAP)
      ;; Burn STX (send to blackhole address)
      (unwrap! (stx-transfer? amount tx-sender 'SP000000000000000000002Q6VF78) ERR-AMOUNT)
      ;; Mint GOV tokens
      (let ((bal (default-to u0 (get amount (map-get? balances { owner: tx-sender })))))
        (map-set balances { owner: tx-sender } { amount: (+ bal amount) })
        (var-set total-supply new-supply)
        (ok true)))))
