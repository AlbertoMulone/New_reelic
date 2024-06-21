# Tutorial BETA

## Struttura progetto

È composto da due cartelle principali
- modules: codice terraform di tutti i moduli con la definizione di tutte le risorse
- live: rappresenta lo stato dell'infrastruttura suddiviso per ambiente

### Moduli
- modules: cartella contenente tutti i moduli
  - signacert: è presente un modulo per componente (signacert, jimmy, nebula, parsec ecc..)

Per ogni modulo sarà presente una policy con tutti i condition alert associati.
In questo modo creeremo una policy per ambiente che potrà così avere delle regole differenti di notifica in base alle variabili d'ambiente.
Per esempio in ambiente di test potremmo avere tutti gli alert disabilitati, in collaudo avere solo l'apertura degli EST/Incident senza telefonata mentre in produzione anche la relativa chiamata al reperibile.

La nomenclatura della policy sarà `lcert <env> <nome_modulo> policy`
```
resource "newrelic_alert_policy" "lcert_signacert_policy" {
  name     = "lcert ${var.env} signacert policy"
}
```

Nel caso siano presenti più componenti per cliente (es signacert o nebula per InfoCert e Intesa), si può utilizzare la clausola `for_each` per creare dinamicamente risorse in base ad una list/set.
```
resource "newrelic_alert_policy" "lcert_signacert_policy" {
  for_each = toset(var.signacert_service_names)
  name     = "lcert ${var.env} ${each.key} policy"
}
```

All'interno del modulo saranno definiti tutti gli alert condition. Ogni modulo avrà le sue variabili personalizzate.
È importante filtrare gli host per distinguerli in base all'ambiente, per farlo ci sono due modi:
- lista hostname
- service_name/app_name + environment

La scelta è indifferente.

### Live
Sono presenti le cartelle per ogni ambiente:
- prod
- stage
- test

All'interno di ogni ambiente è presente:
- terragrunt.hcl: serve per generare in automatico i file comuni a ogni modulo/componente senza doverli ricopiare all'interno:
  - provider.tf
  - backend.tf: punterà ad una sottocartella per modulo in cui verrà salvato lo stato
- common.yml: file di variabili comuni per tutti i moduli in formato yml
- nome_modulo: una sottocartella per modulo dove viene salvato lo stato dell'infrastruttura relativa a quel componente per quell'ambiente


#### Moduli
All'interno di ogni modulo è presente il file `terragrunt.hcl` che eredita la configurazione padre con:
```
# obbligatorio
include {
  path = find_in_parent_folders()
}
```

Oltre a questo posso essere presenti diverse configruazioni:

##### full terragrunt
Solo il file `terragrunt.hcl` che creerà lui dinamicamente il main.tf
```
# per caricare le variabili comuni, opzionale se non utilizzate
locals {
  common = yamldecode(file("${find_in_parent_folders("common.yaml")}"))
}

# obbligatorio
include {
  path = find_in_parent_folders()
}

# identico al comando terraform module "signacert"
terraform {
  source = "../../../modules/signacert"
}
# identico a passare le variabili all'interno del module
inputs = {
  env                     = local.common.env
  network_envs            = local.common.network_envs
  enabled                 = local.common.enabled
  signacert_service_names = ["signabc", "signa4ice"]
}
```

##### terragrunt + terraform + variables
È possibile mantere la struttura classica di terraform se non si devono importare le variabili comuni:
- main.tf: piano di terraform, include il provider e tutti i moduli da creare con le variabili da passare
- variables.tf: dichiarazione delle variabili con il tipo associato
- terraform.tfvars: valore delle variabili

### Variabili

#### common.yml
- env: può valere "test", "coll" o "prod" a seconda dell'ambiente, per adesso è utilizzato solo nel nome della policy
- network_envs: è valorizzata con tutti i nomi delle reti a seconda dell'ambiente. Può essere utilizzata per filtrare gli host tramite la variabile valorizzata da puppet 'environmnet'
- enabled: abilita o disabilita il condition alert all'interno del modulo
